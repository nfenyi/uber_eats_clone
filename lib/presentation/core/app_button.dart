part of 'widgets.dart';

class AppButton extends ConsumerWidget {
  final bool? deactivateExpansion;
  final String text;
  final double? textSize;
  final Color? textColor;
  final FontWeight textWeight;
  final FontStyle textStyle;
  final TextDecoration textDecoration;
  final VoidCallback? callback;
  final Color? buttonColor;
  final Color loaderColor;
  final double loaderSize;
  final double? width;
  final double? height;
  final EdgeInsets? padding;
  final EdgeInsets? margin;
  final Widget? icon;
  final bool iconFirst;
  final double borderRadius;
  final bool isLoading;
  final BoxDecoration? decoration;
  final Alignment alignment;
  final bool isSecondary;
  const AppButton({
    super.key,
    required this.text,
    this.deactivateExpansion,
    this.callback,
    this.textSize,
    this.width,
    this.padding,
    this.margin,
    this.icon,
    this.decoration,
    this.height = 50.0,
    this.borderRadius = 8.0,
    this.iconFirst = false,
    this.isLoading = false,
    this.isSecondary = false,
    this.textColor,
    this.buttonColor,
    this.loaderColor = Colors.white,
    this.loaderSize = 30.0,
    this.textWeight = FontWeight.w500,
    this.textStyle = FontStyle.normal,
    this.textDecoration = TextDecoration.none,
    this.alignment = Alignment.center,
  });
  @override
  Widget build(BuildContext context, WidgetRef ref) {
    return
        // Column(
        //   children: [
        // InkWell(
        //   onTap: callback,
        //   child: Container(
        //     height: height,
        //     width: width,
        //     padding: padding,
        //     margin: margin,
        //     alignment: alignment,
        //     decoration: decoration ??
        //         BoxDecoration(
        //           color: isSecondary
        //               ? buttonColor ?? Colors.black12
        //               : callback == null
        //                   ? Colors.black12
        //                   : buttonColor ?? Colors.black,
        //           borderRadius: BorderRadius.circular(borderRadius),
        //         ),
        //     child: isLoading
        //         ? SizedBox(
        //             height: 20,
        //             width: 20,
        //             child: CircularProgressIndicator(
        //               color: isSecondary ? Colors.black : Colors.white,
        //             ),
        //           )
        //         : icon == null
        //             ? AppText(
        //                 text: text,
        //                 size: textSize ?? AppSizes.bodySmall,
        //                 color: isSecondary
        //                     ? callback == null
        //                         ? Colors.black38
        //                         : textColor ?? AppColors.primary
        //                     : callback == null
        //                         ? Colors.black38
        //                         : textColor ?? Colors.white,
        //                 weight: textWeight,
        //                 style: textStyle,
        //                 decoration: textDecoration,
        //               )
        //             : iconFirst
        //                 ? Row(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       icon!,
        //                       const Gap(5.0),
        //                       AppText(
        //                         text: text,
        //                         size: textSize ?? AppSizes.bodySmall,
        //                         color: isSecondary
        //                             ? callback == null
        //                                 ? Colors.black38
        //                                 : textColor ?? AppColors.primary
        //                             : callback == null
        //                                 ? Colors.black38
        //                                 : textColor ?? Colors.white,
        //                         weight: textWeight,
        //                         style: textStyle,
        //                         decoration: textDecoration,
        //                       ),
        //                     ],
        //                   )
        //                 : Row(
        //                     mainAxisAlignment: MainAxisAlignment.center,
        //                     children: [
        //                       AppText(
        //                         text: text,
        //                         size: textSize ?? AppSizes.bodySmall,
        //                         color: isSecondary
        //                             ? callback == null
        //                                 ? Colors.black38
        //                                 : textColor ?? AppColors.primary
        //                             : callback == null
        //                                 ? Colors.black38
        //                                 : textColor ?? Colors.white,
        //                         weight: textWeight,
        //                         style: textStyle,
        //                         decoration: textDecoration,
        //                       ),
        //                       const Gap(8.0),
        //                       icon!,
        //                     ],
        //                   ),
        //   ),
        // ),

        TextButton(
      onPressed: callback,
      style: TextButton.styleFrom(
          fixedSize: deactivateExpansion == null
              ? const Size(double.infinity, 50)
              : const Size.fromHeight(40),
          backgroundColor: isSecondary
              ? buttonColor ?? Colors.black12
              : callback == null
                  ? Colors.black12
                  : buttonColor ?? Colors.black,
          shape: RoundedRectangleBorder(
            borderRadius: BorderRadius.circular(borderRadius),
          )),
      child: isLoading
          ? Row(
              mainAxisSize: MainAxisSize.max,
              mainAxisAlignment: MainAxisAlignment.center,
              children: [
                SizedBox(
                  height: 20,
                  width: 20,
                  child: CircularProgressIndicator(
                    color: isSecondary ? Colors.black : Colors.white,
                  ),
                ),
              ],
            )
          : icon == null
              ? Row(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Expanded(
                      child: AppText(
                        text: text,
                        textAlign: TextAlign.center,
                        size: textSize ?? AppSizes.bodySmall,
                        color: isSecondary
                            ? callback == null
                                ? Colors.black38
                                : textColor ?? AppColors.primary
                            : callback == null
                                ? Colors.black38
                                : textColor ?? Colors.white,
                        weight: textWeight,
                        style: textStyle,
                        decoration: textDecoration,
                      ),
                    ),
                  ],
                )
              : iconFirst
                  ? Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        icon!,
                        const Gap(5.0),
                        AppText(
                          text: text,
                          size: textSize ?? AppSizes.bodySmall,
                          color: isSecondary
                              ? callback == null
                                  ? Colors.black38
                                  : textColor ?? AppColors.primary
                              : callback == null
                                  ? Colors.black38
                                  : textColor ?? Colors.white,
                          weight: textWeight,
                          style: textStyle,
                          decoration: textDecoration,
                        ),
                      ],
                    )
                  : Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: [
                        AppText(
                          text: text,
                          size: textSize ?? AppSizes.bodySmall,
                          color: isSecondary
                              ? callback == null
                                  ? Colors.black38
                                  : textColor ?? AppColors.primary
                              : callback == null
                                  ? Colors.black38
                                  : textColor ?? Colors.white,
                          weight: textWeight,
                          style: textStyle,
                          decoration: textDecoration,
                        ),
                        const Gap(8.0),
                        icon!,
                      ],
                    ),
    )
        //   ],
        // );
        ;
  }
}
