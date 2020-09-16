//
//  BitirmeOdevi
//
//  Created by Burak Furkan Asilturk on 24.08.2020.
//  Copyright © 2020 Burak Furkan Asilturk. All rights reserved.
//


import UIKit
import SwiftUI

class SceneDelegate: UIResponder, UIWindowSceneDelegate {

    var window: UIWindow?

    func scene(_ scene: UIScene, willConnectTo session: UISceneSession, options connectionOptions: UIScene.ConnectionOptions) {
        let dfv = DetectFaceView()

        if let windowScene = scene as? UIWindowScene {
            let window = UIWindow(windowScene: windowScene)
            window.rootViewController = UIHostingController(rootView: dfv)
            self.window = window
            window.makeKeyAndVisible()
        }
    }

}

