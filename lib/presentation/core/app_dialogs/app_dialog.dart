part of '../widgets.dart';

Future<dynamic> showAppInfoDialog(BuildContext context,
    {String title = 'Error',
    required String description,
    String? confirmText,
    String? cancelText,
    bool isWarning = false,
    void Function()? confirmCallbackFunction,
    void Function()? cancelCallbackFunction,
    bool dismissible = false}) {
  return showDialog(
    context: context,
    barrierDismissible: dismissible,
    builder: (BuildContext context) {
      if (defaultTargetPlatform == TargetPlatform.iOS) {
        return CupertinoAlertDialog(
          title: AppText(
            text: title,
            size: AppSizes.bodySmall,
            // color: AppColors.neutral900,
            // weight: FontWeight.w600,
          ),
          content: Padding(
            padding: const EdgeInsets.only(top: 10.0),
            child: AppText(
              text: description,
              color: AppColors.neutral900,
              weight: FontWeight.w500,
              height: 1.5,
            ),
          ),
          actions: <Widget>[
            CupertinoDialogAction(
              onPressed: confirmCallbackFunction ??
                  () {
                    navigatorKey.currentState!.pop();
                  },
              child: AppText(
                  text: confirmText ?? "OK",
                  color:
                      //  ((ref.watch(themeProvider) == 'System' &&
                      //             MediaQuery.platformBrightnessOf(context) ==
                      //                 Brightness.dark) ||
                      //         ref.watch(themeProvider) == 'Dark'
                      //     ? AppColors.primaryDark
                      // :
                      AppColors.primary
                  // ),
                  // weight: FontWeight.w600,
                  ),
            ),
            if (cancelText != null)
              CupertinoDialogAction(
                onPressed: cancelCallbackFunction ??
                    () {
                      navigatorKey.currentState!.pop();
                    },
                child: AppText(
                  text: cancelText,
                  color: Colors.red,
                  // weight: FontWeight.w600,
                ),
              ),
          ],
        );
      } else {
        return AlertDialog(
          // contentPadding: const EdgeInsets.symmetric(horizontal: ),
          actionsPadding: const EdgeInsets.only(bottom: 10, right: 10),
          shape:
              RoundedRectangleBorder(borderRadius: BorderRadius.circular(12.0)),
          title: AppText(
            text: title,
            size: AppSizes.bodySmall,

            // weight: FontWeight.w600,
          ),
          content: AppText(
            text: description,
            color: AppColors.neutral900,
            weight: FontWeight.w500,
            height: 1.5,
          ),
          actions: <Widget>[
            TextButton(
              style: TextButton.styleFrom(
                  backgroundColor: Colors.black, foregroundColor: Colors.white),
              onPressed: confirmCallbackFunction ??
                  () {
                    navigatorKey.currentState!.pop();
                  },
              child: AppText(
                  text: confirmText ?? "OK",
                  color: isWarning
                      ? Colors.red
                      :
                      //  ((ref.watch(themeProvider) == 'System' &&
                      //             MediaQuery.platformBrightnessOf(context) ==
                      //                 Brightness.dark) ||
                      //         ref.watch(themeProvider) == 'Dark'
                      //     ? AppColors.primaryDark
                      // :
                      null
                  //  ),
                  // weight: FontWeight.w600,
                  ),
            ),
            if (cancelText != null)
              TextButton(
                onPressed: cancelCallbackFunction ??
                    () {
                      navigatorKey.currentState!.pop();
                    },
                child: AppText(
                  text: cancelText,
                  // color: Colors.red,
                  // weight: FontWeight.w600,
                ),
              ),
          ],
        );
      }
    },
  );
}
