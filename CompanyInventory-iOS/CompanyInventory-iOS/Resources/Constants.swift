//
//  Constants.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 2/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import UIKit

struct Constants {
    
    //Firebase constants
    //General
    static let kFirebaseCIUserNodeName = "ciUsers"
    static let kFirebaseItemNodeName = "items"
    static let kFirebaseInventoryNodeName = "inventories"
    static let kFirebaseUsernameNodeName = "username"
    static let kFirebaseNameNodeName = "name"
    static let kFirebaseSurnameNodeName = "surname"
    static let kFirebasePhotoFileName = "photoFileName"
    static let kFirebaseInventoriesNodeName = "inventories"
    //Inventory node names
    static let kFirebaseInventoryIdNodeName = "inventoryId"
    static let kFirebaseInventoryNameNodeName = "inventoryName"
    static let kFirebaseInventoryDescriptionNodeName = "inventoryDescription"
    static let kFirebaseInventoryStatusNodeName = "inventoryStatus"
    static let kFirebaseInventoryItemsByDateNodeName = "inventoryItemsByDate"
    //ItemByDate node names
    static let kFirebaseItemByDateIdNodeName = "itemByDateId"
    static let kFirebaseItemByDateDateNodeName = "itemByDateDate"
    static let kFirebaseItemByDateItemsNodeName = "itemByDateItems"
    //Item node names
    static let kFirebaseItemIdNodeName = "itemId"
    static let kFirebaseItemNameNodeName = "itemName"
    static let kFirebaseItemDescriptionNodeName = "itemDescription"
    static let kFirebaseItemBeaconIdNodeName = "itemBeaconId"
    static let kFirebaseItemStatusNodeName = "itemStatus"
    static let kFirebaseItemLocationNameNodeName = "itemLocationName"
    static let kFirebaseItemLatitudeNodeName = "itemLatitude"
    static let kFirebaseItemLongitudeNodeName = "itemLongitude"
    
    //Storyboard ids
    static let kStoryboardName = "Main"
    static let kLoaderViewControllerStoryboardId = "LoaderViewControllerId"
    static let kInventoryReuseIdentifier = "InventoryIdentifier"
    static let kItemsByDateCellIdentifier = "ItemsByDateCellIdentifier"
    static let kItemsByDateCellHeaderIdentifier = "ItemsByDateCellHeaderIdentifier"
    static let kItemsByDateCellFooterIdentifier = "ItemsByDateCellFooterIdentifier"
    static let kGenericPopupIdentifier = "GenericPopupIdentifier"
    
    //Segue ids
    static let kShowLoggedInAppSegue = "showLoggedInAppSegue"
    static let kShowInventorySegue = "showInventorySegue"
    static let kShowAddItemSegue = "showAddItemSegue"
    static let kShowScanningItemSegue = "showScanningItemSegue"
    static let kShowBeaconScanningSegue = "showBeaconScanningSegue"
    static let kShowItemDetailsSegue = "showItemDetailsSegue"
    
    //Animations files names
    static let kScanningBeaconAnimation = "scanningBeacon"
    static let kSuccessScanningAnimation = "successScanning"
    
    //Audio names
    static let kSuccessScanAudio = "successScanAudio"
    static let kAudioExtension = "m4a"
    
    //Beacons
    static let kBeaconProximityUid = "88888888-4444-4444-4444-111111222222"
    static let kBeaconIdentifier = "Inventory Beacon Region"
    static let kBeaconMinAccuracy = 0.4
    static let kBeaconMinProximity: CLProximity = .immediate
    static let kBeaconMinRSSI = -85
    static let kBeaconMonitoringForbiddenProximity: CLProximity = .unknown
    static let kBeaconMonitoringMinAccuracy = 0.8
    
    //Photo
    static let kDefaultItemSmallPhotoSize = CGSize(width: 100, height: 300)
    static let kDefaultItemLargePhotoSize = CGSize(width: 300, height: 300)
    static let kDefaultItemImageName = "defaultItem"
    
    //ThemeManager
    static let kTitleFontSize:CGFloat = 17.0
    static let kDefaultFontSize:CGFloat = 15.0
    static let kHeaderFontSize:CGFloat = 23.0
    static let kDescriptionFontSize = 15.0
    static let kDefaultFontName = "Helvetica"
    static let kDefaultBoldFontName = "Helvetica Bold"
    
    //Other
    static let kAnimationViewWidth = 200
    static let kAnimationViewHeight = 200
    static let kAnimationViewX = 200
    static let kAnimationViewY = 50
    static let kDefaultDateFormat = "yyyy/MM/dd"
    static let kAnimationLayerName = "AnimationLayerId"
    static let kWaitAfterBluetoothRetry = 1.0
    static let kWaitBeforeTableViewScrollToBottom = 0.7
    
    struct LocalizationKeys {
        static let kLoginSmallLabel = "login_top_label"
        static let kLoginLargeLabel = "login_app_name"
        static let kLoginUsernamePlaceholder = "login_username_placeholder"
        static let kLoginPasswordPlaceholder = "login_password_placeholder"
        static let kLoginButtonTitle = "login_button_title"
        static let kLoginError = "login_error_label"
        static let kInventoriesTab = "inventories_tab"
        static let kProfileTab = "profile_tab"
        static let kLocationsTab = "locations_tab"
        static let kMoreTab = "more_tab"
        static let kInventoriesTitle = "inventories_title"
        static let kCreateInventoryTitle = "create_inventory_title"
        static let kCreateInventoryDescription = "create_inventory_description"
        static let kGeneralNamePlaceholder = "general_name_placeholder"
        static let kGeneralDescriptionPlaceholder = "general_description_placeholder"
        static let kGeneralCancel = "general_cancel"
        static let kGeneralOk = "general_ok"
        static let kInventoryAddButton = "inventory_add_button"
        static let kStartInventory = "start_inventory_button_title"
        static let kScanningInventory = "scanning_inventory_button_title"
        static let kGeneralSave = "general_save"
        static let kNewItemTitle = "new_item_title"
        static let kNewItemAddPhoto = "new_item_add_photo"
        static let kNewItemChangePhoto = "new_item_change_photo"
        static let kNewItemLocationNamePlaceholder = "new_item_location_name_placeholder"
        static let kBeaconScannedSuccessfully = "beacon_scanned_successfully"
        static let kNewItemScan = "new_item_scan"
        static let kGeneralScanning = "general_scanning"
        static let kInventoryTitle = "inventory_title"
        static let kScanningItemExpired = "scanning_item_expired"
        static let kScanningItemMissing = "scanning_item_missing"
        static let kItemSuccess = "itemSuccess"
        static let kItemExpired = "itemExpired"
        static let kItemNotExisted = "itemNotExisted"
        static let kGeneralErrorTitle = "general_error_title"
        static let kGeneralErrorMessage = "general_error_message"
        static let kSavingItemErrorMessage = "saving_item_error_message"
        static let kMissingItemInfoTitle = "missing_item_informations_title"
        static let kMissingItemInfoMessage = "missing_item_informations_message"
        static let kTakePhoto = "take_photo"
        static let kChoosePhoto = "choose_photo"
        static let kDeletePhoto = "delete_photo"
        static let kReportTitle = "report_title"
        static let kNoInternetConnection = "no_internet_connection"
        static let kRetryButtonTitle = "general_retry"
        static let kBluetoothErrorTitle = "bluetooth_error_title"
        static let kBluetoothErrorDescription = "bluetooth_error_description"
        static let kInventoryByDateFinished = "inventory_by_date_finished"
        static let kGeneralWarning = "general_warning"
        static let kOpenedInventoryError = "opened_inventory_error"
        static let kItemDetails = "item_details_title"
        static let kDescriptionLabel = "description_label_title";
        static let kLocationLabel = "location_label_title";
        static let kBeaconIdLabel = "beacon_id_label_title";
        static let kDeleteItemButtonTitle = "delete_item_button_title";
    }
    
}
