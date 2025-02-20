import 'package:firebase_auth/firebase_auth.dart';
import 'package:firebase_core/firebase_core.dart';
import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:hive_flutter/hive_flutter.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';
import 'package:uber_eats_clone/presentation/core/app_colors.dart';

import 'models/country/country_ip_model.dart';
import 'presentation/features/main_screen/screens/main_screen.dart';
import 'presentation/features/sign_in/views/get_started/get_started_screen.dart';
import 'presentation/features/sign_in/views/name_screen.dart';
import 'presentation/features/sign_in/views/phone_number_screen.dart';
import 'presentation/features/sign_in/views/sign_in/sign_in_screen.dart';

final Logger logger = Logger();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() async {
  WidgetsFlutterBinding.ensureInitialized();
  await Firebase.initializeApp();
  await Hive.initFlutter();
  await registerHiveAdpapters();
  await openBoxes();

  if (Hive.box(AppBoxes.appState).get('emailLoginLink') != null) {
    // Confirm the link is a sign-in with email link.
    if (FirebaseAuth.instance.isSignInWithEmailLink(
        Hive.box(AppBoxes.appState).get('emailLoginLink'))) {
      try {
        // The client SDK will parse the code from the link for you.
        final userCredential = await FirebaseAuth.instance.signInWithEmailLink(
            email: Hive.box(AppBoxes.appState).get('email'),
            emailLink: Hive.box(AppBoxes.appState).get('emailLoginLink'));
        await Hive.box(AppBoxes.appState).put('authenticated', true);
      } catch (error) {
        logger.d('Error signing in with email link.');
      }
    }
  }
  runApp(const ProviderScope(child: UberEatsClone()));
}

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
      child: GetMaterialApp(
        builder: FToastBuilder(),
        debugShowCheckedModeBanner: false,
        navigatorKey: navigatorKey,
        title: 'Uber Eats Clone',
        theme: ThemeData(
          // checkboxTheme: CheckboxThemeData(
          //     fillColor: WidgetStateProperty.all(Colors.black),
          //     ),
          switchTheme: const SwitchThemeData(
              // thumbColor: WidgetStateProperty.lerp(Colors.white, Colors.black,0.5,(){}),
              // trackColor: WidgetStateProperty.all(AppColors.neutral300),
              ),
          badgeTheme: BadgeThemeData(backgroundColor: Colors.green.shade800),
          radioTheme: const RadioThemeData(
              // fillColor: WidgetStateProperty.all(Colors.black),
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

          // primaryColor: Colors.black, colorSchemeSeed: Colors.black,
          dividerColor: AppColors.neutral200,
          colorScheme: ColorScheme.fromSeed(
            onPrimaryContainer: Colors.black,
            primaryContainer: Colors.black,
            primaryFixed: Colors.black,
            surface: Colors.black,
            seedColor: Colors.black,
            onPrimary: Colors.black,
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
          if (Hive.box(AppBoxes.appState).get('emailLoginLink') != null) {
            return const PhoneNumberScreen();
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
