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
    func pauseScanning()
    func finishInventory()
}

class ItemScanningViewController: UIViewController {
    
    private var scanningAnimationView: LOTAnimationView?
    private var successAnimationView: LOTAnimationView?
    private var avPlayer: AVAudioPlayer?
    
    var beaconScanner: BeaconScanner?
    var documentManager: DocumentManager?
    var itemBrain = ItemBrain()
    
    weak var delegate: ItemScanningViewControllerDelegate?
    
    var itemsToScan: [Item]?
    private var foundBeaconId: String?
    
    @IBOutlet weak var scanningLabel: UILabel!
    @IBOutlet weak var finishScanningButton: UIButton!
    @IBOutlet weak var resultContainerView: UIView!
    @IBOutlet weak var itemImage: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var addItemButton: UIButton!
    @IBOutlet weak var cancelItemButton: UIButton!
    @IBOutlet weak var resultContainerViewTopConstraint: NSLayoutConstraint!
    @IBOutlet weak var resultContainerViewTrailingConstraint: NSLayoutConstraint!
    @IBOutlet weak var resultContainerViewLeadingConstraint: NSLayoutConstraint!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        beaconScanner = MonitoringBeaconScanner(withBeaconsIdsToScan: allBeaconsIds())
        beaconScanner?.delegate = self
        documentManager = DocumentManager()
        applyStyles()
        fillStaticLabels()
        styleAnimationViews()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        beaconScanner?.startRanging()
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        beaconScanner?.stopRanging()
    }
    
    private func allBeaconsIds() -> [String] {
        var ids = [String]()
        itemsToScan?.forEach({ (item) in
            if let id = item.beaconId {
                ids.append(id)
            }
        })
        return ids
    }
    
    private func applyStyles() {
        finishScanningButton.backgroundColor = ThemeManager.sharedInstance.finishScanningButtonColor
        ThemeManager.sharedInstance.styleDefaultButton(button: addItemButton)
        ThemeManager.sharedInstance.styleClearButton(button: cancelItemButton)
        resultContainerView.layer.cornerRadius = ThemeManager.sharedInstance.buttonDefaultCornerRadius
        resultContainerView.backgroundColor = ThemeManager.sharedInstance.itemResultColor
        resultContainerViewTopConstraint.constant = ThemeManager.sharedInstance.itemResultHiddenTopConstraintValue
    }
    
    private func fillStaticLabels() {
        scanningLabel.text = NSLocalizedString(Constants.LocalizationKeys.kGeneralScanning, comment: "")
        finishScanningButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kScanningItemFinished, comment: ""), for: .normal)
        addItemButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kInventoryAddButton, comment: ""), for: .normal)
        cancelItemButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""), for: .normal)
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
    
    private func showResultView(_ show: Bool?) {
        view.bringSubview(toFront: resultContainerView)
        guard let shouldShowResultView = show else {
            return
        }
        
        AnimationChainingFactory.sharedInstance.animation(withDuration: shouldShowResultView ? 1 : 0.3, withDelay: 0, withAnimations: {
            if shouldShowResultView {
                self.resultContainerViewTopConstraint.constant = ThemeManager.sharedInstance.itemResultShownTopConstraintValue
            } else {
                self.resultContainerViewLeadingConstraint.constant = ThemeManager.sharedInstance.itemResultHiddenLeadingConstraint
                self.resultContainerViewTrailingConstraint.constant = ThemeManager.sharedInstance.itemResultHiddenTrailingConstraint
            }
            self.view.layoutIfNeeded()
        }, withCompletion: {
            if !shouldShowResultView {
                self.resultContainerViewTopConstraint.constant = ThemeManager.sharedInstance.itemResultHiddenTopConstraintValue
                self.resultContainerViewLeadingConstraint.constant = ThemeManager.sharedInstance.itemResultShownLeadingConstraint
                self.resultContainerViewTrailingConstraint.constant = ThemeManager.sharedInstance.itemResultShownTrailingConstraint
                self.view.layoutIfNeeded()
            }
        }, withOptions: .curveLinear ).run()
    }
    
    private func updateUIIfBeaconIsFound(forBeaconId id: String) {
        if let item = itemBrain.getItem(byBeaconId: id) {
            titleLabel.text = item.name
            itemImage.image = documentManager?.getImageFromDocument(withName: item.photoLocalPath)
        }
        showResultView(true)
    }
    
    private func finishInventory() {
        itemsToScan?.forEach({ (item) in
            if item.status != .success {
                itemBrain.updateItem(item, withStatus: .nonExistent)
            }
        })
        self.delegate?.finishInventory()
        self.dismiss(animated: true, completion: nil)
    }
    
    @IBAction func cancelButtonAction(_ sender: Any) {
        delegate?.pauseScanning()
        dismiss(animated: true, completion: nil)
    }
    
    @IBAction func finishInventoryAction(_ sender: Any) {
        if let isFinished = itemBrain.isInventoryFinished(itemsToScan), !isFinished {
            PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kFinishInventoryTitle, comment: ""), withDescription: NSLocalizedString(Constants.LocalizationKeys.kFinishInventoryDescription, comment: ""), withPopupType: .success, withOkCompletion: {
                self.finishInventory()
            }, withCancelCompletion: nil)
        } else {
            finishInventory()
        }
    }
    
    @IBAction func addItemAction(_ sender: Any) {
        if let beaconId = foundBeaconId, let index = (beaconScanner as? MonitoringBeaconScanner)?.beaconsIdsToScan?.index(of: beaconId) {
            (beaconScanner as? MonitoringBeaconScanner)?.beaconsIdsToScan?.remove(at: index)
        }
    
        let scannedItem = itemsToScan?.filter({$0.beaconId == foundBeaconId}).first
        itemBrain.updateItem(scannedItem, withStatus: .success)
        showResultView(false)
        
        if let isFinished = itemBrain.isInventoryFinished(itemsToScan), isFinished {
            self.delegate?.finishInventory()
            dismiss(animated: true, completion: nil)
            return
        }
        
        beaconScanner?.startRanging()
    }
    
    @IBAction func cancelItemAction(_ sender: Any) {
        showResultView(false)
        beaconScanner?.startRanging()
    }
}

extension ItemScanningViewController: BeaconScannerDelegate {
    func foundBeacon(withId id: String) {
        print("Scanned beacon ID: \(id)")
        foundBeaconId = id
        updateUIIfBeaconIsFound(forBeaconId: id)
        beaconScanner?.stopRanging()
    }
}
