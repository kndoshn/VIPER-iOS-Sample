import UIKit

@UIApplicationMain
final class AppDelegate: UIResponder, UIApplicationDelegate {
    private var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey : Any]? = nil) -> Bool {
        let userListVC = UserListWireFrame.build()
        let historyListVC = UserHistoryListWireFrame.build()
        let userContainerVC = UserContainerViewController(listViewController: userListVC, historyViewController: historyListVC)

        window = UIWindow(frame: UIScreen.main.bounds)
        window?.rootViewController = UINavigationController(rootViewController: userContainerVC)
        window?.makeKeyAndVisible()
        return true
    }
}
