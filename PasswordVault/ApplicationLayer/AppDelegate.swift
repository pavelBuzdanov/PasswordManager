//
//  AppDelegate.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 17.04.2021.
//

import UIKit
import SnapKit
import ApphudSDK
import UserNotifications
import iAd

var hasActiveSubscription: Bool {
    return Apphud.hasActiveSubscription()
}

@main
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate {
    
    var window: UIWindow?
    
    lazy var passcodeLockPresenter: PasscodeLockPresenter = {
        let configuration = PasscodeLockConfiguration()
        if configuration.repository.hasPasscode {
            let presenter = PasscodeLockPresenter(mainWindow: self.window, configuration: configuration, state: .enter)
            return presenter
        } else {
            let presenter = PasscodeLockPresenter(mainWindow: self.window, configuration: configuration, state: .set)
            return presenter
        }
    }()
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // MARK: - AppHud
        Apphud.start(apiKey: "app_KCh5sVDUotorpX1YDqJW7mtvKStmtt")
        ADClient.shared().requestAttributionDetails { (data, _) in
            if let data = data {
                Apphud.addAttribution(data: data, from: .appleSearchAds, callback: nil)
            }
        }
        registerForNotifications()
        
        // MARK: - App
        passcodeLockPresenter.present()
        return true
    }
    
    func applicationDidEnterBackground(_ application: UIApplication) {
        passcodeLockPresenter.present()
     
    }
    
    func registerForNotifications() {
        UNUserNotificationCenter.current().delegate = self
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .badge, .sound]) { (_, _) in}
        UIApplication.shared.registerForRemoteNotifications()
    }
    
    func application(_ application: UIApplication, didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        Apphud.submitPushNotificationsToken(token: deviceToken, callback: nil)
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        Apphud.handlePushNotification(apsInfo: response.notification.request.content.userInfo)
        completionHandler()
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter,
                                willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        Apphud.handlePushNotification(apsInfo: notification.request.content.userInfo)
        completionHandler([])
    }

}



