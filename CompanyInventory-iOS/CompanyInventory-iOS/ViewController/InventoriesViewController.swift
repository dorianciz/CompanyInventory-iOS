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
                    } else {
                        //Error
                    }
                }
            })
        }
    }
    
    @IBAction func createNewInventoryAction(_ sender: Any) {
        let alertController = PopupManager.sharedInstance.showGenericPopup(withTitle: "Create new inventory", withMessage: "Add name of inventory with short description", withTextFieldsPlaceholders: ["Name", "Description"]) { results in
            results.forEach{print($0)}
            NavigationManager.sharedInstance.showLoader {
                self.inventoryBrain.createNewInventory(results[0], results[1], { (response) in
                    NavigationManager.sharedInstance.hideLoader {
                        switch response {
                        case .success:
                            self.inventories = self.inventoryBrain.getAllLocalInventories()
                            self.tableView.reloadData()
                        case .error:
                            //Show error
                            break
                        default:
                            break
                        }
                    }
                })
            }
            
        }
        
        present(alertController, animated: true, completion: nil)
    }
    
}

extension InventoriesViewController: UITableViewDelegate {
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        performSegue(withIdentifier: Constants.kShowInventorySegue, sender: nil)
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
        }
        
        return cell
    }
    
}
