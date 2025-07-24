import 'package:flutter/material.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:webview_flutter/webview_flutter.dart';
import 'dart:async';
import 'dart:convert';

class WebViewContentWidget extends StatefulWidget {
  final WebViewController webViewController;
  final Function(Duration position, Duration duration)? onVideoProgress;

  const WebViewContentWidget({
    super.key,
    required this.webViewController,
    this.onVideoProgress,
  });

  @override
  State<WebViewContentWidget> createState() => _WebViewContentWidgetState();
}

class _WebViewContentWidgetState extends State<WebViewContentWidget> with AutomaticKeepAliveClientMixin {
  Timer? _progressTimer;

  @override
  bool get wantKeepAlive => true;

  @override
  void initState() {
    super.initState();
    //_setupVideoProgressTracking();
  }

  Future<void> _setupVideoProgressTracking() async {
    // Inject JavaScript to get video position and duration
    await widget.webViewController.runJavaScript('''
      window.getVideoProgress = function() {
        const video = document.querySelector('video');
        if (video) {
          return {
            position: video.currentTime,
            duration: video.duration
          };
        }
        return {
          position: 0,
          duration: 0
        };
      }
    ''');

    // Start periodic progress updates
    _progressTimer = Timer.periodic(const Duration(seconds: 1), (timer) async {
      try {
        final result = await widget.webViewController.runJavaScriptReturningResult('window.getVideoProgress()');
        if (widget.onVideoProgress != null) {
          // Parse the JSON result
          final Map<String, dynamic> progress = Map<String, dynamic>.from(result.toString().startsWith('{') ? json.decode(result.toString()) : {'position': 0, 'duration': 0});

          final positionSeconds = (progress['position'] as num?)?.toDouble() ?? 0.0;
          final durationSeconds = (progress['duration'] as num?)?.toDouble() ?? 0.0;

          final position = Duration(milliseconds: (positionSeconds * 1000).round());
          final duration = Duration(milliseconds: (durationSeconds * 1000).round());

          widget.onVideoProgress!(position, duration);
        }
      } catch (e) {
        log('Error getting video progress: $e');
      }
    });
  }

  @override
  void dispose() {
    _progressTimer?.cancel();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    super.build(context);
    return SizedBox(
      width: context.width(),
      height: context.height(),
      child: WebViewWidget(controller: widget.webViewController),
    );
  }
}