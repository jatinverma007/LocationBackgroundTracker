//
//  LTLocation.swift
//  LocationTracker
//
//  Created by jatin verma on 29/04/21.
//

import Foundation

class LTLocation {
    var latitude:Double!
    var longitude:Double!
    var timeStamp:Date!
    var isStop: Bool!
    
    init(lat:Double, long: Double, time:Date, isStop: Bool) {
        self.latitude = lat
        self.longitude = long
        self.timeStamp = time
        self.isStop = isStop
    }
}
