//
//  MoreItem.swift
//  Zandvoort-iOS
//
//  Created by Dorian Cizmar on 4/13/18.
//  Copyright © 2018 Levi9. All rights reserved.
//

import Foundation
import UIKit

/// Data for one row in more menu
struct MoreItemData {
    var title: String
    var toogle: Bool?
    var helperRightLabel: String?
    var section: Int! = 0
    var positionInSection: Int!
}
