import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

import '../utils/colors.dart';
import 'cached_image_widget.dart';

class CustomIconButton extends StatelessWidget {
  final bool isTrue;
  final String icon;
  final String checkIcon;
  final Color? color;
  final Function() onTap;
  final double iconHeight;
  final double iconWidth;
  final EdgeInsets? padding;
  final Color? buttonColor;
  final double buttonHeight;
  final double buttonWidth;

  final Color? iconColor;

  final Widget? iconWidget;

  final String title;

  final TextStyle? titleTextStyle;

  final int? titleTextSize;

  const CustomIconButton({
    super.key,
    required this.icon,
    required this.onTap,
    this.isTrue = false,
    this.checkIcon = "",
    this.color,
    this.iconHeight = 20,
    this.iconWidth = 20,
    this.padding,
    this.buttonColor,
    this.buttonWidth = 22,
    this.buttonHeight = 22,
    this.iconWidget,
    this.iconColor,
    this.title = '',
    this.titleTextStyle,
    this.titleTextSize = 14,
  });

  @override
  Widget build(BuildContext context) {
    return IconButton(
      onPressed: onTap,
      color: isTrue ? appColorPrimary : buttonColor ?? circleColor,
      padding: padding ?? EdgeInsets.all(18),
      style: ButtonStyle(
        overlayColor: WidgetStatePropertyAll(splashColor),
        visualDensity: VisualDensity.standard,
        tapTargetSize: MaterialTapTargetSize.padded,
        surfaceTintColor: WidgetStatePropertyAll(buttonColor),
        backgroundColor: WidgetStatePropertyAll(buttonColor),
      ),
      icon: Column(
        crossAxisAlignment: CrossAxisAlignment.center,
        mainAxisSize: MainAxisSize.min,
        spacing: title.isNotEmpty ? 6 : 0,
        children: [
          AnimatedSwitcher(
            duration: Duration(milliseconds: 300),
            switchInCurve: isTrue ? Curves.easeInCirc : Curves.easeOutCirc,
            transitionBuilder: (child, animation) {
              return ScaleTransition(scale: animation, child: child);
            },
            child: iconWidget ??
                CachedImageWidget(
                  key: ValueKey(isTrue),
                  // Ensures animation triggers on change
                  url: isTrue ? (checkIcon.isNotEmpty ? checkIcon : icon) : icon,
                  height: iconHeight,
                  width: iconWidth,
                  color: iconColor ?? (isTrue ? appColorPrimary : whiteColor),
                  fit: BoxFit.cover,
                ),
          ),
          if (title.isNotEmpty)
            Marquee(
              child: Text(
                title,
                maxLines: 1,
                overflow: TextOverflow.ellipsis,
                textAlign: TextAlign.center,
                style: titleTextStyle ?? secondaryTextStyle(size: titleTextSize ?? 14),
              ),
            ),
        ],
      ),
    );
  }
}