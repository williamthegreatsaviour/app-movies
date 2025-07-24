import 'dart:async'; // Added for microtask

import 'package:flutter/material.dart';
import 'package:media_kit_video/media_kit_video.dart';
import 'package:streamit_laravel/utils/app_common.dart';
import 'package:streamit_laravel/utils/colors.dart';
import 'package:streamit_laravel/video_players/model/video_model.dart';
import 'package:streamit_laravel/video_players/video_player_controller.dart';
import 'package:streamit_laravel/video_players/y_player_material.dart';
import 'package:y_player/y_player.dart';

/// A customizable YouTube video player widget.
///
/// This widget provides a flexible way to embed and control YouTube videos
/// in a Flutter application, with options for customization and event handling.
class YPlayerWidget extends StatefulWidget {
  /// The URL of the YouTube video to play.
  final String youtubeUrl;

  /// The aspect ratio of the video player. If null, defaults to 16:9.
  final double? aspectRatio;

  /// Whether the video should start playing automatically when loaded.
  final bool autoPlay;

  /// The primary color for the player's UI elements.
  final Color? color;

  /// A widget to display while the video is not yet loaded.
  final Widget? placeholder;

  /// A widget to display while the video is loading.
  final Widget? loadingWidget;

  /// A widget to display if there's an error loading the video.
  final Widget? errorWidget;

  /// A callback that is triggered when the player's state changes.
  final YPlayerStateCallback? onStateChanged;

  /// A callback that is triggered when the video's playback progress changes.
  final YPlayerProgressCallback? onProgressChanged;

  /// A callback that is triggered when the player controller is ready.
  final Function(YPlayerController controller)? onControllerReady;

  /// A callback that is triggered when the player enters full screen mode.
  final Function()? onEnterFullScreen;

  /// A callback that is triggered when the player exits full screen mode.
  final Function()? onExitFullScreen;

  /// The margin around the seek bar.
  final EdgeInsets? seekBarMargin;

  /// The margin around the seek bar in fullscreen mode.
  final EdgeInsets? fullscreenSeekBarMargin;

  /// The margin around the bottom button bar.
  final EdgeInsets? bottomButtonBarMargin;

  /// The margin around the bottom button bar in fullscreen mode.
  final EdgeInsets? fullscreenBottomButtonBarMargin;

  /// Whether to choose the best quality automatically.
  final bool chooseBestQuality;
  final bool isTrailer;

  final VoidCallback? skipTap;
  final VoidCallback? nextEpisode;
  final bool showNextEpisodeButton;

  final String thumbnailImage;

  final SubtitleModel? subTiltle;
  final VideoPlayersController videoPlayerController;

  final String watchedTime;

  /// Constructs a YPlayer widget.
  ///
  /// The [youtubeUrl] parameter is required and should be a valid YouTube video URL.
  const YPlayerWidget(
      {super.key,
      required this.youtubeUrl,
      this.showNextEpisodeButton = false,
      this.aspectRatio,
      this.autoPlay = true,
      this.placeholder,
      required this.isTrailer,
      this.loadingWidget,
      this.errorWidget,
      this.skipTap,
      this.onStateChanged,
      this.onProgressChanged,
      this.onControllerReady,
      this.color,
      this.onEnterFullScreen,
      this.onExitFullScreen,
      this.seekBarMargin,
      this.fullscreenSeekBarMargin,
      this.bottomButtonBarMargin,
      this.fullscreenBottomButtonBarMargin,
      this.chooseBestQuality = true,
      this.nextEpisode,
      this.thumbnailImage = '',
      this.subTiltle,
      required this.videoPlayerController,
      required this.watchedTime});

  @override
  YPlayerWidgetState createState() => YPlayerWidgetState();
}

/// The state for the YPlayer widget.
///
/// This class manages the lifecycle of the video player and handles
/// initialization, playback control, and UI updates.
class YPlayerWidgetState extends State<YPlayerWidget> with SingleTickerProviderStateMixin {
  /// The controller for managing the YouTube player.
  late YPlayerController _controller;

  /// The controller for the video display.
  late VideoController _videoController;

  /// Flag to indicate whether the controller is fully initialized and ready.
  bool _isControllerReady = false;
  late ValueChanged<double> onSpeedChanged;
  double currentSpeed = 1.0;
  bool showNextButton = false;

  // Cache built widgets to avoid unnecessary rebuilds
  Widget? _cachedLoadingWidget;
  Widget? _cachedErrorWidget;
  Widget? _cachedPlaceholder;
  bool languageSelected = false;

  @override
  void initState() {
    super.initState();
    _controller = YPlayerController(
      onStateChanged: widget.onStateChanged,
      onProgressChanged: widget.onProgressChanged,
    );
    _videoController = VideoController(_controller.player);

    // Use microtask to avoid blocking UI thread
    Future.microtask(_initializePlayer);

    // Cache widgets
    _cachedLoadingWidget = widget.loadingWidget ?? const CircularProgressIndicator.adaptive();
    _cachedErrorWidget = widget.errorWidget ?? const Text('Error loading video', style: TextStyle(color: appColorPrimary));
    _cachedPlaceholder = widget.placeholder ?? const SizedBox.shrink();
  }

  /// Initializes the video player with the provided YouTube URL and settings.
  void _initializePlayer() async {
    try {
      // Attempt to initialize the player with the given YouTube URL and settings
      await _controller.initialize(
        widget.youtubeUrl,
        autoPlay: widget.autoPlay,
        aspectRatio: widget.aspectRatio,
        chooseBestQuality: widget.chooseBestQuality,
      );

      if (mounted) {
        // If the widget is still in the tree, update the state
        setState(() {
          _isControllerReady = true;
        });

        // Notify that the controller is ready, if a callback was provided
        if (widget.onControllerReady != null) {
          widget.onControllerReady!(_controller);
          if (widget.watchedTime.isNotEmpty) {
            // If a watched time is provided, seek to that position
            _controller.player.seek(_parseWatchedTime(widget.watchedTime));
          }
        }
      }
    } catch (e) {
      // Log any errors that occur during initialization
      debugPrint('YPlayer: Error initializing player: $e');
      if (mounted) {
        // If there's an error, set the controller as not ready
        setState(() {
          _isControllerReady = false;
        });
      }
    }
  }

  Duration _parseWatchedTime(String watchedTime) {
    final parts = watchedTime.split(':');
    final hours = int.parse(parts[0]);
    final minutes = int.parse(parts[1]);
    final seconds = int.parse(parts[2]);
    return Duration(hours: hours, minutes: minutes, seconds: seconds);
  }

  @override
  void dispose() {
    // Ensure the controller is properly disposed when the widget is removed

    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return LayoutBuilder(
      builder: (context, constraints) {
        // Calculate the player dimensions based on the available width and aspect ratio
        final aspectRatio = widget.aspectRatio ?? 16 / 9;
        final playerWidth = constraints.maxWidth;
        final playerHeight = playerWidth / aspectRatio;
        // Use ValueListenableBuilder to only rebuild when controller status changes
        return ValueListenableBuilder<YPlayerStatus>(
          valueListenable: _controller.statusNotifier,
          builder: (context, status, _) {
            return Container(
              width: playerWidth,
              height: playerHeight,
              color: Colors.transparent,
              child: _buildPlayerContent(
                playerWidth,
                playerHeight,
                status,
                widget.showNextEpisodeButton,
              ),
            );
          },
        );
      },
    );
  }

  /// Builds the main content of the player based on its current state.
  Widget _buildPlayerContent(double width, double height, YPlayerStatus status, bool showNextEpisodeButton) {
    if (_isControllerReady && _controller.isInitialized) {
      // Always set speed since controller does not expose currentSpeed
      _controller.speed(currentSpeed);

      // If the controller is ready and initialized, show the video player
      return YMaterialVideoControlsTheme(
        normal: YMaterialVideoControlsThemeData(
          seekBarBufferColor: Colors.grey,
          seekOnDoubleTap: true,
          seekBarPositionColor: widget.color ?? const Color(0xFFFF0000),
          seekBarThumbColor: widget.color ?? const Color(0xFFFF0000),
          seekBarMargin: widget.seekBarMargin ?? const EdgeInsets.only(left: 16, right: 16, bottom: 32),
          bottomButtonBarMargin: widget.bottomButtonBarMargin ?? const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          brightnessGesture: true,
          volumeGesture: true,
          bottomButtonBar: [
            const MaterialPositionIndicator(),
            const Spacer(),
            const YMaterialFullscreenButton(),
          ],
        ),
        fullscreen: YMaterialVideoControlsThemeData(
          volumeGesture: true,
          brightnessGesture: false,
          seekOnDoubleTap: true,
          seekBarMargin: widget.fullscreenSeekBarMargin ?? const EdgeInsets.only(left: 16, right: 16, bottom: 32),
          bottomButtonBarMargin: widget.fullscreenBottomButtonBarMargin ?? const EdgeInsets.only(left: 16, right: 16, bottom: 24),
          seekBarBufferColor: Colors.grey,
          seekBarPositionColor: widget.color ?? const Color(0xFFFF0000),
          seekBarThumbColor: widget.color ?? const Color(0xFFFF0000),
          bottomButtonBar: [
            const YMaterialPositionIndicator(),
            const Spacer(),
            const YMaterialFullscreenButton(),
          ],
        ),
        child: Video(
          controller: _videoController,
          controls: MaterialVideoControls,
          width: width,
          height: height,
          filterQuality: FilterQuality.high,
          wakelock: true,
          onEnterFullscreen: () async {
            isPipModeOn(true);
            if (widget.onEnterFullScreen != null) {
              return widget.onEnterFullScreen!();
            } else {
              return yPlayerDefaultEnterFullscreen();
            }
          },
          onExitFullscreen: () async {
            isPipModeOn(false);
            if (widget.onExitFullScreen != null) {
              return widget.onExitFullScreen!();
            } else {
              return yPlayerDefaultExitFullscreen();
            }
          },
          aspectRatio: 16 / 9,
        ),
      );
    } else if (status == YPlayerStatus.loading) {
      // If the video is still loading, show a loading indicator
      return Center(child: _cachedLoadingWidget);
    } else if (status == YPlayerStatus.error) {
      // If there was an error, show the error widget
      return Center(child: _cachedErrorWidget);
    } else {
      // For any other state, show the placeholder or an empty container
      return _cachedPlaceholder!;
    }
  }
}

class SpeedSliderSheet extends StatefulWidget {
  final double initialSpeed;
  final Color primaryColor;
  final void Function(double) onSpeedChanged;

  const SpeedSliderSheet({
    super.key,
    this.initialSpeed = 1.0,
    required this.onSpeedChanged,
    required this.primaryColor,
  });

  @override
  SpeedSliderSheetState createState() => SpeedSliderSheetState();
}

class SpeedSliderSheetState extends State<SpeedSliderSheet> {
  double _speedValue = 1.0;

  final double _minSpeed = 0.25;
  final double _maxSpeed = 2.0;

  /// Key speeds for labels
  final List<double> _keySpeeds = [0.25, 0.5, 1.0, 1.5, 2.0];

  @override
  void initState() {
    super.initState();
    _speedValue = widget.initialSpeed;
  }

  void _onChipTapped(double speed) {
    setState(() {
      _speedValue = speed;
    });
    widget.onSpeedChanged(speed);
  }

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Playback Speed",
            style: TextStyle(fontSize: 14, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          Text(
            "${_speedValue.toStringAsFixed(1)}x", // Round to 1 decimal place
            style: const TextStyle(fontSize: 16, fontWeight: FontWeight.bold),
          ),
          Slider(
            value: _speedValue,
            min: _minSpeed,
            max: _maxSpeed,
            activeColor: widget.primaryColor,
            onChanged: (value) {
              final newSpeed = (value * 10).round() / 10;
              setState(() {
                _speedValue = newSpeed;
              });
              widget.onSpeedChanged(newSpeed);
            },
          ),
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 12.0),
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: _keySpeeds.map((speed) {
                return GestureDetector(
                  onTap: () => _onChipTapped(speed),
                  child: Chip(
                    label: Text(
                      "${speed}x",
                      style: const TextStyle(fontSize: 12),
                    ),
                    shape: const RoundedRectangleBorder(borderRadius: BorderRadius.all(Radius.circular(40))),
                    backgroundColor: _speedValue == speed ? widget.primaryColor.withValues(alpha: 0.8) : Colors.transparent,
                    labelStyle: TextStyle(
                      color: _speedValue == speed ? Colors.white : Colors.black,
                    ),
                  ),
                );
              }).toList(),
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}

class QualitySelectionSheet extends StatelessWidget {
  /// The currently selected quality
  final int selectedQuality;

  /// The primary color of the app
  final Color primaryColor;

  /// List of available quality options
  final List<QualityOption> qualityOptions;

  /// Callback when a quality is selected
  final void Function(int) onQualitySelected;

  const QualitySelectionSheet({
    super.key,
    required this.selectedQuality,
    required this.qualityOptions,
    required this.onQualitySelected,
    required this.primaryColor,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        mainAxisSize: MainAxisSize.min,
        children: [
          Container(
            width: 40,
            height: 5,
            decoration: BoxDecoration(
              color: Colors.grey[400],
              borderRadius: BorderRadius.circular(10),
            ),
          ),
          const SizedBox(height: 10),
          const Text(
            "Video Quality",
            style: TextStyle(fontSize: 18, fontWeight: FontWeight.bold),
          ),
          const Divider(),
          const SizedBox(height: 10),
          ConstrainedBox(
            constraints: const BoxConstraints(maxHeight: 300),
            child: ListView.builder(
              shrinkWrap: true,
              itemCount: qualityOptions.length,
              itemBuilder: (context, index) {
                final option = qualityOptions[index];
                final isSelected = option.height == selectedQuality;

                return ListTile(
                  title: Text(option.label),
                  trailing: isSelected ? Icon(Icons.check, color: primaryColor) : null,
                  selected: isSelected,
                  selectedColor: primaryColor,
                  onTap: () {
                    Navigator.of(context).pop();
                    onQualitySelected(option.height);
                  },
                );
              },
            ),
          ),
          const SizedBox(height: 10),
        ],
      ),
    );
  }
}