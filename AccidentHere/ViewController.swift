//
//  ViewController.swift
//  AccidentHere
//
//  Created by 이소민 on 2021/11/23.
//
import UIKit
import CoreLocation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    var locationManager: CLLocationManager = CLLocationManager()

    var baseline = 10.0

    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Ask for Authorisation from the User.
        self.locationManager.requestAlwaysAuthorization()

        // For use in foreground
        self.locationManager.requestWhenInUseAuthorization()

        if CLLocationManager.locationServicesEnabled() {
            locationManager.delegate = self
            // 10미터 이내 정확도
            //locationManager.desiredAccuracy = kCLLocationAccuracyNearestTenMeters
            locationManager.desiredAccuracy = kCLLocationAccuracyBest
            locationManager.startUpdatingLocation()
        }
    }
    
    func locationManager(_ manager: CLLocationManager, didUpdateLocations locations: [CLLocation]) {
        let location = locations.last
        if (location!.horizontalAccuracy > 0) {
            updateLocationInfo(latitude: location!.coordinate.latitude, longitude: location!.coordinate.longitude, speed: location!.speed)
        }
    }

    func updateLocationInfo(latitude: CLLocationDegrees, longitude: CLLocationDegrees, speed: CLLocationSpeed) {
        let speed = (speed * 3.6)
        
        // Checking if speed is less than zero
        if (speed > 0) {
            if (speed > baseline) {
                self.view.backgroundColor = UIColor.red
            } else {
                self.view.backgroundColor = UIColor(named: "backgroundColor")
            }
            
            speedLabel.text = (String(format: "%.0f", speed))
        } else {
            speedLabel.text = "0"
        }
    }
}

