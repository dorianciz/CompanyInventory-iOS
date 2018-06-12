//
//  MoreItem.swift
//  Zandvoort-iOS
//
//  Created by Dorian Cizmar on 4/13/18.
//  Copyright © 2018 Levi9. All rights reserved.
//

import Foundation

/// Represents each row in more menu screen.
/// If there should be added new row in more menu, add new enum value here.
/// Order of items in menu is defined by value of each case
enum MoreItem {
    case ClearInventories
    case HelpAndSupport
    case StaySignedIn
    case Version
    case Logout
}
