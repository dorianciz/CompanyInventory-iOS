//
//  PDFHandler.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/27/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import PDFGenerator

class PDFHandler {
    static let sharedInstance = PDFHandler()
    
    private let dateHelper = DateHelper()
    private let documentHandler = DocumentManager()
    
    func generatePDFDocument(forInventory inventory: Inventory) {
        let views = createPDFViews(fromInventory: inventory)
        let destinationPath = "\(documentHandler.getDirectoryPath())/\(Constants.kReportsDirectory)/\(inventory.inventoryId!).pdf"

        if !documentHandler.isFileExists(withName: Constants.kReportsDirectory) {
            documentHandler.createDirectory(withName: Constants.kReportsDirectory)
        }
        
        do {
            try PDFGenerator.generate(views, to: destinationPath)
        } catch (let error) {
            print(error)
        }
    }
    
    func generatePDFDocument(forInventoryByDate inventoryByDate: InventoryItemByDate?, withInventoryName name: String?) {
        guard let inventoryItemByDate = inventoryByDate, let itemByDateId = inventoryByDate?.id else {
            return
        }
        
        let views = createPDFViews(forItemByDate: inventoryItemByDate, withInventoryName: name)
        let destinationPath = "\(documentHandler.getDirectoryPath())/\(Constants.kReportsDirectory)/\(itemByDateId).pdf"
        
        if !documentHandler.isFileExists(withName: Constants.kReportsDirectory) {
            documentHandler.createDirectory(withName: Constants.kReportsDirectory)
        }
        
        do {
            try PDFGenerator.generate(views, to: destinationPath)
        } catch (let error) {
            print(error)
        }
        
    }
    
    private func createPDFViews(fromInventory inventory: Inventory?) -> [UIView] {
        var views = [UIView]()
        
        if let inventory = inventory {
            inventory.items?.forEach({ (itemByDate) in
                let viewsByDate = createPDFViews(forItemByDate: itemByDate, withInventoryName: inventory.name)
                views.append(contentsOf: viewsByDate)
            })
        }
        
        return views
    }
    
    fileprivate func createPDFViews(forItemByDate itemByDate: InventoryItemByDate, withInventoryName name: String?) -> [UIView] {
        var views = [UIView]()
        
        if let count = itemByDate.items?.count {
            let numberOfViews: Int = (count / Constants.kPFDItemsPerPage) + 1
            for i in 0..<numberOfViews {
                let view = UIView(frame: CGRect(x: 0, y: 0, width: 500, height: 600))
                view.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
                
                let titleLabel = UILabel(frame: CGRect(x: 25, y: 25, width: 450, height: 25))
                titleLabel.text = name
                titleLabel.font = ThemeManager.sharedInstance.titleFont
                titleLabel.textAlignment = .center
                let dateLabel = UILabel(frame: CGRect(x: 25, y: 65, width: 450, height: 25))
                dateLabel.text = dateHelper.getStringFromDate(itemByDate.date)
                dateLabel.textAlignment = .center
                dateLabel.font = ThemeManager.sharedInstance.titleFont
                
                view.addSubview(titleLabel)
                view.addSubview(dateLabel)
                
                for j in i*Constants.kPFDItemsPerPage..<(i+1)*Constants.kPFDItemsPerPage {
                    if j >= count {
                        break
                    }
                    
                    guard let item = itemByDate.items?[j] else {
                        return views
                    }
                    
                    let numberLabel = UILabel(frame: CGRect(x: 5, y: 100 + j*25, width: 21, height: 26))
                    numberLabel.text = " \(j+1)."
                    ThemeManager.sharedInstance.stylePDFRowLabel(numberLabel)
                    view.addSubview(numberLabel)
                    
                    let nameLabel = UILabel(frame: CGRect(x: 25, y: 100 + j*25, width: 76, height: 26))
                    nameLabel.text = " " + item.name!
                    ThemeManager.sharedInstance.stylePDFRowLabel(nameLabel)
                    view.addSubview(nameLabel)
                    
                    let descriptionLabel = UILabel(frame: CGRect(x: 100, y: 100 + j*25, width: 226, height: 26))
                    descriptionLabel.text = " " + item.descriptionText!
                    ThemeManager.sharedInstance.stylePDFRowLabel(descriptionLabel)
                    view.addSubview(descriptionLabel)
                    
                    let locationLabel = UILabel(frame: CGRect(x: 325, y: 100 + j*25, width: 121, height: 26))
                    locationLabel.text = " " + item.locationName!
                    ThemeManager.sharedInstance.stylePDFRowLabel(locationLabel)
                    view.addSubview(locationLabel)
                    
                    let statusLabel = UILabel(frame: CGRect(x: 445, y: 100 + j*25, width: 50, height: 26))
                    statusLabel.text = " \(getStatusTitle(forStatus: item.status))"
                    ThemeManager.sharedInstance.stylePDFRowLabel(statusLabel)
                    view.addSubview(statusLabel)
                    
                }
                views.append(view)
            }
        }
        
        return views
    }
    
    fileprivate func getStatusTitle(forStatus status: ItemStatus) -> String {
        switch status {
        case .success:
            return NSLocalizedString(Constants.LocalizationKeys.kItemSuccess, comment: "")
        case .nonExistent:
            return NSLocalizedString(Constants.LocalizationKeys.kItemNotExisted, comment: "")
        case .expired:
            return NSLocalizedString(Constants.LocalizationKeys.kItemExpired, comment: "")
        default:
            return "None"
        }
    }
    
}
