//
//  CoreDataFunctions.swift
//  LocationTracker
//
//  Created by jatin verma on 30/04/21.
//

import Foundation
import CoreData
import UIKit


class CoreDataFunctions {
    static func insertLocation(lat: Double, long: Double, time: Date , isStart: Bool) {
        
        var User = [NSManagedObject]()
        
        // Get AppDelegate Object
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Get Managed Context Object with help of AppDelegate.
        let managedContext = appDelegate.managedObjectContext
        
        // Create Entity Description with your entity name.
        let entity =  NSEntityDescription.entity(forEntityName: "Locations",
                                                 in:managedContext)
        
        // Create Managed Objec with help of Entity and Managed Context.
        let userObj = NSManagedObject(entity: entity!,
                                      insertInto: managedContext)
        
        // Set the value for your represent attributes.
        userObj.setValue(lat, forKey: "latitude")
        userObj.setValue(long, forKey: "longitude")
        userObj.setValue(isStart, forKey: "isStart")
        userObj.setValue(time, forKey: "timstamp")
        
        // Handle the Exception.
        do {
            try managedContext.save() // Save Mangaged Context
            User.append(userObj) // Append your managedObject to the Database.
            
        } catch let error as NSError  {
            print("Could not save \(error), \(error.userInfo)")
        }
    }
    
    
    static func fetchLocations () -> [LTLocation]{
        // Initialize Fetch Request
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>()
        
        // Get AppDelegate Object
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        
        // Get Managed Context Object with help of AppDelegate.
        let managedContext = appDelegate.managedObjectContext
        
        // Create Entity Description
        let entityDescription = NSEntityDescription.entity(forEntityName: "Locations", in: managedContext)
        
        // Configure Fetch Request
        fetchRequest.entity = entityDescription
        var loc = [LTLocation]()
        do {
            let result = try managedContext.fetch(fetchRequest) as?  [Locations]
            if (result!.count > 0) {
                for user in result! {
                    let l = LTLocation(lat: user.latitude, long: user.longitude, time: user.timstamp ?? Date(), isStop: user.isStart)
                    loc.append(l)
                }
                
            } else {
                // no locations
            }
            return loc
        } catch {
            let fetchError = error as NSError
            print("Error",fetchError)
        }
        
        return []
    }
}
