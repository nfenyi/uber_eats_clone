import 'package:flutter/material.dart';
import 'package:flutter_riverpod/flutter_riverpod.dart';
import 'package:fluttertoast/fluttertoast.dart';
import 'package:get/get_navigation/src/root/get_material_app.dart';
import 'package:logger/logger.dart';
import 'package:responsive_sizer/responsive_sizer.dart';

import 'presentation/features/main_screen/screens/main_screen.dart';

final Logger logger = Logger();
final GlobalKey<NavigatorState> navigatorKey = GlobalKey<NavigatorState>();

void main() {
  runApp(const ProviderScope(child: UberEatsClone()));
}

class UberEatsClone extends StatelessWidget {
  const UberEatsClone({super.key});

  // This widget is the root of your application.
  @override
  Widget build(BuildContext context) {
    return GetMaterialApp(
      builder: FToastBuilder(),
      debugShowCheckedModeBanner: false,
      navigatorKey: navigatorKey,
      title: 'Uber Eats Clone',
      theme: ThemeData(
        appBarTheme: const AppBarTheme(
          color: Colors.white,
        ),
        scaffoldBackgroundColor: Colors.white,
        fontFamily: 'UberMove',

        // This is the theme of your application.
        //
        // TRY THIS: Try running your application with "flutter run". You'll see
        // the application has a purple toolbar. Then, without quitting the app,
        // try changing the seedColor in the colorScheme below to Colors.green
        // and then invoke "hot reload" (save your changes or press the "hot
        // reload" button in a Flutter-supported IDE, or press "r" if you used
        // the command line to start the app).
        //
        // Notice that the counter didn't reset back to zero; the application
        // state is not lost during the reload. To reset the state, use hot
        // restart instead.
        //
        // This works for code too, not just values: Most code changes can be
        // tested with just a hot reload.
        colorSchemeSeed: Colors.black,
        useMaterial3: true,
      ),
      home: const Wrapper(),
    );
  }
}

class Wrapper extends ConsumerWidget {
  const Wrapper({
    super.key,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return
        //  Scaffold(
        //     body:
        //  ValueListenableBuilder(
        // valueListenable: Hive.box(AppBoxes.appState).listenable(keys: 'authenticated'),
        // builder: (context, appStateBox, child) {
        //   bool onboarded = appStateBox.get('onboarded', defaultValue: false);
        //   if (!onboarded) {
        //     return const OnboardingScreen();
        //   }
        //   bool authenticated =
        //       appStateBox.get('authenticated', defaultValue: false);

        //   if (!authenticated) {
        //     return
        ResponsiveSizer(builder: (BuildContext context, Orientation orientation,
            ScreenType screenType) {
      // return const GetStartedScreen();
      return const MainScreen();
    });
    //  ;
    // } else {
    //   return const MainScreen();
    // }
    //     },
    //   ),
    // );
  }
}
