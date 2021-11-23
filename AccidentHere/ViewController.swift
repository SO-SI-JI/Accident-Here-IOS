//
//  ViewController.swift
//  AccidentHere
//
//  Created by 이소민 on 2021/11/23.
//

import UIKit
import CoreMotion
import simd

class ViewController: UIViewController {

    @IBOutlet var xTxt: UILabel!
    @IBOutlet var yTxt: UILabel!
    @IBOutlet var zTxt: UILabel!
    
    var motionManager: CMMotionManager?

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }
    
    func startUpdates() {
        guard let motionManager = motionManager, motionManager.isGyroAvailable else { return }
        
        
        motionManager.gyroUpdateInterval = TimeInterval(1)
        motionManager.showsDeviceMovementDisplay = true
        
        motionManager.startGyroUpdates(to: .main) { gyroData, error in
            guard let gyroData = gyroData else { return }
            
            self.xTxt.text = String(gyroData.rotationRate.x)
            self.yTxt.text = String(gyroData.rotationRate.y)
            self.zTxt.text = String(gyroData.rotationRate.z)
            
        }
    }

    @IBAction func checkBtn(_ sender: UIButton) {
        startUpdates()
    }
    
}

