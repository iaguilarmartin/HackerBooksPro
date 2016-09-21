//
//  AppDelegate.swift
//  HackerBooksPro
//
//  Created by Ivan Aguilar Martin on 18/9/16.
//  Copyright © 2016 Ivan Aguilar Martin. All rights reserved.
//

import UIKit
import CoreData

@UIApplicationMain
class AppDelegate: UIResponder, UIApplicationDelegate {

    var window: UIWindow?
    let model = CoreDataStack(modelName: "Model")!
    let appInitializedKey = "appinitialized"
    
    func application(_ application: UIApplication, didFinishLaunchingWithOptions launchOptions: [UIApplicationLaunchOptionsKey: Any]?) -> Bool {
        
        window = UIWindow(frame: UIScreen.main.bounds)
        
        // if it is the first time that the app is running then
        // the JSON file needs to be downloaded
        let userDefaults = UserDefaults.standard
        if !userDefaults.bool(forKey: appInitializedKey) {
            do {
                // Get JSON file with books data from local or remote
                let jsonArray = try DataDownloader.sharedInstance.downloadApplicationData()
                loadInitialData(from: jsonArray)
                
                let booksVC = BooksViewController(context: model.context)
                let booksNav = UINavigationController(rootViewController: booksVC)
                
                // If current device is an iPad then a SplitViewController is displayed
                // else LibraryViewController would be the main View Controller
                if UIDevice.current.userInterfaceIdiom == .pad {
                    
                    // We need a BookViewController to display at the rigt side of the
                    // SplitViewController
                    let bookVC = BookViewController(model: nil)
                    
                    let bookNav = UINavigationController(rootViewController: bookVC)
                    let splitVC = UISplitViewController()
                    splitVC.viewControllers = [booksNav, bookNav]
                    window?.rootViewController = splitVC
                    
                    booksVC.delegate = bookVC
                    
                } else {
                    window?.rootViewController = booksNav
                }

                window?.makeKeyAndVisible()
                
            } catch ApplicationErrors.invalidJSONURL {
                print("ERROR: Invalid JSON URL")
            } catch ApplicationErrors.wrongJSONData {
                print("ERROR: Invalid JSON data")
            } catch ApplicationErrors.unrecognizedJSONData {
                print("ERROR: Unrecognized JSON data")
            } catch {
                print("ERROR: Unknown error")
            }
            
            //userDefaults.set(true, forKey: appInitializedKey)
        }
        
       
        
        return true
    }
    
    func loadInitialData(from jsonArray: JSONArray) {
        // Proccess each JSON object inside the array
        for dict:JSONDictionary in jsonArray {

            // if the format of the JSON object is correct a new book is created
            if let title = dict["title"] as? String,
                let tagsString = dict["tags"] as? String,
                let authorsString = dict["authors"] as? String,
                let imageURL = dict["image_url"] as? String,
                let docURL = dict["pdf_url"] as? String {
                
                // Converts authos and tags strings to arrays
                let authors = authorsString.components(separatedBy: ", ")
                let tags = tagsString.components(separatedBy: ", ")
                
                // Check if the image and document string value are valid URLs
                if let image = URL(string: imageURL), let document = URL(string: docURL) {
                    let cover = Cover(imageURL: image, inContext: model.context)
                    let pdf = Document(documentURL: document, inContext: model.context)
                    let _ = Book(title: title, authors: authors, tags: tags, cover: cover, document: pdf, inContext: model.context)
                }
            }
        }
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
    }


}

