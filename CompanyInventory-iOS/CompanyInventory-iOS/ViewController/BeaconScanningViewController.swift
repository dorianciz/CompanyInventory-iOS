//
//  BeaconScanningViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/18/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit
import Lottie
import AVFoundation
import CoreLocation

protocol BeaconScanningViewControllerDelegate: class {
    func foundBeacon(withId id: String)
}

class BeaconScanningViewController: UIViewController {

    private var scanningAnimationView: LOTAnimationView?
    private var successAnimationView: LOTAnimationView?
    private var avPlayer: AVAudioPlayer?
    private var beaconManager: ESTBeaconManager!
    private var regionToScan: CLBeaconRegion!
    weak var delegate: BeaconScanningViewControllerDelegate?
    
    @IBOutlet weak var scanningLabel: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        configureAvPlayer()
        styleAnimationViews()
        beaconManager = ESTBeaconManager()
        regionToScan = asBeaconRegion()
        beaconManager.delegate = self
        beaconManager.requestWhenInUseAuthorization()
        // Do any additional setup after loading the view.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beaconManager.startRangingBeacons(in: regionToScan)
    }
    
    private func configureAvPlayer() {
        guard let file = Bundle.main.path(forResource: Constants.kSuccessScanAudio, ofType: Constants.kAudioExtension) else {
            return
        }
        do {
            avPlayer = try AVAudioPlayer(contentsOf: URL(fileURLWithPath: file))
        } catch let error as Error {
            print(error)
        }
    }

    private func styleAnimationViews() {
        successAnimationView = LOTAnimationView(name: Constants.kSuccessScanningAnimation)
        if let successView = successAnimationView {
            successView.frame = CGRect(x: Constants.kAnimationViewX, y: Constants.kAnimationViewY, width: Constants.kAnimationViewWidth, height: Constants.kAnimationViewHeight)
            successView.center = view.center;
            successView.contentMode = .scaleAspectFill;
            successView.loopAnimation = false;
            successView.isHidden = true
            view.addSubview(successView)
        }
        
        scanningAnimationView = LOTAnimationView(name: Constants.kScanningBeaconAnimation)
        if let scanningView = scanningAnimationView {
            scanningView.frame = CGRect(x: Constants.kAnimationViewX, y: Constants.kAnimationViewY, width: Constants.kAnimationViewWidth, height: Constants.kAnimationViewHeight)
            scanningView.center = view.center;
            scanningView.contentMode = .scaleAspectFill;
            scanningView.loopAnimation = true;
            view.addSubview(scanningView)
            scanningView.play()
        }
        
        view.bringSubview(toFront: scanningLabel)
        
        //Testing
//        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
//            self.finishScanningSuccessfully()
//        }
        
    }
    
    private func finishScanningSuccessfully() {
        guard let scanningView = scanningAnimationView, let successView = successAnimationView else {
            return
        }
        
        scanningView.isHidden = true
        scanningLabel.isHidden = true
        successView.isHidden = false
        scanningView.pause()
        if let player = self.avPlayer {
            player.prepareToPlay()
            player.play()
            AudioServicesPlayAlertSound(SystemSoundID(kSystemSoundID_Vibrate))
        }
        successView.play { (isFinished) in
            if isFinished {
                self.dismiss(animated: true, completion: nil)
            }
        }
        
    }
    
    private func asBeaconRegion() -> CLBeaconRegion {
        return CLBeaconRegion(proximityUUID: UUID(uuidString: Constants.kBeaconId)!,
                              identifier: "Monitored region")
    }

    @IBAction func cancelAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
}

extension BeaconScanningViewController: ESTBeaconManagerDelegate {

    func beaconManager(_ manager: Any, didRangeBeacons beacons: [CLBeacon], in region: CLBeaconRegion) {
        for beacon in beacons {
            let minor = beacon.minor
            print("\(minor)")
        }
        finishScanningSuccessfully()
        //FIXME: Mocking beacon data
        let randomId = arc4random()
        delegate?.foundBeacon(withId: "\(randomId)")
        dismiss(animated: true, completion: nil)
    }
    
}
