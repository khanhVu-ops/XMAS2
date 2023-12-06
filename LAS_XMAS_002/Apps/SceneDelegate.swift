//
//  SceneDelegate.swift
//  LAS_ANIME_004
//
//  Created by Khanh Vu on 05/10/2023.
//

import UIKit
import AVFAudio

@available(iOS 13.0, *)
class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    class var shared: SceneDelegate {
        return UIApplication.shared.connectedScenes.first?.delegate as? SceneDelegate ?? SceneDelegate()
    }
    

    
    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        
        guard let scene = (scene as? UIWindowScene) else { return }

        let rootNavigation = UINavigationController()
        rootNavigation.setNavigationBarHidden(true, animated: false)
        let homeNavigator = HomeNavigator(navigationController: rootNavigation)
        let homeVM = HomeViewModel(navigator: homeNavigator)
        let homeVC = HomeViewController(viewModel: homeVM)
        rootNavigation.viewControllers = [homeVC]
        
        self.window = UIWindow(frame: scene.coordinateSpace.bounds)
        self.window?.windowScene = scene
        window?.rootViewController = rootNavigation
        window?.makeKeyAndVisible()
        
        configureAudio()
        
    }
    
    func configureAudio() {
        do {
            try AVAudioSession.sharedInstance().setCategory(.playback, mode: .default, options: [])
            try AVAudioSession.sharedInstance().setActive(true)

        }
        catch {
            print("Setting category to AVAudioSessionCategoryPlayback failed.")
        }
    }
    
    

    func sceneDidDisconnect(_ scene: UIScene) {
        // Called as the scene is being released by the system.
        // This occurs shortly after the scene enters the background, or when its session is discarded.
        // Release any resources associated with this scene that can be re-created the next time the scene connects.
        // The scene may re-connect later, as its session was not necessarily discarded (see `application:didDiscardSceneSessions` instead).
    }

    func sceneDidBecomeActive(_ scene: UIScene) {
        // Called when the scene has moved from an inactive state to an active state.
        // Use this method to restart any tasks that were paused (or not yet started) when the scene was inactive.
    }

    func sceneWillResignActive(_ scene: UIScene) {
        // Called when the scene will move from an active state to an inactive state.
        // This may occur due to temporary interruptions (ex. an incoming phone call).
    }

    func sceneWillEnterForeground(_ scene: UIScene) {
        // Called as the scene transitions from the background to the foreground.
        // Use this method to undo the changes made on entering the background.
    }

    func sceneDidEnterBackground(_ scene: UIScene) {
        // Called as the scene transitions from the foreground to the background.
        // Use this method to save data, release shared resources, and store enough scene-specific state information
        // to restore the scene back to its current state.
    }


}

