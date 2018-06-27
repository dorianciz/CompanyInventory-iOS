//
//  ItemAnnotation.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 6/27/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit
import MapKit

class ItemAnnotation: NSObject, MKAnnotation {
    var name: String?
    var descriptionText: String
    var locationName: String
    var photoPath: String
    var coordinate: CLLocationCoordinate2D
    
    init(_ name: String, _ description: String, _ locationName: String, _ photoPath: String, _ coordinate: CLLocationCoordinate2D) {
        self.name = name
        self.descriptionText = description
        self.locationName = locationName
        self.photoPath = photoPath
        self.coordinate = coordinate
    }
    
    var title: String? {
        get {
            return name
        }
    }
    
    var subtitle: String? {
        get {
            return locationName
        }
    }

}
