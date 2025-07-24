import UIKit
import Flutter
import AVKit
import AVFoundation

@main
@objc class AppDelegate: FlutterAppDelegate,AVPlayerViewControllerDelegate {

    let playerController = AVPlayerViewController()
    var controller: FlutterViewController!

    override func application(
        _ application: UIApplication,
        didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?
    ) -> Bool {
        GeneratedPluginRegistrant.register(with: self)

        let audioSession = AVAudioSession.sharedInstance()
        do {
            try audioSession.setCategory(.playback)
            try audioSession.setActive(true, options: [])
        } catch {
           print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }

        controller = window?.rootViewController as! FlutterViewController

        let keychainChannel = FlutterMethodChannel(name: "videoPlatform",binaryMessenger: controller.binaryMessenger)
        playerController.delegate = self

        keychainChannel.setMethodCallHandler({
                    (call: FlutterMethodCall, result: @escaping FlutterResult) -> Void in
                    if call.method == "play" {

                        if let args = call.arguments as? Dictionary<String, Any>, let data = args["data"] as? String {
                            if let videoURL = URL(string: data) {
                                let player = AVPlayer(url: videoURL)

                                self.playerController.player = player
                                self.playerController.allowsPictureInPicturePlayback = true
                                self.playerController.delegate = self
                                self.playerController.player?.play()
                                self.controller.present(self.playerController, animated : true, completion : nil)
                            }
                        } else {
                            result(FlutterError.init(code: "errorSetDebug", message: "data or format error", details: nil))
                        }

                    } else {
                        result(FlutterMethodNotImplemented)
                        return
                    }
                })

        return super.application(application, didFinishLaunchingWithOptions: launchOptions)
    }

    func playerViewController(_ playerViewController: AVPlayerViewController, restoreUserInterfaceForPictureInPictureStopWithCompletionHandler completionHandler: @escaping (Bool) -> Void) {
        controller.present(playerViewController, animated: true) {
            completionHandler(true)
        }
    }
}

