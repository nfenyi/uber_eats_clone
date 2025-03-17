part of 'widgets.dart';

class AppTextBadge extends StatelessWidget {
  final String text;
  final Color? color;
  const AppTextBadge({
    required this.text,
    this.color = AppColors.primary2,
    super.key,
  });

  @override
  Widget build(BuildContext context) {
    return Container(
      decoration: BoxDecoration(
        borderRadius: BorderRadius.circular(5),
        color: const Color.fromARGB(255, 206, 232, 221),
      ),
      // constraints: const BoxConstraints.tightForFinite(),
      padding: const EdgeInsets.symmetric(vertical: 3, horizontal: 8),
      child: AppText(text: text, size: 9, color: color),
    );
  }
}
