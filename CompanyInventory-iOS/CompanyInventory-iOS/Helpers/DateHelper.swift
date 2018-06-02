//
//  DateHelper.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/20/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

class DateHelper {

    var dateFormat: String?// = "yyyy/MM/dd"
    
    init(withDateFormat format: String? = Constants.kDefaultDateFormat) {
        self.dateFormat = format
    }
    
    func getStringFromDate(_ date: Date?) -> String? {
        guard let dateValue = date else {
            return ""
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = dateFormat ?? Constants.kDefaultDateFormat
        let defaultTimeZoneStr = formatter.string(from: dateValue)
        
        return defaultTimeZoneStr
    }
    
    func getDateFromString(_ string: String?) -> Date? {
        guard let dateString = string else {
            return nil
        }
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = dateFormat ?? Constants.kDefaultDateFormat
        let date = dateFormatter.date(from: dateString)
        
        return date
    }
    
    func getTimestampFromDate(_ date: Date?) -> Double? {
        guard let dateToConvert = date else {
            return nil
        }
        
        return dateToConvert.timeIntervalSince1970
    }
    
    func getDateFromTimestamp(_ timestamp: Double?) -> Date? {
        guard let timestampToConvert = timestamp else {
            return nil
        }
        
        return Date(timeIntervalSince1970: timestampToConvert)
        
    }
    
}
