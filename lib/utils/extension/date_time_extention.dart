import 'package:intl/intl.dart';

import '../constants.dart';

extension DateExtension on DateTime {
  String formatDateYYYYmmdd() {
    final formatter = DateFormat(DateFormatConst.yyyy_MM_dd);
    return formatter.format(this);
  }
}
