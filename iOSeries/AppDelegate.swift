//
//  AppDelegate.swift
//  iOSeries
//
//  Created by Pierre on 07/12/2016.
//  Copyright © 2016 Pierre Boudon. All rights reserved.
//

import UIKit
import CoreData
import UserNotifications

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?


    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        UNUserNotificationCenter.current().requestAuthorization(options: [.alert, .sound], completionHandler: { (accepted, error) in
            if !accepted {
                print("Notification access denied")
            }
        })
        
        let remindAction = UNNotificationAction(identifier: "remindLater", title: "Rappel moi plus tard", options: [])
        let scheduleAction = UNNotificationAction(identifier: "schedule", title: "Programmer", options: [])
        
        let category = UNNotificationCategory(identifier: "category", actions: [remindAction, scheduleAction], intentIdentifiers: [], options: [])
        UNUserNotificationCenter.current().setNotificationCategories([category])
        
        return true
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
    }

    func applicationWillTerminate(_ application: UIApplication) {
        // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
        // Saves changes in the application's managed object context before the application terminates.
        self.saveContext()
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "iOSeries")
        container.loadPersistentStores(completionHandler: { (storeDescription, error) in
            if let error = error as NSError? {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                 
                /*
                 Typical reasons for an error here include:
                 * The parent directory does not exist, cannot be created, or disallows writing.
                 * The persistent store is not accessible, due to permissions or data protection when the device is locked.
                 * The device is out of space.
                 * The store could not be migrated to the current model version.
                 Check the error message to determine what the actual problem was.
                 */
                fatalError("Unresolved error \(error), \(error.userInfo)")
            }
        })
        return container
    }()

    // MARK: - Core Data Saving support

    func saveContext () {
        let context = persistentContainer.viewContext
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                // Replace this implementation with code to handle the error appropriately.
                // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
                let nserror = error as NSError
                fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
            }
        }
    }
    
    func scheduleNotification(at date: Date, showName: String, imageURL: String) {
        UNUserNotificationCenter.current().delegate = self
        
        let calendar = Calendar(identifier: .gregorian)
        let components = calendar.dateComponents(in: .current, from: date)
        let newComponents = DateComponents(calendar: calendar, timeZone: .current, era: nil, year: components.year, month: components.month, day: components.day, hour: components.hour, minute: components.minute, second: nil, nanosecond: nil, weekday: nil, weekdayOrdinal: nil, quarter: nil, weekOfMonth: nil, weekOfYear: nil, yearForWeekOfYear: nil)
        
        let trigger = UNCalendarNotificationTrigger(dateMatching: newComponents, repeats: false)
        
        let content = UNMutableNotificationContent()
        content.title = "Rappel \(showName) ! - iOSeries"
        content.body = "N'oubliez pas de regarder le nouvel épisode de votre série \(showName)"
        content.sound = UNNotificationSound.default()
        content.categoryIdentifier = "category"
        
        if let url = URL(string: imageURL), let data = NSData(contentsOf: url) {
            if let att = UNNotificationAttachment.create(imageFileIdentifier: showName, data: data as Data, options: nil, baseURL: imageURL) {
                content.attachments = [att]
            } else {
                print("The attachment was not loaded")
            }
        } else {
            print("The attachment was not created")
        }
        
        let request = UNNotificationRequest(identifier: showName, content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("ERREUR : \(error)")
            }
        })
    }
    
    func scheduleNotificationEveryWeek(showName: String, attachment: String) {
        let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60/* *24*7 */, repeats: true)
        
        let content = UNMutableNotificationContent()
        content.title = "Rappel \(showName) hebdomadaire - iOSeries"
        content.body = "N'oublier pas de regarder le nouvel épisode de votre série \(showName)"
        content.sound = UNNotificationSound.default()
        
        if let url = URL(string: attachment), let data = NSData(contentsOf: url) {
            if let att = UNNotificationAttachment.create(imageFileIdentifier: showName, data: data as Data, options: nil, baseURL: attachment) {
                content.attachments = [att]
            } else {
                print("The attachment was not loaded")
            }
        } else {
            print("The attachment was not created")
        }
        
        let request = UNNotificationRequest(identifier: "Scheduled \(showName)", content: content, trigger: trigger)
        
        UNUserNotificationCenter.current().add(request, withCompletionHandler: { (error) in
            if let error = error {
                print("ERREUR : \(error)")
            }
        })
    }
}

// Extension for UNUserNotificationCenter Delegate
extension AppDelegate: UNUserNotificationCenterDelegate {
    func userNotificationCenter(_ center: UNUserNotificationCenter, didReceive response: UNNotificationResponse, withCompletionHandler completionHandler: @escaping () -> Void) {
        let attachment = response.notification.request.content.attachments.first
        
        if response.actionIdentifier == "remindLater" {
            let newDate = Date(timeInterval: 60, since: Date())
            
            self.scheduleNotification(at: newDate, showName: response.notification.request.identifier, imageURL: attachment!.identifier)
        } else if response.actionIdentifier == "schedule" {
            self.scheduleNotificationEveryWeek(showName: response.notification.request.identifier, attachment: attachment!.identifier)
        }
        
        completionHandler()
    }
}

// Extension for UNNotificationAttachment
extension UNNotificationAttachment {
    static func create(imageFileIdentifier: String, data: Data, options: [NSObject: AnyObject]?, baseURL: String) -> UNNotificationAttachment? {
        let fileManager = FileManager.default
        let tmpSubFolderName = ProcessInfo.processInfo.globallyUniqueString
        let tmpSubFolderURL = URL(fileURLWithPath: NSTemporaryDirectory()).appendingPathComponent(tmpSubFolderName, isDirectory: true)
        
        do {
            try fileManager.createDirectory(at: tmpSubFolderURL, withIntermediateDirectories: true, attributes: nil)
            let fileURL = tmpSubFolderURL.appendingPathComponent("\(imageFileIdentifier).png")
            
            try data.write(to: fileURL)
            let imageAttachment = try UNNotificationAttachment.init(identifier: baseURL, url: fileURL, options: options)
            
            return imageAttachment
        } catch let error {
            print(error)
        }
        
        return nil
    }
}

extension Date {
    func getDayName() -> String {
        let df = DateFormatter()
        df.dateFormat = "EEEE"
        
        let s = df.string(from: self)
        
        return s.capitalized
    }
    
    func getTimeDate() -> String {
        let df = DateFormatter()
        df.dateFormat = "HH'h'mm"
        
        return df.string(from: self)
    }
}
