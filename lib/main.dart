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
import 'package:uber_eats_clone/presentation/features/main_screen/screens/main_screen_wrapper_screen.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/payment_method_screen.dart';
import 'hive_adapters/cart_item/cart_item_model.dart';
import 'hive_adapters/country/country_ip_model.dart';
import 'presentation/constants/app_sizes.dart';
import 'presentation/features/sign_in/views/get_started/get_started_screen.dart';
import 'presentation/features/sign_in/views/name_screen.dart';
import 'presentation/features/sign_in/views/phone_number_screen.dart';
import 'presentation/features/sign_in/views/sign_in/sign_in_screen.dart';
import 'presentation/services/sign_in_view_model.dart';

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
  // Hive.registerAdapter(NotificationAdapter());
}

Future<void> openBoxes() async {
  await Hive.openBox(AppBoxes.appState);
  await Hive.openBox<String>(AppBoxes.recentSearches);
  await Hive.openBox<HiveCartItem>(AppBoxes.carts);
  await Hive.openBox<HiveCartProduct>(AppBoxes.storedProducts);
  // await Hive.openBox<TransactionCategory>(AppBoxes.transactionsCategories);
  // await Hive.openBox<Goal>(AppBoxes.goals);
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
          dialogTheme: const DialogThemeData(backgroundColor: Colors.white),
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
        valueListenable: Hive.box(AppBoxes.appState)
            .listenable(keys: [BoxKeys.authenticated]),
        builder: (context, appStateBox, child) {
          bool showGetStarted =
              appStateBox.get(BoxKeys.showGetStarted, defaultValue: true);
          if (showGetStarted) {
            return const GetStartedScreen();
          }
          if (Hive.box(AppBoxes.appState).get(BoxKeys.signedInWithEmail) ==
              true) {
            return const PhoneNumberScreen();
          }
          if (Hive.box(AppBoxes.appState)
                  .get(BoxKeys.addedEmailToPhoneNumber) ==
              true) {
            return const NameScreen();
          }

          if (Hive.box(AppBoxes.appState).get(BoxKeys.addressDetailsSaved) ==
              true) {
            return const PaymentMethodScreen(
              isOnboarding: true,
            );
          }

          bool authenticated =
              appStateBox.get('authenticated', defaultValue: false);

          if (!authenticated) {
            return const SignInScreen();
          } else {
            return const MainScreenWrapperScreen();
          }
        });
  }
}

class AppBoxes {
  static const String appState = 'app_state';
  static const String recentSearches = 'recent_searches';
  static const String carts = 'cart';

  static const String storedProducts = 'stored_products';
  // static const String groupOrder = 'group_orders';

  const AppBoxes._();
}

class BoxKeys {
  static const String signedInWithEmail = 'signedInWithEmail';
  static const String addedEmailToPhoneNumber = 'addedEmailToPhoneNumber';
  static const String authenticated = 'authenticated';
  static const String addressDetailsSaved = 'addressDetailsSaved';
  static const String email = 'email';
  static const String showGetStarted = 'showGetStarted';
  static const String onboarded = 'onboarded';
  static const String country = 'country';
  static const String userInfo = 'userInfo';
  static const String activatedPromoPath = 'activatedPromoPath';
  static const String recentlyViewed = 'recentlyViewed';
  static const String firstTimeSendingGift = 'firstTimeSendingGift';
  static const String isOnboardedToUberGifts = 'isOnboardedToUberGifts';
  static const String creditCardInUse = 'creditCardInUse';

  static const String newGiftCardId = 'newGiftCardId';

  const BoxKeys._();
}
