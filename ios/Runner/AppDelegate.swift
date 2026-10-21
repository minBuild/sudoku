import AppTrackingTransparency
import Flutter
import UIKit

@main
@objc class AppDelegate: FlutterAppDelegate, FlutterImplicitEngineDelegate {
  override func application(_ application: UIApplication,
    didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
    // UMP 플러그인이 delegate.window 를 참조하므로 활성 씬의 창을 연결한다.
    NotificationCenter.default.addObserver(forName: UIScene.didActivateNotification, object: nil, queue: .main) { [weak self] n in
      guard let self, self.window == nil, let s = n.object as? UIWindowScene else { return }
      self.window = s.keyWindow ?? s.windows.first
    }
    return super.application(application, didFinishLaunchingWithOptions: launchOptions)
  }
  func didInitializeImplicitFlutterEngine(_ engineBridge: FlutterImplicitEngineBridge) {
    GeneratedPluginRegistrant.register(with: engineBridge.pluginRegistry)
    if let r = engineBridge.pluginRegistry.registrar(forPlugin: "SudokuAtt") {
      FlutterMethodChannel(name: "sudoku/att", binaryMessenger: r.messenger()).setMethodCallHandler { _, result in
        guard ATTrackingManager.trackingAuthorizationStatus == .notDetermined else { return result(nil) }
        ATTrackingManager.requestTrackingAuthorization { _ in DispatchQueue.main.async { result(nil) } }
      }
    }
  }
}
