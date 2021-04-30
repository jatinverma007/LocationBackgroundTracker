//
//  Locations+CoreDataProperties.swift
//  LocationTracker
//
//  Created by jatin verma on 30/04/21.
//
//

import Foundation
import CoreData


extension Locations {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Locations> {
        return NSFetchRequest<Locations>(entityName: "Locations")
    }

    @NSManaged public var latitude: Double
    @NSManaged public var longitude: Double
    @NSManaged public var timstamp: Date?
    @NSManaged public var isStart: Bool

}

extension Locations : Identifiable {

}
