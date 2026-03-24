/*
See the LICENSE.txt file for this sample’s licensing information.

Abstract:
The Application Delegate
*/

import UIKit

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(
        _ app: UIApplication,
        open url: URL,
        options: [UIApplication.OpenURLOptionsKey: Any] = [:]
    ) -> Bool {
        guard url.scheme == "moderncollections" else { return false }
        handleDeepLink(url)
        return true
    }

    private func handleDeepLink(_ url: URL) {
        // Route to the appropriate screen based on the deep link path.
        // Example URL: moderncollections://payment/success?order_id=12345
        guard let host = url.host else { return }
        switch host {
        case "payment":
            let result = url.lastPathComponent  // "success" or "failure"
            let params = URLComponents(url: url, resolvingAgainstBaseURL: false)?
                .queryItems?
                .reduce(into: [String: String]()) { $0[$1.name] = $1.value }
            print("[DeepLink] Payment \(result), params: \(params ?? [:])")
        default:
            print("[DeepLink] Unhandled path: \(url.absoluteString)")
        }
    }
}
