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
    var itemBrain: ItemBrain = ItemBrain()
    var dateHelper: DateHelper!
    
    var inventoryId: String?
    private var inventory: Inventory?
    private var scanningItem: Item?
    private var isScanning: Bool?
    private var imagesOfItems: [String:UIImage]?
    private var selectedItem: Item?
    private var isDeleteMode = false
    
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
        startButton.layoutIfNeeded()
        fillPersistanceData()
    }
    
    private func applyStyles() {
        tableView.separatorStyle = .none
        startButton.titleLabel?.textAlignment = .center
    }
    
    private func fillStaticLabels() {
        navigationItem.title = NSLocalizedString(Constants.LocalizationKeys.kInventoryTitle, comment: "")
        startButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kStartInventory, comment: ""), for: .normal)
    }
    
    private func addRightBarButton() {
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }
    
    private func cleanRightBarButton() {
        navigationItem.rightBarButtonItem = nil
    }
    
    @objc func addTapped() {
        performSegue(withIdentifier: Constants.kShowAddItemSegue, sender: nil)
    }
    
    private func fillPersistanceData() {
        inventory = inventoryBrain.getLocalInventoryById(inventoryId)
        imagesOfItems = inventoryBrain.getImagesForInventory(inventory)
        updateUI()
    }
    
    private func updateUI() {
        //Adding add button if inventory is opened
        if let status = inventory?.status {
            ThemeManager.sharedInstance.removeGradientLayerWithAnimation(fromView: self.startButton)
            switch status {
            case .open:
                startButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kStartInventory, comment: ""), for: .normal)
                addRightBarButton()
            case .inProgress:
                startButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kScanningInventory, comment: ""), for: .normal)
                ThemeManager.sharedInstance.addGradientWithAnimation(toView: self.startButton,
                                                                     withColors: [ThemeManager.sharedInstance.startAnimationGradientColor.cgColor, ThemeManager.sharedInstance.middleAnimationGradientColor.cgColor, ThemeManager.sharedInstance.endAnimationGradientColor.cgColor])
                cleanRightBarButton()
            case .closed:
                startButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kCreateNewInventoryButtonTitle, comment: ""), for: .normal)
                cleanRightBarButton()
            default:
                cleanRightBarButton()
            }
        } else {
            cleanRightBarButton()
        }
        
        //If there is no items in inventory, show "No items" screen, else show items and scroll to last items
        if let count = inventory?.items?.count {
            if count != 0 {
                showItems(true)
                tableView.reloadData()
                DispatchQueue.main.asyncAfter(deadline: .now() + Constants.kWaitBeforeTableViewScrollToBottom) {
                    let indexPath = IndexPath(row: 0, section: count - 1)
                    self.tableView.scrollToRow(at: indexPath, at: .bottom, animated: true)
                }
            } else {
                showItems(false)
            }
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
                if let items = inventory?.items {
                    if items.count != 0 {
                        controller.inventoryItemByDateId = items.last!.id
                    }
                }
            } else if segueId == Constants.kShowScanningItemSegue {
                let controller = segue.destination as! ItemScanningViewController
                controller.delegate = self
                if let items = inventory?.items?.last?.items {
                    controller.itemsToScan = Array(items)
                }
            } else if segueId == Constants.kShowItemDetailsSegue {
                let controller = segue.destination as! ItemDetailsViewController
                controller.item = selectedItem
            }
        }
    }
    
    @IBAction func startScanningAction(_ sender: Any) {
        if isDeleteMode {
            AnimationChainingFactory.sharedInstance.animation(withDuration: 0.2, withDelay: 0, withAnimations: {
                self.startButton.titleLabel?.text = NSLocalizedString(Constants.LocalizationKeys.kStartInventory, comment: "")
                self.startButton.backgroundColor = ThemeManager.sharedInstance.inventoryOpenedColor
            }, withCompletion: {
                
                //Disable wiggle animation by setting isDeleteMode to false.
                //Table will reload all cells and delete wiggle animation from each cell
                self.isDeleteMode = false
                self.tableView.reloadData()
                
            }, withOptions: UIViewAnimationOptions(rawValue: 0)).run()
            return
        }
        
        inventoryBrain.checkBluetoothConnection { (response) in
            
            if response == .bluetoothOn {
                
                // Bluetooth is on, phone is ready for scanning beacons
                
                if let inventory = self.inventory {
                    
                    if inventory.status == .inProgress {
                        self.performSegue(withIdentifier: Constants.kShowScanningItemSegue, sender: self)
                        return
                    }
                    
                    if inventory.status == .open {
                        self.inventoryBrain.updateInventoryStatus(inventory, .inProgress, { (response) in
                            if response == .success {
                                self.updateUI()
                                self.performSegue(withIdentifier: Constants.kShowScanningItemSegue, sender: self)
                                return
                            }
                            NavigationManager.sharedInstance.hideLoader {
                                PopupManager.sharedInstance.showGeneralError()
                            }
                        })
                        return
                    }
                    
                    if inventory.status == .closed {
                        NavigationManager.sharedInstance.showLoader {
                            self.inventoryBrain.updateInventoryStatus(inventory, .open, { (response) in
                                if response == .success {
                                    if let items = self.inventory?.items?.last?.items {
                                        if let isFinishedLastInventoryByDate = self.inventoryBrain.checkIsInventoryFinished(Array(items)) {
                                            if isFinishedLastInventoryByDate {
                                                self.inventoryBrain.addNewInventoryByDate(toInventory: self.inventory, { (inventory, response) in
                                                    if response == .success {
                                                        self.inventory = inventory
                                                    }
                                                })
                                            }
                                        }
                                    }
                                    
                                    self.isScanning = true
                                    
                                    NavigationManager.sharedInstance.hideLoader {
                                        self.updateUI()
                                    }
                                    return
                                }
                                NavigationManager.sharedInstance.hideLoader {
                                    PopupManager.sharedInstance.showGeneralError()
                                }
                            })
                        }
                        return
                    }
                    
                }
                
            } else if response == .bluetoothError {
                
                //Show bluetooth error popup
                
                PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kBluetoothErrorTitle, comment: ""),
                                                      withDescription: NSLocalizedString(Constants.LocalizationKeys.kBluetoothErrorDescription, comment: ""),
                                                      withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kRetryButtonTitle, comment: ""),
                                                      withCancelButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""),
                                                      withPopupType: .error,
                                                      withOkCompletion: {
                                                        NavigationManager.sharedInstance.showLoader {
                                                            DispatchQueue.main.asyncAfter(deadline: .now() + Constants.kWaitAfterBluetoothRetry, execute: {
                                                                NavigationManager.sharedInstance.hideLoader {
                                                                    self.startScanningAction(sender)
                                                                }
                                                            })
                                                        }
                                                      },
                                                      withCancelCompletion:nil)
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
        startButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kCreateNewInventoryButtonTitle, comment: ""), for: .normal)
        startButton.backgroundColor = ThemeManager.sharedInstance.inventoryOpenedColor
        startButton.isEnabled = true
        ThemeManager.sharedInstance.removeGradientLayerWithAnimation(fromView: startButton)
        updateUI()
    }
}

extension InventoryViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return UIScreen.main.bounds.height * 0.33
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
        
        guard let date = inventory?.items?[section].date, let items = inventory?.items?[section].items else {
            cell.titleLabel.text = "No items"
            return cell
        }
        
        cell.titleLabel.text = dateHelper.getStringFromDate(date)
        
        if let isFinished = inventoryBrain.checkIsInventoryFinished(Array(items)) {
            if isFinished {
                cell.titleLabel.text = "\(cell.titleLabel.text!) - \(NSLocalizedString(Constants.LocalizationKeys.kInventoryByDateFinished, comment: ""))"
            }
        }

        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 65
    }
    
    func tableView(_ tableView: UITableView, viewForFooterInSection section: Int) -> UIView? {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kItemsByDateCellFooterIdentifier) as! ItemsByDateFooterTableViewCell

        guard let items = inventory?.items?[section].items else {
            return nil
        }

        if let isFinished = inventoryBrain.checkIsInventoryFinished(Array(items)) {
            if isFinished {
                cell.delegate = self
                cell.reportButton.setTitle(NSLocalizedString(Constants.LocalizationKeys.kReportTitle, comment: ""), for: .normal)
                return cell
            }
        }

        return nil
    }

    func tableView(_ tableView: UITableView, heightForFooterInSection section: Int) -> CGFloat {
        return 46
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kItemsByDateCellIdentifier, for: indexPath) as! ItemsByDateTableViewCell
        
        guard let items = inventory?.items?[indexPath.section].items else {
            return cell
        }
        
        let leftItem = items.indices.contains((indexPath.row) * 3) ? items[(indexPath.row) * 3] : nil
        let centerItem = items.indices.contains(((indexPath.row) * 3) + 1) ? items[((indexPath.row) * 3) + 1] : nil
        let rightItem = items.indices.contains(((indexPath.row) * 3) + 2) ? items[((indexPath.row) * 3) + 2] : nil
        
        var isAbleToDelete = false
        
        if let leftItemValue = leftItem {
            cell.leftViewContainer.isHidden = false
            cell.leftInfoLabel.text = leftItemValue.name
            if let photoLocalPath = leftItemValue.photoLocalPath {
                cell.leftImageView.image = imagesOfItems?[photoLocalPath]
            }
            fillLabel(cell.leftResultLabel, dependsOnItemStatus: leftItemValue.status)
            isAbleToDelete = leftItemValue.status == .none
        } else {
            cell.leftViewContainer.isHidden = true
        }
        
        if let centerItemValue = centerItem {
            cell.centerViewContainer.isHidden = false
            cell.centerInfoLabel.text = centerItemValue.name
            if let photoLocalPath = centerItemValue.photoLocalPath {
                cell.centerImageView.image = imagesOfItems?[photoLocalPath]
            }
            fillLabel(cell.centerResultLabel, dependsOnItemStatus: centerItemValue.status)
            isAbleToDelete = centerItemValue.status == .none
        } else {
            cell.centerViewContainer.isHidden = true
        }
        
        if let rightItemValue = rightItem {
            cell.rightViewContainer.isHidden = false
            cell.rightInfoLabel.text = rightItemValue.name
            if let photoLocalPath = rightItemValue.photoLocalPath {
                cell.rightImageView.image = imagesOfItems?[photoLocalPath]
            }
            fillLabel(cell.rightResultLabel, dependsOnItemStatus: rightItemValue.status)
            isAbleToDelete = rightItemValue.status == .none
        } else {
            cell.rightViewContainer.isHidden = true
        }
        
        cell.selectionStyle = .none
        cell.delegate = self
        cell.indexPath = indexPath
        
        //Wiggle cell if delete mode is on
        if let inventoryStatus = inventory?.status {
            wiggleCell(cell, isDeleteMode && isAbleToDelete && inventoryStatus == .open, (indexPath.row % 2 == 0))
        }
        
        return cell
    }
}

extension InventoryViewController: ItemsByDateTableViewCellDelegate {
    func itemTouched(_ position: ItemPosition!, _ indexPath: IndexPath!) {
        guard let item = inventoryBrain.getItem(fromInventory: inventory, forIndexPath: indexPath, andPosition: position) else {
            return
        }

        selectedItem = item
        performSegue(withIdentifier: Constants.kShowItemDetailsSegue, sender: nil)
    }
    
    func itemLongPressed(_ position: ItemPosition!, _ indexPath: IndexPath!) {
        // User is able to delete item only if the status is open
        if let inventoryStatus = inventory?.status, inventoryStatus != .open {
                return
        }
        
        guard let item = inventoryBrain.getItem(fromInventory: inventory, forIndexPath: indexPath, andPosition: position), item.status == .none else {
            return
        }

        isDeleteMode = true
        AnimationChainingFactory.sharedInstance.animation(withDuration: 0.2, withDelay: 0, withAnimations: {
            self.startButton.titleLabel?.text = NSLocalizedString(Constants.LocalizationKeys.kDeleteItemButtonTitle, comment: "")
            self.startButton.backgroundColor = ThemeManager.sharedInstance.errorColor
        }, withCompletion: {
        }, withOptions: UIViewAnimationOptions(rawValue: 0)).run()
        tableView.reloadData()
    }
    
    func deleteButtonTouched(_ position: ItemPosition!, _ indexPath: IndexPath!) {
        guard let item = inventoryBrain.getItem(fromInventory: inventory, forIndexPath: indexPath, andPosition: position) else {
            return
        }
        
        itemBrain.deleteItem(item)
        tableView.reloadData()
    }
    
    private func wiggleCell(_ cell: ItemsByDateTableViewCell!, _ wiggle: Bool! = true, _ isOddyRow: Bool!) {
        if wiggle {
            cell.leftViewContainer.wiggle(withDuration: isOddyRow ? 0.105 : 0.115)
            cell.centerViewContainer.wiggle(withDuration: isOddyRow ? 0.115 : 0.105)
            cell.rightViewContainer.wiggle(withDuration: isOddyRow ? 0.105 : 0.115)
            cell.showDeleteButtons(true)
        } else {
            cell.leftViewContainer.layer.removeAllAnimations()
            cell.centerViewContainer.layer.removeAllAnimations()
            cell.rightViewContainer.layer.removeAllAnimations()
            cell.showDeleteButtons(false)
        }
    }

}

extension InventoryViewController: ItemScanningViewControllerDelegate {
    func pauseScanning() {
        tableView.reloadData()
    }
    
    func finishInventory() {
        NavigationManager.sharedInstance.showLoader {
            self.inventoryBrain.updateInventoryStatus(self.inventory, .closed) { (response) in
                NavigationManager.sharedInstance.hideLoader {
                    self.updateUIAfterFinishedInventory()
                    self.tableView.reloadData()
                }
            }
        }
    }
}

extension InventoryViewController: ItemsByDateFooterTableViewCellDelegate {
    func reportAction(_ sender: Any) {
        print("Report button action")
    }
}
