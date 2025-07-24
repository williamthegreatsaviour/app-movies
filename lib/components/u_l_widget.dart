import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';

enum SymbolTypeEnum { bullet, numbered, custom }

/// Add UL to its children
class ULWidget extends StatelessWidget {
  final List<Widget>? children;
  final double padding;
  final double spacing;
  final SymbolTypeEnum symbolType;
  final Color? symbolColor;
  final Color? textColor;
  final EdgeInsets? edgeInsets;
  final Widget? customSymbol;
  final CrossAxisAlignment? symbolCrossAxisAlignment;
  final String? prefixText;
  final Widget? titleWidget; // Used when SymbolType is Numbered

  const ULWidget(
      {this.children,
      this.padding = 8,
      this.spacing = 8,
      this.symbolType = SymbolTypeEnum.bullet,
      this.symbolColor,
      this.textColor,
      this.customSymbol,
      this.prefixText,
      this.edgeInsets,
      this.symbolCrossAxisAlignment,
      super.key,
      this.titleWidget});

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        titleWidget ?? Offstage(),
        if (titleWidget != null) 4.height,
        ...List.generate(children.validate().length, (index) {
          return Padding(
            padding: edgeInsets ?? EdgeInsets.zero,
            child: Row(
              crossAxisAlignment: CrossAxisAlignment.start,
              mainAxisSize: MainAxisSize.min,
              children: [
                symbolWidget(index).paddingSymmetric(vertical: 2),
                spacing.toInt().width,
                if (children.validate().isNotEmpty) children.validate()[index].expand(),
              ],
            ),
          );
        })
      ],
    );
  }

  /// Returns a symbol widget
  Widget symbolWidget(int index) {
    if (customSymbol != null || symbolType == SymbolTypeEnum.custom) {
      return customSymbol!;
    } else if (symbolType == SymbolTypeEnum.bullet) {
      return Text(
        '•',
        style: boldTextStyle(
          color: symbolColor ?? textPrimaryColorGlobal,
          //size: 24,
        ),
      );
    } else if (symbolType == SymbolTypeEnum.numbered) {
      return Text(
        '${prefixText.validate()} ${index + 1}.',
        style: boldTextStyle(
          color: symbolColor ?? textPrimaryColorGlobal,
        ),
      );
    }

    return Offstage();
  }
}
