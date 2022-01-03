//
//  ViewController.swift
//  AccidentHere
//
//  Created by 이소민 on 2021/11/23.
//
import UIKit
import CoreLocation
import CoreMotion
import AVFoundation

class ViewController: UIViewController, CLLocationManagerDelegate{
    
    var locationManager: CLLocationManager = CLLocationManager()
    var audioPlayer : AVAudioPlayer!
    let motion = CMMotionManager()
    var audioFile : URL!
    var baseline = 10.0  // 충돌 감지가 시작되는 최소 속도
    var collisionSensitivity = 8.0 // 충돌 감지의 민감도 (낮을수록 민감)
    
    @IBOutlet var speedLabel: UILabel!
    @IBOutlet var statusLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        statusLabel.textColor = UIColor.systemGray5
        audioFile = Bundle.main.url(forResource: "Blop Sound", withExtension: "mp3")
        
        initAccelerometer()
        initPlay()
        
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
                self.statusLabel.textColor = UIColor.white
                self.motion.startAccelerometerUpdates()
            } else {
                self.view.backgroundColor = UIColor(named: "backgroundColor")
                statusLabel.textColor = UIColor.systemGray5
                self.motion.stopAccelerometerUpdates()
            }
            
            speedLabel.text = (String(format: "%.0f", speed))
        } else {
            speedLabel.text = "0"
        }
    }
    
    func initAccelerometer(){
        if motion.isAccelerometerAvailable {
            motion.accelerometerUpdateInterval = 1.0 / 60.0
            
            let sensitivityValue = self.collisionSensitivity
            let timer = Timer(fire: Date(), interval: (1.0/60.0), repeats: true, block: { (timer) in
                if let data = self.motion.accelerometerData {
                    let val_x = data.acceleration.x
                    let val_y = data.acceleration.y
                    let val_z = data.acceleration.z
                    
                    if val_x > sensitivityValue || val_y > sensitivityValue || val_z > sensitivityValue{
                        print("충돌 감지")
                        print("X : \(val_x) Y : \(val_y) Z : \(val_z)")
                        self.audioPlayer.play()
                    }
                }
            })
            RunLoop.current.add(timer, forMode: RunLoop.Mode.default)
        }
    }
    
    func initPlay(){
        do{
            audioPlayer = try AVAudioPlayer(contentsOf: audioFile)
        } catch let error as NSError{
            print("Error Initial Play")
        }
        audioPlayer.prepareToPlay()
    }
}

