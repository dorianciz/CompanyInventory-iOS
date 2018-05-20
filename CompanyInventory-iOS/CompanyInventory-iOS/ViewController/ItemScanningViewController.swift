//
//  ItemScanningViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/19/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit
import Lottie
import AVFoundation

protocol ItemScanningViewControllerDelegate: class {
    func foundBeacon(withStatus status: ItemStatus)
}

class ItemScanningViewController: UIViewController {
    
    var itemName: String?
    var beaconId: String?
    
    private var scanningAnimationView: LOTAnimationView?
    private var successAnimationView: LOTAnimationView?
    private var avPlayer: AVAudioPlayer?
    var beaconScanner: BeaconScanner?
    weak var delegate: ItemScanningViewControllerDelegate?
    
    
    @IBOutlet weak var scanningLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var expiredButton: UIButton!
    @IBOutlet weak var notExistButton: UIButton!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beaconScanner = MonitoringBeaconScanner(forBeaconId: beaconId)
        beaconScanner?.delegate = self
        fillStaticLabels()
        styleAnimationViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        titleLabel.text = itemName
        beaconScanner?.startRanging()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        beaconScanner?.stopRanging()
    }
    
    private func fillStaticLabels() {
        scanningLabel.text = NSLocalizedString(Constants.LocalizationKeys.kGeneralScanning, comment: "")
        expiredButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kScanningItemExpired, comment: ""), for: .normal)
            notExistButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kScanningItemMissing, comment: ""), for: .normal)
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
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func notExistentAction(_ sender: Any) {
        delegate?.foundBeacon(withStatus: .nonExistent)
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func expandedAction(_ sender: Any) {
        delegate?.foundBeacon(withStatus: .expended)
        dismiss(animated: true, completion: nil)
    }
    
}

extension ItemScanningViewController: BeaconScannerDelegate {
    func foundBeacon(withId id: String) {
        print("Scanned beacon ID: \(id)")
        finishScanningSuccessfully()
        delegate?.foundBeacon(withStatus: .success)
        dismiss(animated: true, completion: nil)
    }
}
