//
//  MoreData.swift
//  Zandvoort-iOS
//
//  Created by Dorian Cizmar on 4/10/18.
//  Copyright © 2018 Levi9. All rights reserved.
//

import Foundation

class MoreTabItems: MoreTabItemsProtocol {
    var rowsItems: [MoreItem : MoreItemData]!
    
    init() {
        rowsItems = [.ClearInventories: MoreItemData(title: NSLocalizedString(Constants.LocalizationKeys.kMoreItemClearInventories, comment: ""), toogle: false, helperRightLabel: nil, section: 0, positionInSection: 1),
        .HelpAndSupport: MoreItemData(title: NSLocalizedString(Constants.LocalizationKeys.kMoreItemHelpAndSupport, comment: ""), toogle: false, helperRightLabel: nil, section: 0, positionInSection: 3),
        .Version: MoreItemData(title: NSLocalizedString(Constants.LocalizationKeys.kMoreItemVersion, comment: ""), toogle: false, helperRightLabel: "1.0.0", section: 0, positionInSection: 2),
        .StaySignedIn: MoreItemData(title: NSLocalizedString(Constants.LocalizationKeys.kMoreItemStaySignedIn, comment: ""), toogle: true, helperRightLabel: nil, section: 0, positionInSection: 0),
        .Logout: MoreItemData(title: NSLocalizedString(Constants.LocalizationKeys.kMoreItemLogout, comment: ""), toogle: false, helperRightLabel: nil, section: 1, positionInSection: 0)]
    }
    
}
