import 'package:cloud_firestore/cloud_firestore.dart';
import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/firebase_options.dart';
import 'package:uber_eats_clone/hive_adapters/geopoint/geopoint_adapter.dart';
import 'package:uber_eats_clone/hive_adapters/hive_credit_card/hive_credit_card_model.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/features/main_screen/screens/main_screen_wrapper.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/payment_method_screen.dart';
import 'package:uber_eats_clone/services/hive_services.dart';
import 'package:uber_eats_clone/utils/enums.dart';
import 'hive_adapters/cart_item/cart_item_model.dart';
import 'hive_adapters/country/country_ip_model.dart';
import 'presentation/constants/app_sizes.dart';
import 'presentation/features/sign_in/views/email_address/email_address_screen.dart';
import 'presentation/features/sign_in/views/get_started/get_started_screen.dart';
import 'presentation/features/sign_in/views/name/name_screen.dart';
import 'presentation/features/sign_in/views/phone_number_screen.dart';
import 'presentation/features/sign_in/views/sign_in/sign_in_screen.dart';
import 'presentation/features/sign_in/views/sign_in/sign_in_view_model.dart';
import 'repositories/user_auth/user_auth_repository_remote.dart';

final Logger logger = Logger();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await registerHiveAdpapters();
  await openBoxes();

// Check if you received the link via `getInitialLink` first
  final PendingDynamicLinkData? initialLink =
      await FirebaseDynamicLinks.instance.getInitialLink();
//TODO: Test receival of group order link
  if (initialLink != null) {
    if (FirebaseAuth.instance
        .isSignInWithEmailLink(initialLink.link.toString())) {
      // The client SDK will parse the code from the link for you.
      await FirebaseAuth.instance
          .signInWithEmailLink(
              email: Hive.box(AppBoxes.appState).get(BoxKeys.email),
              emailLink: initialLink.link.toString())
          .then((credential) async {
        try {
          await Hive.box(AppBoxes.appState).delete(BoxKeys.email);

          final snapshot = await FirebaseFirestore.instance
              .collection(FirestoreCollections.users)
              .doc(FirebaseAuth.instance.currentUser!.uid)
              .get();

          if (snapshot.exists &&
              snapshot.data() != null &&
              snapshot.data()!['onboarded'] == true) {
            await Hive.box(AppBoxes.appState).put(BoxKeys.authenticated, true);
          } else {
            await Hive.box(AppBoxes.appState)
                .put(BoxKeys.signedInWithEmail, true);
          }
        } catch (e) {
          logger.d(e.toString());
        }
      }, onError: (error) {
        logger.d(error.toString());
      });
    } else {
      final user = FirebaseAuth.instance.currentUser;
      if (user != null) {
        if (initialLink.link.toString().contains('group-order')) {
          var groupOrderId = initialLink.link.toString().split('%').last;
          DocumentReference groupOrderRef = FirebaseFirestore.instance
              .collection(FirestoreCollections.groupOrders)
              .doc(groupOrderId);
          await groupOrderRef.update({
            'persons': FieldValue.arrayUnion([user.uid])
          });
          await FirebaseFirestore.instance
              .collection(FirestoreCollections.users)
              .doc(user.uid)
              .update({
            'groupOrders': FieldValue.arrayUnion([groupOrderRef])
          });
        } else if (initialLink.link.toString().contains('gift-card')) {
          final uri = Uri.parse(initialLink.link.toString());
          var giftCardId = uri.queryParameters['id'];

          await Hive.box(AppBoxes.appState)
              .put(BoxKeys.newGiftCardId, giftCardId);
        } else {
          await user.reload();
          if (user.emailVerified) {
            await Hive.box(AppBoxes.appState)
                .put(BoxKeys.addedEmailToPhoneNumber, true);
          }
        }
      }
    }
  }

  SystemChrome.setSystemUIOverlayStyle(const SystemUiOverlayStyle(
    statusBarColor: Colors.transparent, // Or any other color you want
    // statusBarIconBrightness: Brightness.light, // For light status bar icons (white)
  ));

  runApp(const ProviderScope(child: UberEatsClone()));
}

// void dynamicLinkListen() {
//   FirebaseDynamicLinks.instance.onLink.listen((pendingDynamicLinkData) {
//     // Set up the `onLink` event listener next as it may be received here
//     if (pendingDynamicLinkData != null) {

//       //   final Uri deepLink = pendingDynamicLinkData.link;
//       //   // Example of using the dynamic link to push the user to a different screen
//       //   Navigator.pushNamed(context, deepLink.path);
//     }
//   });
// }

Future<void> registerHiveAdpapters() async {
  Hive.registerAdapter(CountryResponseAdapter());
  Hive.registerAdapter(HiveGeoPointAdapter());
  Hive.registerAdapter(CartItemAdapter());
  Hive.registerAdapter(HiveOptionAdapter());
  Hive.registerAdapter(CartProductAdapter());
  Hive.registerAdapter(HiveCreditCardAdapter());
}

Future<void> openBoxes() async {
  await HiveServices.openBoxes();
}

class UberEatsClone extends StatelessWidget {
  const UberEatsClone({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return ScrollConfiguration(
      behavior: const ScrollBehavior().copyWith(
          overscroll: false,
          scrollbars: true,
          physics: const BouncingScrollPhysics()),
      child: MaterialApp(
        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Uber Eats Clone',
        theme: ThemeData(
          progressIndicatorTheme: const ProgressIndicatorThemeData(
            color: Colors.black,
            linearTrackColor: AppColors.neutral100,
          ),
          dialogTheme: const DialogTheme(backgroundColor: Colors.white),
          sliderTheme:
              const SliderThemeData(inactiveTrackColor: AppColors.neutral100),
          dividerTheme: const DividerThemeData(color: AppColors.neutral300),
          listTileTheme: const ListTileThemeData(
              iconColor: Colors.black,
              titleAlignment: ListTileTitleAlignment.center),
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
          bottomSheetTheme:
              const BottomSheetThemeData(modalBackgroundColor: Colors.white),
          checkboxTheme: CheckboxThemeData(
            fillColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.selected)) {
                return Colors.black; // Active/checked color
              }
              return Colors.white; // Inactive/unchecked color
            }),
            checkColor:
                WidgetStateProperty.all(Colors.white), // Color of the checkmark
            overlayColor: WidgetStateProperty.resolveWith<Color?>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.hovered)) {
                return Colors.blue.withOpacity(0.2); // Hover overlay color
              }
              return null; // No overlay by default
            }),
            // side: BorderSide( // Customize the border
            //   color: Colors.grey,
            //   width: 2.0,
            // ),
            // shape: RoundedRectangleBorder( // Customize the shape
            //   borderRadius: BorderRadius.circular(5.0),
            // ),
            // visualDensity: VisualDensity.adaptivePlatformDensity, // Adjust density based on platform
            // materialTapTargetSize: MaterialTapTargetSize.shrinkWrap, // Adjust tap target size
          ),

          switchTheme: SwitchThemeData(
            trackOutlineColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled) || states.isEmpty) {
                return AppColors.neutral500; // Active/checked color
              }
              return Colors.black; // Inactive/unchecked color
            }),
            thumbColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled) || states.isEmpty) {
                return AppColors.neutral600;
              }
              return Colors.white;
            }),
            trackColor: WidgetStateProperty.resolveWith<Color>(
                (Set<WidgetState> states) {
              if (states.contains(WidgetState.disabled) || states.isEmpty) {
                return AppColors.neutral200;
              }
              return Colors.black;
            }),
          ),
          badgeTheme: BadgeThemeData(backgroundColor: Colors.green.shade800),
          radioTheme: RadioThemeData(
            fillColor: WidgetStateProperty.all(Colors.black),
          ),
          tabBarTheme: const TabBarTheme(
            // indicatorColor: Colors.black,
            labelPadding: EdgeInsets.symmetric(
                horizontal: AppSizes.horizontalPadding, vertical: 8),
            dividerColor: AppColors.neutral300,
            dividerHeight: 4,
            labelColor: Colors.black,
            tabAlignment: TabAlignment.start,
          ),
          appBarTheme: const AppBarTheme(
              elevation: 0,
              surfaceTintColor: Colors.white,
              backgroundColor: Colors.white,
              foregroundColor: Colors.black),

          primaryColor: Colors.black,
          // colorSchemeSeed: Colors.black,
          dividerColor: AppColors.neutral300,
          colorScheme: ColorScheme.fromSeed(
            // onPrimaryContainer: Colors.black,
            // primaryContainer: Colors.black,
            // primaryFixed: Colors.black,
            surface: Colors.white,
            seedColor: Colors.black,
            // onPrimary: Colors.black,
            primary: Colors.black,
          ),
          scaffoldBackgroundColor: Colors.white,
          fontFamily: 'UberMove',
          // colorSchemeSeed: Colors.black,
          useMaterial3: true,
        ),
        initialRoute: '/',
        home: ResponsiveSizer(builder: (BuildContext context,
            Orientation orientation, ScreenType screenType) {
          return const Wrapper();
        }),
      ),
    );
  }
}

class Wrapper extends ConsumerWidget {
  const Wrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return ValueListenableBuilder(
        valueListenable: HiveServices.getAuthenticationListenable,
        builder: (context, appStateBox, child) {
          // switch (UserAuthRepositoryRemote().authenticationState){

          //   case AuthState.gettingStarted:
          //     // TODO: Handle this case.
          //     throw UnimplementedError();
          //   case AuthState.registeringWithEmail:
          //     // TODO: Handle this case.
          //     throw UnimplementedError();
          //   case AuthState.registeringWithPhoneNumber:
          //     // TODO: Handle this case.
          //     throw UnimplementedError();
          //   case AuthState.addedEmailToPhoneNumber:
          //     // TODO: Handle this case.
          //     throw UnimplementedError();
          //   case AuthState.addressDetailsSaved:
          //     // TODO: Handle this case.
          //     throw UnimplementedError();
          //   case AuthState.authenticated:
          //     // TODO: Handle this case.
          //     throw UnimplementedError();
          //   case AuthState.unAuthenticated:
          //     // TODO: Handle this case.
          //     throw UnimplementedError();
          //   case AuthState.federatedRegistration:
          //     // TODO: Handle this case.
          //     throw UnimplementedError();
          // }
          if (HiveServices.shouldShowGetStarted) {
            return const GetStartedScreen();
          } else if (HiveServices.userIsRegisteringWithEmail) {
            return const PhoneNumberScreen();
          } else if (HiveServices.userAddedEmailToPhoneNumber) {
            return const NameScreen();
          } else if (HiveServices.isUserAddressDetailsSaved) {
            return const PaymentMethodScreen(
              isOnboarding: true,
            );
          } else {
            if (HiveServices.isUserAuthenticated) {
              return const SignInScreen();
            } else {
              return const MainScreenWrapper();
            }
          }
        });
  }
}
