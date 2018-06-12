//
//  DocumentManager.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 5/18/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import Foundation
import UIKit

class DocumentManager {
    
    var directoryPath: String!
    
    init() {
        directoryPath = getDirectoryPath()
    }
    
    init(withDirectoryPath path: String?) {
        directoryPath = path
    }
    
    func getImageFromDocument(withName name: String?) -> UIImage? {
        guard let imageName = name else {
            print("Image name is invalid")
            return nil
        }
        
        let fileManager = FileManager.default
        let imagePath = (self.directoryPath as NSString).appendingPathComponent(imageName)
        if fileManager.fileExists(atPath: imagePath){
            return UIImage(contentsOfFile: imagePath)
        }else{
            print("Image not found")
        }
        return nil
    }
    
    func getFileFromDocument(withName name: String) -> Data? {
        let fileManager = FileManager.default
        let filePath = (self.directoryPath as NSString).appendingPathComponent(name)
        if fileManager.fileExists(atPath: filePath){
            do {
                let data = try Data(contentsOf: URL(fileURLWithPath: filePath))
                return data
            } catch {
                return nil
            }
        }else{
            print("File not found")
        }
        return nil
    }
    
    func saveImageToDocumentDirectory(_ imageName: String?, _ image: UIImage?) {
        guard let name = imageName, let imageToSave = image else {
            print("Error - Invalid data has been passed")
            return
        }
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(name)
        let imageData = UIImageJPEGRepresentation(imageToSave, 0.5)
        fileManager.createFile(atPath: paths as String, contents: imageData, attributes: nil)
    }
    
    func saveFileToDocumentDirectory(_ fileName: String, _ data: Data) {
        let fileManager = FileManager.default
        let paths = (NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0] as NSString).appendingPathComponent(fileName)
        fileManager.createFile(atPath: paths as String, contents: data, attributes: nil)
    }
    
    func isFileExists(withName name: String) -> Bool {
        let fileManager = FileManager.default
        let filePath = (self.directoryPath as NSString).appendingPathComponent(name)
        if fileManager.fileExists(atPath: filePath){
            return true
        }else{
            return false
        }
    }
    
    private func getDirectoryPath() -> String {
        let paths = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)
        let documentsDirectory = paths[0]
        return documentsDirectory
    }
    
}
