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
}

extension InventoriesViewController: UITableViewDelegate {
    
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
