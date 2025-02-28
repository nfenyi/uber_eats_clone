part of 'widgets.dart';

void showInfoToast(String message,
    {int seconds = 3, context, Color color = Colors.black, Widget? icon}) {
  FToast fToast = FToast();
  fToast.init(context);
  Widget toast = Container(
    padding: const EdgeInsets.symmetric(horizontal: 15, vertical: 13),
    decoration: BoxDecoration(
      borderRadius: BorderRadius.circular(10),
      color: color,
    ),
    child: Row(
      mainAxisSize: MainAxisSize.min,
      children: [
        if (icon != null) icon,
        const SizedBox(width: 10),
        Expanded(
          child: AppText(
            text: message,
            size: 13.0,
            color: Colors.white,
            weight: FontWeight.w500,
            softWrap: true,
          ),
        ),
      ],
    ),
  );
  fToast.showToast(
    child: toast,
    toastDuration: Duration(seconds: seconds),
    gravity: ToastGravity.TOP,
  );
}
