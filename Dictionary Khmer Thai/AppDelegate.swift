//
//  AppDelegate.swift
//  Dictionary Khmer Thai
//
//  Created by ROS DUL on 2/8/23.
//

import UIKit
import CoreData

@main
class AppDelegate: UIResponder, UIApplicationDelegate {
      
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplication.LaunchOptionsKey: Any]?) -> Bool {
        preloadDBData()
        return true
    }

    // MARK: UISceneSession Lifecycle

    func application(_ application: UIApplication, configurationForConnecting connectingSceneSession: UISceneSession, options: UIScene.ConnectionOptions) -> UISceneConfiguration {
        // Called when a new scene session is being created.
        // Use this method to select a configuration to create the new scene with.
        return UISceneConfiguration(name: "Default Configuration", sessionRole: connectingSceneSession.role)
    }

    func application(_ application: UIApplication, didDiscardSceneSessions sceneSessions: Set<UISceneSession>) {
        // Called when the user discards a scene session.
        // If any sessions were discarded while the application was not running, this will be called shortly after application:didFinishLaunchingWithOptions.
        // Use this method to release any resources that were specific to the discarded scenes, as they will not return.
    }

    // MARK: - Core Data stack

    lazy var persistentContainer: NSPersistentContainer = {
        /*
         The persistent container for the application. This implementation
         creates and returns a container, having loaded the store for the
         application to it. This property is optional since there are legitimate
         error conditions that could cause the creation of the store to fail.
        */
        let container = NSPersistentContainer(name: "Dictionary_Khmer_Thai")
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
    
}


extension AppDelegate{
    // MARK: custome tranfer data from csv to core data
    func preloadDBData(){
        if UserDefaults.standard.bool(forKey: "preload") == false{
            // func set data
            loadFromLocalFile()
            UserDefaults.standard.set(true, forKey: "preload")
        }
    }
    
    func loadFromLocalFile() {
                let filePath = Bundle.main.path(forResource: "DictionaryData", ofType: "csv")
                let str = try? String.init(contentsOfFile: filePath!, encoding: .utf8)
                let items: [(th: String, phonitic: String, Kh: String)] = parseCsvString(csvString: str!)
                
//                let context = UIApplication.shared.delegate as? AppDelegate
                let context = (UIApplication.shared.delegate as? AppDelegate)!.persistentContainer.viewContext
        
                for item in items {
//                    print(item.th + " " + item.phonitic + " " + item.Kh)
                    
                   //MARK: save data to core Data
                    let data = Dictionary_Khmer_Thai(context: context)
                    //DictionaryKh => ឈ្មោះ table core data
                    //dictionaryData => ទាញចេញពី UIApplication.shared..
                    
                    data.thai = item.th
                    data.phonetic = item.phonitic
                    data.khmer = item.Kh
                    //វានៅក្នុង appDelegate ស្រាប់ យើងមិនបាចហៅ context.saveContext() ទេ
                    self.saveContext()
                }
            }
            
            func parseCsvString(csvString: String) -> [(String, String, String)] {
                var items: [(String, String, String)] = []
                let lines: [String] = csvString.components(separatedBy: NSCharacterSet.newlines) as [String]
                
                for line in lines {
                    var values: [String] = []
                    if line != "" {
                        if line.range(of: "\"") != nil {
                            var textToScan:String = line
                            var value:NSString?
                            var textScanner:Scanner = Scanner(string: textToScan)
                            while textScanner.string != "" {
                                
                                if (textScanner.string as NSString).substring(to: 1) == "\"" {
                                    
                                    textScanner.scanLocation += 1
                                    textScanner.scanUpTo("\"", into: &value)
                                    textScanner.scanLocation += 1
                                } else {
                                    textScanner.scanUpTo(";", into: &value)
                                }
                                
                                // Store the value into the values array
                                values.append(value! as String)
                                
                                // Retrieve the unscanned remainder of the string
                                if textScanner.scanLocation < textScanner.string.count {
                                    textToScan = (textScanner.string as NSString).substring(from: textScanner.scanLocation + 1)
                                } else {
                                    textToScan = ""
                                }
                                textScanner = Scanner(string: textToScan)
                            }
                            
                            // For a line without double quotes, we can simply separate the string
                            // by using the delimiter (e.g. comma)
                        } else  {
                            values = line.components(separatedBy: ";")
//
                        }
                        
        //                 Put the values into the tuple and add it to the items array
                        let item = (values[0], values[1], values[2])
                        items.append(item)
                    }
                }
                return items
            }
}
