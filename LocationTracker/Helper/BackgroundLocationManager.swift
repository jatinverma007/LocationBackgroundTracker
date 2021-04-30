//
//  BackgroundLocationManager.swift
//  LocationTracker
//
//  Created by jatin verma on 30/04/21.
//

import Foundation
import CoreLocation
import UIKit

class BackgroundLocationManager :NSObject, CLLocationManagerDelegate {

    static let instance = BackgroundLocationManager()
    static let BACKGROUND_TIMER = 30.0 // restart location manager every 30 seconds

    let locationManager = CLLocationManager()
    var timer:Timer?
    var currentBgTaskId : UIBackgroundTaskIdentifier?
    var lastLocationDate : NSDate = NSDate()

    override init() {
        super.init()
        locationManager.delegate = self
        locationManager.desiredAccuracy = kCLLocationAccuracyBest
        locationManager.activityType = .other
        locationManager.distanceFilter = kCLDistanceFilterNone
        locationManager.allowsBackgroundLocationUpdates = true
        locationManager.showsBackgroundLocationIndicator = true

        NotificationCenter.default.addObserver(self, selector: #selector(self.applicationEnterBackground), name: UIApplication.didEnterBackgroundNotification, object: nil)
    }


    @objc func applicationEnterBackground(){
        if HomeViewController.currentStatus {
            start()
        }
    }

    func start(){
        locationManager.startUpdatingLocation()
    }
    
    func stop() {
        locationManager.stopUpdatingLocation()
        timer?.invalidate()
        timer = nil
    }
    
    @objc func restart (){
        timer?.invalidate()
        timer = nil
        start()
    }

    private func locationManager(manager: CLLocationManager, didChangeAuthorizationStatus status: CLAuthorizationStatus) {
        switch status {
        case CLAuthorizationStatus.restricted: break
            //log("Restricted Access to location")
        case CLAuthorizationStatus.denied: break
            //log("User denied access to location")
        case CLAuthorizationStatus.notDetermined: break
            //log("Status not determined")
        default:
            //log("startUpdatintLocation")
            locationManager.startUpdatingLocation()

        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if(timer==nil){
            guard let location = locations.last else {return}
            print(location.coordinate.latitude)
            print(location.coordinate.longitude)
            beginNewBackgroundTask()
            locationManager.stopUpdatingLocation()
            let now = Date()
            CoreDataFunctions.insertLocation(lat: location.coordinate.latitude, long: location.coordinate.longitude, time: now, isStart: true)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didFailWithError error: Error) {
        beginNewBackgroundTask()
        locationManager.stopUpdatingLocation()

    }


    func beginNewBackgroundTask(){
        var previousTaskId = currentBgTaskId;
        currentBgTaskId = UIApplication.shared.beginBackgroundTask(expirationHandler: {
        })
        if let taskId = previousTaskId{
            UIApplication.shared.endBackgroundTask(taskId)
            previousTaskId = UIBackgroundTaskIdentifier.invalid
        }

        timer = Timer.scheduledTimer(timeInterval: BackgroundLocationManager.BACKGROUND_TIMER, target: self, selector: #selector(self.restart),userInfo: nil, repeats: false)
    }
}
