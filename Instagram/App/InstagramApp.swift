//
//  InstagramApp.swift
//  Instagram
//
//  Created by Mario Ban on 07.12.2023..
//

import UIKit
import SwiftUI
import FirebaseCore
import RealmSwift

class AppDelegate: NSObject, UIApplicationDelegate {
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]? = nil) -> Bool {
        FirebaseApp.configure()
        initializeRealm()
        return true
    }

    private func initializeRealm() {
        // Configure the default Realm
        let config = Realm.Configuration(
            // New schema version (increase this number when you change the schema)
            schemaVersion: 1,

            // Define the migration block. This is called automatically when opening a Realm with a schema version lower than the one specified above
            migrationBlock: { migration, oldSchemaVersion in
                if oldSchemaVersion < 1 {
                    // Perform migrations here. Example:
                    // migration.enumerateObjects(ofType: SavedPost.className()) { oldObject, newObject in
                    //     // Add a new field with default values
                    //     newObject?["newFieldName"] = defaultValue
                    // }
                }
                // Add additional conditions for further schema versions
            },

            // Optional: Set this if you want to delete all data if migration is not possible
            deleteRealmIfMigrationNeeded: false
        )
        
        // Tell Realm to use this configuration for the default Realm
        Realm.Configuration.defaultConfiguration = config
        
        // Optionally, you can handle errors here, such as if Realm fails to initialize
    }
}

@main
struct InstagramApp: SwiftUI.App {
    @UIApplicationDelegateAdaptor(AppDelegate.self) var delegate
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
