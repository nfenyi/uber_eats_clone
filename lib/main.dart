import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:firebase_dynamic_links/firebase_dynamic_links.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/firebase_options.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';
import 'package:uber_eats_clone/presentation/features/sign_in/views/payment_method_screen.dart';

import 'hive_models/country/country_ip_model.dart';
import 'presentation/features/main_screen/screens/main_screen.dart';
import 'presentation/features/sign_in/views/add_card.dart';
import 'presentation/features/sign_in/views/email_address_screen.dart';
import 'presentation/features/sign_in/views/get_started/get_started_screen.dart';
import 'presentation/features/sign_in/views/name_screen.dart';
import 'presentation/features/sign_in/views/phone_number_screen.dart';
import 'presentation/features/sign_in/views/sign_in/sign_in_screen.dart';

final Logger logger = Logger();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp(options: DefaultFirebaseOptions.currentPlatform);
  await Hive.initFlutter();
  await registerHiveAdpapters();
  await openBoxes();

  try {
// Check if you received the link via `getInitialLink` first
    final PendingDynamicLinkData? initialLink =
        await FirebaseDynamicLinks.instance.getInitialLink();

    if (initialLink != null) {
      if (FirebaseAuth.instance
          .isSignInWithEmailLink(initialLink.link.toString())) {
        // final Uri deepLink = initialLink.link;
        // // Example of using the dynamic link to push the user to a different screen
        // Navigator.pushNamed(context, deepLink.path);

        await FirebaseAuth.instance.signInWithEmailLink(
            email: Hive.box(AppBoxes.appState).get('email'),
            emailLink: initialLink.link.toString());
        await Hive.box(AppBoxes.appState).put('isVerifiedViaLink', true);
      }
    }
  } catch (error) {
    logger.d('Error signing in with email link.');
  }

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
  // Hive.registerAdapter(AccountAdapter());
  // Hive.registerAdapter(BudgetAdapter());
  // Hive.registerAdapter(TransactionAdapter());
  // Hive.registerAdapter(TransactionCategoryAdapter());
  // Hive.registerAdapter(GoalAdapter());
  // Hive.registerAdapter(NotificationAdapter());
}

Future<void> openBoxes() async {
  await Hive.openBox(AppBoxes.appState);
  // await Hive.openBox<AppUser>(AppBoxes.users);
  // await Hive.openBox<Account>(AppBoxes.accounts);
  // await Hive.openBox<Budget>(AppBoxes.budgets);
  // await Hive.openBox<AppNotification>(AppBoxes.notifications);
  // await Hive.openBox<AccountTransaction>(AppBoxes.transactions);
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
          iconTheme: const IconThemeData(
            color: Colors.black,
          ),
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

          // switchTheme:  SwitchThemeData(
          //     thumbColor: WidgetStateProperty.lerp(Colors.white, Colors.black,0.5,(){}),
          //     trackColor: WidgetStateProperty.all(AppColors.neutral300),
          //     ),
          badgeTheme: BadgeThemeData(backgroundColor: Colors.green.shade800),
          radioTheme: RadioThemeData(
            fillColor: WidgetStateProperty.all(Colors.black),
          ),
          tabBarTheme: const TabBarTheme(
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
          useMaterial3: false,
        ),
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
        valueListenable:
            Hive.box(AppBoxes.appState).listenable(keys: ['authenticated']),
        builder: (context, appStateBox, child) {
          bool onboarded = appStateBox.get('onboarded', defaultValue: false);
          if (!onboarded) {
            return const GetStartedScreen();
          }
          if (Hive.box(AppBoxes.appState).get('isVerifiedViaLink') == true) {
            if (Hive.box(AppBoxes.appState)
                    .get(BoxKeys.addedEmailToPhoneNumber) ==
                true) {
              return const NameScreen();
              //was testing:
              // return const EmailAddressScreen();
            }
            //if signed in with email initially
            // return const PhoneNumberScreen();
            //was testing:
            return const AddCardScreen();
          }

          if (Hive.box(AppBoxes.appState).get(BoxKeys.addressDetailsSaved) ==
              true) {
            return const PaymentMethodScreen();
          }

          bool authenticated =
              appStateBox.get('authenticated', defaultValue: false);

          if (!authenticated) {
            return const SignInScreen();
          } else {
            return const MainScreen();
          }
        });
  }
}

class AppBoxes {
  static const String appState = 'app_state';
}

class BoxKeys {
  static const String isVerifiedViaLink = 'isVerifiedViaLink';
  static const String addedEmailToPhoneNumber = 'addedEmailToPhoneNumber';
  static const String authenticated = 'authenticated';
  static const String addressDetailsSaved = 'addressDetailsSaved';
  static const String email = 'email';
  static const String isOnboarded = 'onboarded';
  static const String country = 'country';
}
