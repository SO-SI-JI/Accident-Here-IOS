//
//  ViewController.swift
//  AccidentHere
//
//  Created by 이소민 on 2021/11/23.
//

import CoreLocation
import UIKit

class ViewController: UIViewController {

    @IBOutlet var xTxt: UILabel!
    @IBOutlet var yTxt: UILabel!
    @IBOutlet var zTxt: UILabel!
    
    var locationManager = CLLocationManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        locationManager.requestWhenInUseAuthorization()
        var currentLoc: CLLocation!
        if(CLLocationManager.authorizationStatus() == .authorizedWhenInUse ||
        CLLocationManager.authorizationStatus() == .authorizedAlways) {
           currentLoc = locationManager.location
            
            let lat: String = String(format: "%f", currentLoc.coordinate.latitude)
            let lon: String = String(format: "%f", currentLoc.coordinate.longitude)
            xTxt.text = lat
            yTxt.text = lon
        }
    }

    @IBAction func checkBtn(_ sender: UIButton) {
        
    }
    
}

