//
//  InventoryViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

class InventoryViewController: UIViewController {
    
    @IBOutlet weak var noItemsLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var startButton: UIButton!
    
    var inventoryBrain: InventoryBrain = InventoryBrain()
    var dateHelper: DateHelper!
    var documentManager: DocumentManager! = DocumentManager()
    
    var inventoryId: String?
    private var inventory: Inventory?
    private var scanningItem: Item?
    private var isScanning: Bool?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        dateHelper = DateHelper()
        
        applyStyles()
        fillStaticLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        fillPersistanceData()
        fetchInventory()
    }
    
    private func applyStyles() {
        tableView.separatorStyle = .none
        addRightBarButton()
    }
    
    private func fillStaticLabels() {
        navigationItem.title = NSLocalizedString(Constants.LocalizationKeys.kInventoryTitle, comment: "")
        startButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kStartInventory, comment: ""), for: .normal)
    }
    
    private func addRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    @objc func addTapped() {
        performSegue(withIdentifier: Constants.kShowAddItemSegue, sender: nil)
    }
    
    private func fillPersistanceData() {
        inventory = inventoryBrain.getLocalInventoryById(inventoryId)
        updateUI()
    }
    
    private func fetchInventory() {
        // Think about fetching data every time view will appears
    }
    
    private func updateUI() {
        if inventory?.items?.count != 0 {
            showItems(true)
            tableView.reloadData()
        } else {
            showItems(false)
        }
    }
    
    private func showItems(_ show: Bool) {
        tableView.isHidden = !show
        startButton.isHidden = !show
        noItemsLabel.isHidden = show
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            if segueId == Constants.kShowAddItemSegue {
                let controller = segue.destination as! ItemViewController
                controller.inventoryId = inventoryId
                //FIXME: Change to get last active inventory by date
                if let items = inventory?.items {
                    if items.count != 0 {
                        controller.inventoryItemByDateId = items.first!.id
                    }
                }
            } else if segueId == Constants.kShowScanningItemSegue {
                let controller = segue.destination as! ItemScanningViewController
                controller.delegate = self
                if let item = scanningItem {
                    controller.itemName = item.name
                    controller.beaconId = item.beaconId
                }
            }
        }
    }
    
    @IBAction func startScanningAction(_ sender: Any) {
        inventoryBrain.checkBluetoothConnection { (response) in
            if response == .bluetoothOn {
                self.isScanning = true
                self.startButton.isEnabled = false
                self.startButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kScanningInventory, comment: ""), for: .normal)
                ThemeManager.sharedInstance.addGradientWithAnimation(toView: self.startButton, withColors: [ThemeManager.sharedInstance.startAnimationGradientColor.cgColor, ThemeManager.sharedInstance.middleAnimationGradientColor.cgColor, ThemeManager.sharedInstance.endAnimationGradientColor.cgColor])
            } else if response == .bluetoothError {
                PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kBluetoothErrorTitle, comment: ""), withDescription: NSLocalizedString(Constants.LocalizationKeys.kBluetoothErrorDescription, comment: ""), withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kRetryButtonTitle, comment: ""), withCancelButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""), withPopupType: .error, withOkCompletion: {
                        NavigationManager.sharedInstance.showLoader {
                            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.kWaitAfterBluetoothRetry, execute: {
                                NavigationManager.sharedInstance.hideLoader {
                                    self.startScanningAction(sender)
                                }
                            })
                        }
                    }, withCancelCompletion:nil)
            }
        }
    }
    
    private func fillLabel(_ label: UILabel!, dependsOnItemStatus status: ItemStatus!) {
        label.isHidden = false
        switch status {
        case .success:
            label.backgroundColor = ThemeManager.sharedInstance.itemResultLabelSuccessColor
            label.text = NSLocalizedString(Constants.LocalizationKeys.kItemSuccess, comment: "")
        case .expired:
            label.backgroundColor = ThemeManager.sharedInstance.itemResultLabelExpiredColor
            label.text = NSLocalizedString(Constants.LocalizationKeys.kItemExpired, comment: "")
        case .nonExistent:
            label.backgroundColor = ThemeManager.sharedInstance.itemResultLabelMissingColor
            label.text = NSLocalizedString(Constants.LocalizationKeys.kItemNotExisted, comment: "")
        default:
            label.isHidden = true
            
        }
    }
    
    private func updateUIAfterFinishedInventory() {
        startButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kStartInventory, comment: ""), for: .normal)
        startButton.backgroundColor = ThemeManager.sharedInstance.inventoryOpenedColor
        ThemeManager.sharedInstance.removeGradientLayerWithAnimation(fromView: startButton)
    }
}

extension InventoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.35
    }
}

extension InventoryViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return inventory?.items?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        guard let date = inventory?.items?[section].date else {
            return "No items"
        }
        return dateHelper.getStringFromDate(date)
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        guard let countOfItems = inventory?.items?[section].items?.count else {
            return 0
        }
        
        let numberOfRows = countOfItems != 0 ? ((countOfItems - 1)/3) + 1 : 0
        
        return numberOfRows
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kItemsByDateCellHeaderIdentifier) as! ItemsByDateHeaderSectionTableViewCell
        
        guard let date = inventory?.items?[section].date else {
            cell.titleLabel.text = "No items"
            return cell
        }
        
        cell.titleLabel.text = dateHelper.getStringFromDate(date)
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kItemsByDateCellIdentifier, for: indexPath) as! ItemsByDateTableViewCell
        
        guard let items = inventory?.items?[indexPath.section].items else {
            return cell
        }
        
        let leftItem = items.indices.contains((indexPath.row) * 3) ? items[(indexPath.row) * 3] : nil
        let centerItem = items.indices.contains(((indexPath.row) * 3) + 1) ? items[((indexPath.row) * 3) + 1] : nil
        let rightItem = items.indices.contains(((indexPath.row) * 3) + 2) ? items[((indexPath.row) * 3) + 2] : nil
        
        if let leftItemValue = leftItem {
            cell.leftViewContainer.isHidden = false
            cell.leftInfoLabel.text = leftItemValue.name
            if let photoLocalPath = leftItemValue.photoLocalPath {
                cell.leftImageView.image = documentManager.getImageFromDocument(withName: photoLocalPath)
            }
            fillLabel(cell.leftResultLabel, dependsOnItemStatus: leftItemValue.status)
        }
        
        if let centerItemValue = centerItem {
            cell.centerViewContainer.isHidden = false
            cell.centerInfoLabel.text = centerItemValue.name
            if let photoLocalPath = centerItemValue.photoLocalPath {
                cell.centerImageView.image = documentManager.getImageFromDocument(withName: photoLocalPath)
            }
            fillLabel(cell.centerResultLabel, dependsOnItemStatus: centerItemValue.status)
        }
        
        if let rightItemValue = rightItem {
            cell.rightViewContainer.isHidden = false
            cell.rightInfoLabel.text = rightItemValue.name
            if let photoLocalPath = rightItemValue.photoLocalPath {
                cell.rightImageView.image = documentManager.getImageFromDocument(withName: photoLocalPath)
            }
            fillLabel(cell.rightResultLabel, dependsOnItemStatus: rightItemValue.status)
        }
        
        cell.selectionStyle = .none
        cell.delegate = self
        cell.indexPath = indexPath
        
        return cell
    }
}

extension InventoryViewController: ItemsByDateTableViewCellDelegate {
    func leftItemTouched(_ sender: ItemsByDateTableViewCell) {
        let indexPath: IndexPath! = sender.indexPath
        
        guard let items = inventory?.items?[indexPath.section].items else {
            return
        }
        let item = items.indices.contains((indexPath.row) * 3) ? items[(indexPath.row) * 3] : nil
        
        if let item = item {
            NSLog("Item: \(item.name!)")
            if let isScanning = isScanning {
                if isScanning {
                    scanningItem = item
                    performSegue(withIdentifier: Constants.kShowScanningItemSegue, sender: self)
                    return
                }
            }
            
            //If scanning is off, show edit item screen
        }
    }
    
    func centerItemTouched(_ sender: ItemsByDateTableViewCell) {
        let indexPath: IndexPath! = sender.indexPath
        
        guard let items = inventory?.items?[indexPath.section].items else {
            return
        }
        let item = items.indices.contains(((indexPath.row) * 3) + 1) ? items[((indexPath.row) * 3) + 1] : nil
        
        if let item = item {
            NSLog("Item: \(item.name!)")
            if let isScanning = isScanning {
                if isScanning {
                    scanningItem = item
                    performSegue(withIdentifier: Constants.kShowScanningItemSegue, sender: self)
                    return
                }
            }
            
            //If scanning is off, show edit item screen
        }
    }
    
    func rightItemTouched(_ sender: ItemsByDateTableViewCell) {
        let indexPath: IndexPath! = sender.indexPath
        
        guard let items = inventory?.items?[indexPath.section].items else {
            return
        }
        let item = items.indices.contains(((indexPath.row) * 3) + 2) ? items[((indexPath.row) * 3) + 2] : nil
        
        if let item = item {
            NSLog("Item: \(item.name!)")
            if let isScanning = isScanning {
                if isScanning {
                    scanningItem = item
                    performSegue(withIdentifier: Constants.kShowScanningItemSegue, sender: self)
                    return
                }
            }
            
            //If scanning is off, show edit item screen
        }
    }
}

extension InventoryViewController: ItemScanningViewControllerDelegate {
    func foundBeacon(withStatus status: ItemStatus) {
        print("\(status.rawValue)")
        inventoryBrain.updateItem(scanningItem, withStatus: status)
        
        if let realmItems = inventory?.items?.last?.items {
            let items = Array(realmItems)
            if let isInventoryFinished = inventoryBrain.checkIsInventoryFinished(items) {
                if isInventoryFinished {
                    updateUIAfterFinishedInventory()
                }
            }
        }
        tableView.reloadData()
    }
}
