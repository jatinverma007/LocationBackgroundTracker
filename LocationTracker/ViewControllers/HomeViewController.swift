//
//  HomeViewController.swift
//  LocationTracker
//
//  Created by jatin verma on 30/04/21.
//

import UIKit
import CoreLocation
import MapKit


class HomeViewController: UIViewController, CLLocationManagerDelegate {
    
    @IBOutlet weak var logButton: UIButton!
    @IBOutlet weak var trackingButton: UIButton!
    @IBOutlet weak var mapView: MKMapView!
    
    private let locationManager = CLLocationManager()
    
    static var currentStatus = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupView()
        checkForLocationService()
    }
    
    
    func checkForLocationService() {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined, .restricted, .denied:
                trackingButton.setTitle("Start Tracking", for: .normal)
            case .authorizedAlways, .authorizedWhenInUse:
                if HomeViewController.currentStatus {
                    BackgroundLocationManager.instance.start()
                    trackingButton.setTitle("Stop Tracking", for: .normal)
                }
                else {
                    BackgroundLocationManager.instance.stop()
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.requestAlwaysAuthorization()
                    locationManager.startUpdatingLocation()
                    mapView.showsUserLocation = true
                    trackingButton.setTitle("Start Tracking", for: .normal)
                }
            @unknown default:
                break
            }
        } else {
            trackingButton.setTitle("Start Tracking", for: .normal)
        }
    }
    func setupView() {
        logButton.layer.cornerRadius = 4
        trackingButton.layer.cornerRadius = 4
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        navigationController?.setNavigationBarHidden(true, animated: false)
    }
    
    @IBAction func logButtonTapped(_ sender: UIButton) {
        let vc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "start_view_controller") as! StartViewController
        self.navigationController?.pushViewController(vc, animated: true)
    }
    @IBAction func trackButtonTapped(_ sender: UIButton) {
        if CLLocationManager.locationServicesEnabled() {
            switch locationManager.authorizationStatus {
            case .notDetermined:
                locationManager.delegate = self
                locationManager.desiredAccuracy = kCLLocationAccuracyBest
                locationManager.activityType = .other
                locationManager.distanceFilter = kCLDistanceFilterNone
                locationManager.allowsBackgroundLocationUpdates = true
                locationManager.showsBackgroundLocationIndicator = true
                locationManager.requestAlwaysAuthorization()
                locationManager.startUpdatingLocation()
                mapView.showsUserLocation = true
                trackingButton.setTitle("Stop Tracking", for: .normal)
                break
            case .restricted, .denied:
                let alert = UIAlertController(title: "Allow Location Access", message: "LocationTracker needs access to your location. Turn on Location Services in your device settings.", preferredStyle: UIAlertController.Style.alert)
                alert.addAction(UIAlertAction(title: "Settings", style: UIAlertAction.Style.default, handler: { action in
                    guard let settingsUrl = URL(string: UIApplication.openSettingsURLString) else {
                        return
                    }
                    if UIApplication.shared.canOpenURL(settingsUrl) {
                        UIApplication.shared.open(settingsUrl, completionHandler: { (success) in
                            print("Settings opened: \(success)")
                        })
                    }
                }))
                alert.addAction(UIAlertAction(title: "Ok", style: UIAlertAction.Style.default, handler: nil))
                self.present(alert, animated: true, completion: nil)
            case .authorizedAlways, .authorizedWhenInUse:
                if HomeViewController.currentStatus {
                    BackgroundLocationManager.instance.stop()
                    trackingButton.setTitle("Start Tracking", for: .normal)
                    HomeViewController.currentStatus = false
                }
                else {
                    BackgroundLocationManager.instance.start()
                    locationManager.delegate = self
                    locationManager.desiredAccuracy = kCLLocationAccuracyBest
                    locationManager.requestAlwaysAuthorization()
                    locationManager.startUpdatingLocation()
                    mapView.showsUserLocation = true
                    trackingButton.setTitle("Stop Tracking", for: .normal)
                    HomeViewController.currentStatus = true
                }
            @unknown default:
                break
            }
        } else {
            trackingButton.setTitle("Start Tracking", for: .normal)
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        if let location = locations.last{
            let center = CLLocationCoordinate2D(latitude: location.coordinate.latitude, longitude: location.coordinate.longitude)
            let span = MKCoordinateSpan(latitudeDelta: 0.03, longitudeDelta: 0.03)
            let region = MKCoordinateRegion(center: center, span: span)
            self.mapView.setRegion(region, animated: true)
            self.locationManager.stopUpdatingLocation()
        }
    }
    
}

