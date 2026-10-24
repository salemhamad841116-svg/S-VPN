import Cocoa
import FlutterMacOS

@NSApplicationMain
class AppDelegate: FlutterAppDelegate {
  override func applicationDidFinishLaunching(_ notification: Notification) {
    let controller: FlutterViewController = mainFlutterWindow?.contentViewController as! FlutterViewController
    let channel = FlutterMethodChannel(
      name: "com.vpn_client.pro/vpn_control",
      binaryMessenger: controller.engine.binaryMessenger
    )
    
    channel.setMethodCallHandler { (call: FlutterMethodCall, result: @escaping FlutterResult) in
      switch call.method {
      case "connect":
        if let args = call.arguments as? [String: Any] {
          NSLog("VPN native connect received with args: %@", args)
        }
        result(true)
      case "disconnect":
        NSLog("VPN native disconnect received")
        result(true)
      case "getStatus":
        result("connected")
      default:
        result(FlutterMethodNotImplemented)
      }
    }
    
    super.applicationDidFinishLaunching(notification)
  }

  override func applicationShouldTerminateAfterLastWindowClosed(_ sender: NSApplication) -> Bool {
    return true
  }
}
