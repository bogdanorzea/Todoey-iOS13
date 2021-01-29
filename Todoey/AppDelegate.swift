//
//  AppDelegate.swift
//  Destini
//
//  Created by Philipp Muellauer on 01/09/2015.
//  Copyright (c) 2015 London App Brewery. All rights reserved.
//

import UIKit
import RealmSwift

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?

    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        // Print the application path on Mac's disk
        // print(NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).last as! String)

        // Prints the Realm file location
        // print(Realm.Configuration.defaultConfiguration.fileURL)

        let config = Realm.Configuration(
            schemaVersion: 1,
            migrationBlock: { migration, oldSchemaVersion in
                if (oldSchemaVersion < 1) {
                    migration.enumerateObjects(ofType: Item.className()) { (oldObject, newObject) in
                        newObject!["dateCreatedAt"] = Date(timeIntervalSinceReferenceDate: 0)
                    }
                }
            })

        // Tell Realm to use this new configuration object for the default Realm
        Realm.Configuration.defaultConfiguration = config

        // Now that we've told Realm how to handle the schema change, opening the file
        // will automatically perform the migration
        do {
            _ = try Realm()
        } catch {
            print("Error initializing new realm: \(error)")
        }

        return true
    }
}

