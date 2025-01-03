part of 'widgets.dart';

class AppLoader extends ConsumerWidget {
  final Color color;
  final double size;
  final Color secondRingColor;
  final Color thirdRingColor;

  const AppLoader({
    super.key,
    this.thirdRingColor = AppColors.neutral300,
    this.color = Colors.black,
    this.secondRingColor = Colors.pink,
    this.size = 30.0,
  });

  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return RepaintBoundary(
        child: CircularProgressIndicator(
      color: color,
    )
        //  LoadingAnimationWidget.discreteCircle(
        //   secondRingColor: secondRingColor,
        //   thirdRingColor: thirdRingColor,
        //   color: color ??
        //       // ((ref.watch(themeProvider) == 'System' &&
        //       //             MediaQuery.platformBrightnessOf(context) ==
        //       //                 Brightness.dark) ||
        //       //         ref.watch(themeProvider) == 'Dark'
        //       //     ? AppColors.primaryDark
        //       // :
        //       AppColors.primary
        //   //  )
        //   ,
        //   size: size,
        // ),
        );
  }
}
