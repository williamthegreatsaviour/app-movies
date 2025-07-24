// ignore_for_file: must_be_immutable

import 'package:flutter/cupertino.dart';
import 'package:streamit_laravel/utils/colors.dart';

class ToggleWidget extends StatefulWidget {
  bool isSwitched;
  double height;
  Function(bool)? onSwitch;

  ToggleWidget({super.key, this.isSwitched = false, this.onSwitch, this.height = 20});

  @override
  ToggleSwitchState createState() => ToggleSwitchState();
}

class ToggleSwitchState extends State<ToggleWidget> {
  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: 36,
      height: widget.height,
      child: FittedBox(
        fit: BoxFit.cover,
        child: CupertinoSwitch(
          value: widget.isSwitched,
          onChanged: widget.onSwitch,
          activeTrackColor: appColorPrimary,
          inactiveTrackColor: greyBtnColor,
        ),
      ),
    );
  }
}