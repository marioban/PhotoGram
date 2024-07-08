//
//  InstagramApp.swift
//  Instagram
//
//  Created by Mario Ban on 07.12.2023..
//

import UIKit
import SwiftUI
import FirebaseCore
import GoogleSignIn
import RealmSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        initializeRealm()
        return true
    }

    private func initializeRealm() {
        let config = Realm.Configuration(
            schemaVersion: 3,  // Make sure this is incremented from the last version
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 3 {
                    migration.enumerateObjects(ofType: SavedPost.className()) { oldObject, newObject in
                        let oldTimeStamp = oldObject?["timeStamp"] as? Date
                        newObject?["timeStamp"] = oldTimeStamp

                        if oldSchemaVersion < 2 {
                            newObject?["didLike"] = oldObject?["didLike"] ?? false
                            newObject?["username"] = oldObject?["username"] ?? "unknown"
                            newObject?["userProfileImageUrl"] = oldObject?["userProfileImageUrl"] ?? ""
                        }
                    }
                }
            },
            deleteRealmIfMigrationNeeded: false
        )
        Realm.Configuration.defaultConfiguration = config
    }
}

@main
struct InstagramApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    @StateObject private var authService = AuthService.shared
    @StateObject private var registrationViewModel = RegistrationViewModel()
    var body: some Scene {
        WindowGroup {
            ContentView()
                .environmentObject(authService) 
                .environmentObject(registrationViewModel)
                .environmentObject(SavedPostsViewModel())
        }
    }
}
