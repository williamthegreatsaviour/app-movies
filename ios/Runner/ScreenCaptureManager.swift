import Foundation
import ReplayKit

class ScreenCaptureManager: NSObject {
    private var screenRecorder: RPScreenRecorder

    override init() {
        self.screenRecorder = RPScreenRecorder.shared()
        super.init()
    }

    func startScreenCapture() {
        screenRecorder.startCapture(handler: { (sampleBuffer, bufferType, error) in
            if let error = error {
                print("Error capturing screen: \(error.localizedDescription)")
                return
            }
            // Handle the captured screen frames
        }) { (error) in
            if let error = error {
                print("Error starting screen capture: \(error.localizedDescription)")
            }
        }
    }

    func stopScreenCapture() {
        screenRecorder.stopCapture { (error) in
            if let error = error {
                print("Error stopping screen capture: \(error.localizedDescription)")
            }
        }
    }
}
