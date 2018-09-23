//
//  CustomQueue.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation

struct CustomQueue<T> {
    
    var capacity: Int?
    var list = Array<T>()
    
    mutating func enqueue(_ element: T) {
        list.append(element)
        
        if let maximumNumber = capacity {
            if list.count == maximumNumber {
                dequeue()
            }
        }
    }
    
    
    mutating func dequeue() {
        list.removeFirst()
    }
    
    func element(atIndex index: Int) -> T? {
        if list.count > index {
            return list[index]
        }
        return nil
    }
    
    mutating func emptyQueue() {
        while list.count != 0 {
            self.dequeue()
        }
    }
    
}
