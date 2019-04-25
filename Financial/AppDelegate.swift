import UIKit
import SendBirdSDK
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate, UNUserNotificationCenterDelegate, JPUSHRegisterDelegate {

    var window: UIWindow?
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // APNS
        let userNotificationCenter:UNUserNotificationCenter = UNUserNotificationCenter.current()
        let authOptions:UNAuthorizationOptions = [UNAuthorizationOptions.alert, UNAuthorizationOptions.sound, UNAuthorizationOptions.badge]
        userNotificationCenter.requestAuthorization(options: authOptions, completionHandler: { granted, error in
            if granted {
                print("agree")
                userNotificationCenter.getNotificationSettings { settings in
                    if (settings.authorizationStatus == .authorized) {
                        DispatchQueue.main.async {
                            UIApplication.shared.registerForRemoteNotifications()
                        }
                    }
                }
            } else {
                print("disagree")
            }
        })
        
        UNUserNotificationCenter.current().delegate = self
        
        // JiGuang
        let entity = JPUSHRegisterEntity()
        entity.types = NSInteger(UNAuthorizationOptions.alert.rawValue) |
            NSInteger(UNAuthorizationOptions.sound.rawValue) |
            NSInteger(UNAuthorizationOptions.badge.rawValue)
        JPUSHService.register(forRemoteNotificationConfig: entity, delegate: self)
        
        JPUSHService.setup(withOption: launchOptions, appKey: jpushAppKey, channel: jpushChannel, apsForProduction: true)
        
        return true
    }

    func application(_ application: UIApplication,
                     didRegisterForRemoteNotificationsWithDeviceToken deviceToken: Data) {
        
        print("didRegisterForRemoteNotificationsWithDeviceToken")
        // JiGuang
        JPUSHService.registerDeviceToken(deviceToken)
        
    }
    
    func application(_ application: UIApplication, didFailToRegisterForRemoteNotificationsWithError error: Error) {
        
        print("didFailToRegisterForRemoteNotificationsWithError")
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable: Any]) {
        
        print("didReceiveRemoteNotification")
        
        // JiGuang
        JPUSHService.handleRemoteNotification(userInfo)
        
    }
    
    func application(_ application: UIApplication, didReceiveRemoteNotification userInfo: [AnyHashable : Any], fetchCompletionHandler completionHandler: @escaping (UIBackgroundFetchResult) -> Void) {
        
        print("didReceiveRemoteNotificationFetch")
        
        // JiGuang
        JPUSHService.handleRemoteNotification(userInfo)
        completionHandler(UIBackgroundFetchResult.newData)
        
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, openSettingsFor notification: UNNotification?) {
        
        if let trigger = notification?.request.trigger {
            if (trigger is UNPushNotificationTrigger) {
                //从通知界面直接进入应用
            } else {
                //从通知设置界面进入应用
            }
        } else {
            //从通知设置界面进入应用
        }
        
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, willPresent notification: UNNotification!,
                                 withCompletionHandler completionHandler: ((Int) -> Void)!) {
        
        print("jpushWillPresentNotification")
        print("\(String(describing: notification))")
        // 在展示推送之前触发，可以在此替换推送内容，更改展示效果：内容、声音、角标
        let userInfo = notification.request.content.userInfo
        if let trigger = notification?.request.trigger {
            if (trigger is UNPushNotificationTrigger) {
                //从通知界面直接进入应用
                JPUSHService.handleRemoteNotification(userInfo)
            } else {
                //从通知设置界面进入应用
            }
        } else {
            //从通知设置界面进入应用
        }
        
        //需要执行这个方法，选择是否提醒用户，有Badge、Sound、Alert三种类型可以选择设置
        completionHandler(Int(UNNotificationPresentationOptions.alert.rawValue))
        
    }
    
    func jpushNotificationCenter(_ center: UNUserNotificationCenter!, didReceive response: UNNotificationResponse!, withCompletionHandler completionHandler: (() -> Void)!) {
        
        print("jpushDidReceiveResponse")
        
        // 在收到推送后触发，你原先写在 didReceiveRemoteNotification 方法里接收推送并处理相关逻辑的代码，现在需要在这个方法里也写一份
        
        let userInfo = response.notification.request.content.userInfo
        if response.notification.request.trigger is UNPushNotificationTrigger {
            JPUSHService.handleRemoteNotification(userInfo)
        } else {
            //本地通知
        }
        
        //处理通知 跳到指定界面等等
        //        let dataExample = userInfo["key"] as! String
        //        let rootView = getRootViewController()
        //        rootView.pushViewController(MessageViewController.init(type: 2), animated: true)
        //        //角标至0
        //        UIApplication.shared.applicationIconBadgeNumber = 0
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, openSettingsFor notification: UNNotification?) { }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        print("userCenterWillPresentNotification")
        
        let presentOptions:UNNotificationPresentationOptions = [UNNotificationPresentationOptions.alert, UNNotificationPresentationOptions.sound, UNNotificationPresentationOptions.badge]
        
        completionHandler(presentOptions)
        
    }
    
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        
    }
    
    func createNotification(id:String, title:String, subTitle:String, body:String, badge:NSNumber?, delay:TimeInterval, completionHandler:((Error?) -> Void)?) {
        
        let content = UNMutableNotificationContent()
        content.title = title
        content.subtitle = subTitle
        content.body = body
        content.badge = badge
        content.sound = UNNotificationSound.default
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: delay, repeats: false)
        let request = UNNotificationRequest(identifier: id, content: content, trigger: trigger)
        UNUserNotificationCenter.current().add(request, withCompletionHandler: completionHandler)
        
    }
    
    func applicationWillResignActive(_ application: UIApplication) {
        // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
        // Use this method to pause ongoing tasks, disable timers, and invalidate graphics rendering callbacks. Games should use this method to pause the game.
    }

    func applicationDidEnterBackground(_ application: UIApplication) {
        // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
        // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
    }

    func applicationWillEnterForeground(_ application: UIApplication) {
        // Called as part of the transition from the background to the active state; here you can undo many of the changes made on entering the background.
    }

    func applicationDidBecomeActive(_ application: UIApplication) {
        // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
        //角标至0
        UIApplication.shared.applicationIconBadgeNumber = 0
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
    }


}

