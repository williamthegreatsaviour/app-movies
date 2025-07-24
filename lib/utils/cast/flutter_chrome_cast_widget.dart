import 'package:flutter/material.dart';
import 'package:flutter_chrome_cast/lib.dart';
import 'package:get/get.dart';
import 'package:nb_utils/nb_utils.dart';
import 'package:streamit_laravel/components/app_scaffold.dart';
import 'package:streamit_laravel/utils/cast/controller/fc_cast_controller.dart';
import 'package:streamit_laravel/utils/colors.dart';

import '../../main.dart';

class FlutterChromeCastWidget extends StatefulWidget {
  const FlutterChromeCastWidget({super.key});

  @override
  State<FlutterChromeCastWidget> createState() => _FlutterChromeCastWidgetState();
}

class _FlutterChromeCastWidgetState extends State<FlutterChromeCastWidget> {
  final FCCast cast = Get.put(FCCast());

  @override
  void initState() {
    super.initState();
    cast.initPlatformState();
  }

  @override
  void dispose() {
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return AppScaffoldNew(
      topBarBgColor: Colors.transparent,
      appBartitleText: locale.value.screenCast,
      body: Stack(
        alignment: Alignment.center,
        children: [
          StreamBuilder<GoogleCastSession?>(
            stream: GoogleCastSessionManager.instance.currentSessionStream,
            builder: (context, snapshot) {
              final bool isConnected = GoogleCastSessionManager.instance.connectionState == GoogleCastConnectState.connected;
              return Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Icon(
                    isConnected ? Icons.cast_connected : Icons.cast,
                    size: 50,
                  ),
                  16.height,
                  OutlinedButton(
                    onPressed: () async {
                      if (isConnected) {
                        GoogleCastSessionManager.instance.endSessionAndStopCasting();
                      } else {
                        cast.loadMedia();
                      }
                    },
                    child: Text(
                      !isConnected ? "${locale.value.connectTo} ${cast.device?.friendlyName}" : "${locale.value.disconnectFrom} ${cast.device?.friendlyName}",
                      style: primaryTextStyle(color: white),
                    ),
                  )
                ],
              );
            },
          ),
          GoogleCastMiniController(
            theme: GoogleCastPlayerTheme(
              backgroundColor: appScreenBackgroundDark,
              titleTextStyle: boldTextStyle(),
              deviceTextStyle: boldTextStyle(size: 12),
              iconColor: appColorPrimary,
              imageBorderRadius: BorderRadius.circular(12),
            ),
            margin: const EdgeInsets.all(16),
            borderRadius: BorderRadius.circular(16),
            showDeviceName: true,
          ),
        ],
      ),
    );
  }
}