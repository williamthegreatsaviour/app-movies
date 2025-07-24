import 'package:intl/intl.dart';
import 'package:nb_utils/nb_utils.dart';

import '../constants.dart';

extension StrExt on String {
  //region DateTime
  DateTime get dateInyyyyMMddHHmmFormat {
    try {
      return DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm).parse(this);
    } catch (e) {
      try {
        return DateFormat(DateFormatConst.yyyy_MM_dd_HH_mm).parse(DateTime.parse(this).toString());
      } catch (e) {
        log('dateInyyyyMMddHHmmFormat Error in $this: $e');
        return DateTime.now();
      }
    }
  }
  String get dateInddMMMyyyyHHmmAmPmFormat {
    try {
      return DateFormat(DateFormatConst.dd_MMM_yyyy_HH_mm_a).format(dateInyyyyMMddHHmmFormat);
    } catch (e) {
      try {
        return "$dateInyyyyMMddHHmmFormat";
      } catch (e) {
        return this;
      }
    }
  }
  //endregion

  //region common
  String get firstLetter => isNotEmpty ? this[0] : '';

  String getEpisodeTitle() {
    RegExp regExp = RegExp(r'^[SE]\d*\s*[SE]\d*\s*');
    return replaceFirst(regExp, '');
  }

  String getYouTubeId({bool trimWhitespaces = true}) {
    String url = validate();
    if (!url.contains('http') && (url.length == 11)) return url;
    if (trimWhitespaces) url = url.trim();

    for (var exp in [
      RegExp(r"^https://(?:www\.|m\.)?youtube\.com/watch\?v=([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https://(?:www\.|m\.)?youtube(?:-nocookie)?\.com/embed/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https://youtu\.be/([_\-a-zA-Z0-9]{11}).*$"),
      RegExp(r"^https://(?:www\.)?youtube\.com/live/([_\-a-zA-Z0-9]{11})(?:\?.*)?$")
    ]) {
      Match? match = exp.firstMatch(url);
      if (match != null && match.groupCount >= 1) return match.group(1)!;
    }
    return '';
  }

  String? get getVimeoVideoId {
    final regExp = RegExp(r'vimeo\.com/(?:video/|)(\d+)(?:\?|$)');
    final match = regExp.firstMatch(this);
    return match != null ? match.group(1) : '';
  }

  bool get isVimeoVideLink {
    final vimeoRegex = RegExp(r'vimeo\.com/(?:video/|)(\d+)(?:\?|$)');

    // Replace `url` with the actual URL you want to check

    return vimeoRegex.hasMatch(this);
  }

  bool isValidEmail() {
    return RegExp(r'^[a-z0-9]+([\._]?[a-z0-9]+)*@[a-z0-9]+\.[a-z]{2,}$').hasMatch(this);
  }

  String getSubtitleFileURLType() {
    if(contains('vtt')) {
      return 'webvtt';
    }
    else if (contains('srt')){
      return 'srt';
    }
    else {
      return '';
    }
  }
}