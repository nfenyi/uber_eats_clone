import 'package:flutter/material.dart';
import '../constants/app_sizes.dart';

class AppText extends StatelessWidget {
  final String text;
  final double? size;
  final FontWeight? weight;
  final FontStyle style;
  final TextDecoration decoration;
  final Color? color;
  final TextAlign textAlign;
  final bool softWrap;
  final TextOverflow overflow;
  final int? maxLines;
  final double? height;

  const AppText({
    super.key,
    required this.text,
    this.size = AppSizes.bodySmaller,
    this.weight,
    this.style = FontStyle.normal,
    this.decoration = TextDecoration.none,
    this.color,
    this.textAlign = TextAlign.start,
    this.softWrap = true,
    this.overflow = TextOverflow.ellipsis,
    this.maxLines,
    this.height,
  });
  @override
  Widget build(BuildContext context) {
    return Text(
      text,
      style: TextStyle(
        fontSize: size,
        fontWeight: weight,
        fontStyle: style,
        color: color,
        decoration: decoration,
        decorationColor: color,
        height: height,
      ),
      textAlign: textAlign,
      softWrap: softWrap,
      overflow: overflow,
      maxLines: maxLines,
    );
  }
}
