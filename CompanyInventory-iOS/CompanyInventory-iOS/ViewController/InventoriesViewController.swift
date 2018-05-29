//
//  InventoriesViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/14/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

class InventoriesViewController: UIViewController {
    @IBOutlet weak var noInventoriesLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    private let inventoryBrain = InventoryBrain()
    private var inventories: [Inventory]?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        fetchInventories()
        fillStaticLabels()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        inventories = inventoryBrain.getAllLocalInventories()
        if inventories?.count != 0 {
            // Reload table view
            tableView.isHidden = false
            tableView.reloadData()
        } else {
            self.tableView.isHidden = true
        }
    }
    
    private func fillStaticLabels() {
        navigationItem.title = NSLocalizedString(Constants.LocalizationKeys.kInventoriesTitle, comment: "")
    }
    
    private func fetchInventories() {
        NavigationManager.sharedInstance.showLoader {
            self.inventoryBrain.fetchAllInventories({ (response, inventories) in
                NavigationManager.sharedInstance.hideLoader {
                    if response == .success {
                        if let inventoriesList = inventories {
                            if inventoriesList.count != 0 {
                                self.inventories = self.inventoryBrain.getAllLocalInventories()
                                if self.inventories?.count != 0 {
                                    self.tableView.isHidden = false
                                    self.tableView.reloadData()
                                } else {
                                    self.tableView.isHidden = true
                                }
                            } else {
                                self.tableView.isHidden = true
                            }
                        } else {
                            self.tableView.isHidden = true
                        }
                    } else if response == .noInternetConnection {
                        PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kGeneralErrorTitle, comment: ""), withDescription: NSLocalizedString(Constants.LocalizationKeys.kNoInternetConnection, comment: ""), withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kRetryButtonTitle, comment: ""), withCancelButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""), withPopupType: .error, withOkCompletion: {
                            self.fetchInventories()
                        }, withCancelCompletion: nil)
                    } else {
                        //Error
                    }
                }
            })
        }
    }
    
    @IBAction func createNewInventoryAction(_ sender: Any) {
        if let lastInventoryStatus = inventories?.last?.status {
            switch lastInventoryStatus {
            case .open, .closed:
                PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kGeneralWarning, comment: ""), withDescription: NSLocalizedString(Constants.LocalizationKeys.kOpenedInventoryError, comment: ""), withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralOk, comment: ""), withCancelButtonText: nil, withPopupType: .success, withOkCompletion: nil, withCancelCompletion: nil)
            case .inProgress:
                NavigationManager.sharedInstance.showLoader {
                    self.inventoryBrain.updateInventoryStatus(self.inventories!.last, .closed) { (response) in
                        if response == .success {
                            let alertController = PopupManager.sharedInstance.showGenericPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kCreateInventoryTitle, comment: ""), withMessage: NSLocalizedString(Constants.LocalizationKeys.kCreateInventoryDescription, comment: ""), withTextFieldsPlaceholders: [NSLocalizedString(Constants.LocalizationKeys.kGeneralNamePlaceholder, comment: ""), NSLocalizedString(Constants.LocalizationKeys.kGeneralDescriptionPlaceholder, comment: "")]) { results in
                                results.forEach{print($0)}
                                NavigationManager.sharedInstance.showLoader {
                                    self.createNewInventory(results[0], results[1])
                                }
                                
                            }
                            NavigationManager.sharedInstance.hideLoader {
                                self.present(alertController, animated: true, completion: nil)
                            }
                        }
                    }
                }
                
            default:
                break
            }
        } else {
            let alertController = PopupManager.sharedInstance.showGenericPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kCreateInventoryTitle, comment: ""), withMessage: NSLocalizedString(Constants.LocalizationKeys.kCreateInventoryDescription, comment: ""), withTextFieldsPlaceholders: [NSLocalizedString(Constants.LocalizationKeys.kGeneralNamePlaceholder, comment: ""), NSLocalizedString(Constants.LocalizationKeys.kGeneralDescriptionPlaceholder, comment: "")]) { results in
                results.forEach{print($0)}
                NavigationManager.sharedInstance.showLoader {
                    self.createNewInventory(results[0], results[1])
                }
                
            }
            
            present(alertController, animated: true, completion: nil)
        }
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let segueId = segue.identifier {
            if segueId == Constants.kShowInventorySegue {
                if let indexPath = tableView.indexPathForSelectedRow {
                    let controller = segue.destination as! InventoryViewController
                    if let inventoryId = inventories?[indexPath.row].inventoryId {
                        controller.inventoryId = inventoryId
                    } else {
                        controller.inventoryId = nil
                    }
                    
                }
            }
        }
    }
    
    private func createNewInventory(_ name: String?, _ description: String?) {
        self.inventoryBrain.createNewInventory(self.inventories?.last, name, description, { (response) in
            NavigationManager.sharedInstance.hideLoader {
                switch response {
                case .success:
                    if self.tableView.isHidden {
                        self.tableView.isHidden = false
                    }
                    self.inventories = self.inventoryBrain.getAllLocalInventories()
                    self.tableView.reloadData()
                case .error:
                    //Show error
                    break
                case .noInternetConnection:
                    PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kGeneralErrorTitle, comment: ""), withDescription: NSLocalizedString(Constants.LocalizationKeys.kNoInternetConnection, comment: ""), withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kRetryButtonTitle, comment: ""), withCancelButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralCancel, comment: ""), withPopupType: .error, withOkCompletion: {
                        self.createNewInventory(name, description)
                    }, withCancelCompletion: nil)
                default:
                    break
                }
            }
        })
    }
}

extension InventoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.kShowInventorySegue, sender: tableView)
    }
    
    func tableView(_ tableView: UITableView, editActionsForRowAt indexPath: IndexPath) -> [UITableViewRowAction]? {
        let report = UITableViewRowAction(style: .normal, title: NSLocalizedString(Constants.LocalizationKeys.kReportTitle, comment: "")) { action, index in
            print("Creating report")
        }
        report.backgroundColor = ThemeManager.sharedInstance.generalBlueColor
        // Check if inventory is finished
        
        return [report]
    }
    
}

extension InventoriesViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        if let count = inventories?.count {
            return count
        }
        return 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kInventoryReuseIdentifier, for: indexPath) as! InventoryTableViewCell
        
        if let inventoriesArray = inventories {
            let currentInventory = inventoriesArray[indexPath.row]
            cell.titleLabel.text = currentInventory.name
            cell.descriptionLabel.text = currentInventory.descriptionText
            switch currentInventory.status {
            case .open:
                cell.statusView.backgroundColor = ThemeManager.sharedInstance.inventoryOpenedColor
            case .closed:
                cell.statusView.backgroundColor = ThemeManager.sharedInstance.inventoryClosedColor
            case .inProgress:
                cell.statusView.backgroundColor = ThemeManager.sharedInstance.inventoryInProgressColor
            default:
                cell.statusView.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
            }
        }
        
        cell.selectionStyle = .none
        
        return cell
    }
    
}
