//
//  AppDelegate.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 05/10/2023.
//

import UIKit
import AVFAudio

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
    
    var window: UIWindow?
    
    class var shared: AppDelegate {
        return (UIApplication.shared.delegate as? AppDelegate) ?? AppDelegate()
    }
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Override point for customization after application launch.
        window = UIWindow(frame: UIScreen.main.bounds)
        if #available(iOS 13.0, *) {
            // SceneDelegate.swift will config
        }
        else {
            let rootNavigation = UINavigationController()
            rootNavigation.setNavigationBarHidden(true, animated: false)
            let homeNavigator = HomeNavigator(navigationController: rootNavigation)
            let homeVM = HomeViewModel(navigator: homeNavigator)
            let homeVC = HomeViewController(viewModel: homeVM)
            rootNavigation.viewControllers = [homeVC]
            
            window = UIWindow(frame: UIScreen.main.bounds)
            window?.rootViewController = rootNavigation
            window?.makeKeyAndVisible()
            
            configureAudio()
        }

        return true
    }
    
    func configureAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.ambient, mode: .default, options: .defaultToSpeaker)
            try AVAudioSession.sharedInstance().setActive(true)

        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    // MARK: UISceneSession Lifecycle
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }
    
    @available(iOS 13.0, *)
    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }
    
    
}

