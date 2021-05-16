//
//  AppDelegate.swift
//  todoey
//
//  Created by Josh Courtney on 5/4/21.
//

import UIKit
import RealmSwift

@main
class AppDelegate: UIResponder, UIApplicationDelegate {

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        
        // print(Realm.Configuration.defaultConfiguration.fileURL)
        
        // /Users/joshcourtney/Library/Developer/CoreSimulator/Devices/EBE9687B-63F8-475F-A62A-96A30F9E6D1F/data/Containers/Data/Application/3C2110D5-4DFE-407B-8897-BE83404F2105/Documents/default.realm
        
        do {
            _ = try Realm()
        } catch {
            print(error)
        }
        
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        
    }

}
