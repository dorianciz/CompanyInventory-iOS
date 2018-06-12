//
//  MoreViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/3/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

class MoreViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    
    var brain: MoreMenuBrain!
    var loginBrain: LoginBrain!
    var inventoryBrain: InventoryBrain!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        brain = MoreMenuBrain()
        loginBrain = LoginBrain()
        inventoryBrain = InventoryBrain()
        // Do any additional setup after loading the view.
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        removeEmptyCells()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func removeEmptyCells() {
        let view = UIView(frame: CGRect.zero)
        tableView.tableFooterView = view
    }
    
    private func switchButtonAction(forType type: MoreItem?, withSwitchResult result: Bool?) {
        guard let itemType = type, let switchResult = result else {
            return
        }
        
        switch itemType {
        case .StaySignedIn:
            staySignedInSwitchAction(switchResult)
        default:
            break
        }
    }
    
    private func staySignedInSwitchAction(_ stay: Bool!) {
        PersistanceService.sharedInstance.setStaySignedIn(stay)
    }
    
    private func rowButtonAction(forType type: MoreItem?) {
        guard let itemType = type else {
            return
        }
        
        switch itemType {
        case .ClearInventories:
            clearAllInventoriesAction()
        case .HelpAndSupport:
            helpAndSupportAction()
        default:
            break
        }
    }

    private func clearAllInventoriesAction() {
        PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kClearInventoriesQuestion, comment: ""), withDescription: nil, withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralYes, comment: ""), withCancelButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralNo, comment: ""), withPopupType: nil, withOkCompletion: {
            NavigationManager.sharedInstance.showLoader {
                self.inventoryBrain.clearAllInventories(withCompletion: { (response) in
                    NavigationManager.sharedInstance.hideLoader {
                        switch response {
                        case .success:
                            break
                        case .noInternetConnection:
                            PopupManager.sharedInstance.showNoInternetConnection {
                                self.clearAllInventoriesAction()
                            }
                        default:
                            break
                        }
                    }
                })
            }
        }, withCancelCompletion: nil)
    }
    
    private func helpAndSupportAction() {
        print("Help & support feature has not been implemented yet.")
    }

}

extension MoreViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let item = brain.getMoreItemData(onPosition: indexPath.row, inSection: indexPath.section)
        let type = brain.getMoreItemType(item)
        rowButtonAction(forType: type)
    }
}

extension MoreViewController: UITableViewDataSource {
    func numberOfSections(in tableView: UITableView) -> Int {
        return brain.getNumberOfSections()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return brain.getNumberOfRows(inSection: section)
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 45
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let data = brain.getMoreItemData(onPosition: indexPath.row, inSection: indexPath.section)
        
        if let type = brain.getMoreItemType(data) {
            if type == .Logout {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kLogoutCellReuseIdentifier, for: indexPath) as! LogoutTableViewCell
                cell.button.setTitle(data?.title, for: .normal)
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            } else {
                let cell = tableView.dequeueReusableCell(withIdentifier: Constants.kMoreCellReuseIdentifier, for: indexPath) as! MoreItemTableViewCell
                
                if let data = data, let showSwitchButton = data.toogle {
                    cell.titleLabel.text = data.title
                    cell.switchButton.isHidden = !showSwitchButton
                    if let showHelperLabel = data.helperRightLabel {
                        cell.helperLabel.isHidden = false
                        cell.helperLabel.text = showHelperLabel
                    } else {
                        cell.helperLabel.isHidden = true
                    }
                }
                
                if type == .StaySignedIn {
                    cell.switchButton.isOn = PersistanceService.sharedInstance.shouldStaySignedIn() ?? true
                }
                
                cell.indexPath = indexPath
                cell.selectionStyle = .none
                cell.delegate = self
                return cell
            }
        }
        
        return UITableViewCell()
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView?
    {
        let headerView = UIView(frame: CGRect(x: 0, y: 0, width: tableView.bounds.size.width, height: 30))
        headerView.backgroundColor = UIColor.clear
        return headerView
    }
}

extension MoreViewController: MoreItemDelegate {
    
    func switchAction(_ sender: MoreItemTableViewCell,  _ uiSwitch: UISwitch?) {
        let item = brain.getMoreItemData(onPosition: sender.indexPath.row, inSection: sender.indexPath.section)
        let type = brain.getMoreItemType(item)
        switchButtonAction(forType: type, withSwitchResult: uiSwitch?.isOn)
    }
}

extension MoreViewController: LogoutTableViewCellDelegate {
    func buttonAction() {
        PopupManager.sharedInstance.showPopup(withTitle: NSLocalizedString(Constants.LocalizationKeys.kLogoutTitle, comment: ""), withDescription: nil, withOkButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralYes, comment: ""), withCancelButtonText: NSLocalizedString(Constants.LocalizationKeys.kGeneralNo, comment: ""), withPopupType: nil, withOkCompletion: {
            self.loginBrain.logout()
            self.performSegue(withIdentifier: Constants.kLogoutSegue, sender: self)
        }, withCancelCompletion: nil)
    }
}
