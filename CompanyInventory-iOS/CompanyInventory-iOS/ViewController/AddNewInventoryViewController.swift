//
//  AddNewInventoryViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 4/16/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit

class AddNewInventoryViewController: UIViewController {

    @IBOutlet weak var nameTextField: UITextField!
    @IBOutlet weak var descriptionTextView: UITextView!
    @IBOutlet weak var cancelButton: UIButton!
    
    private let inventoryBrain = InventoryBrain()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        descriptionTextView.delegate = self
        applyStyles()
        // Do any additional setup after loading the view.
    }
    
    private func applyStyles() {
        self.navigationItem.title = "New inventory"
        self.navigationItem.setHidesBackButton(true, animated: false)
        descriptionTextView.layer.borderColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        cancelButton.layer.borderColor = #colorLiteral(red: 1, green: 0.231372549, blue: 0.1882352941, alpha: 1)
        descriptionTextView.text = "Description (Optional)"
        descriptionTextView.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        self.tabBarController?.tabBar.isHidden = false
    }
    
    @IBAction func finishAction(_ sender: Any) {
        inventoryBrain.createNewInventory(nameTextField.text, descriptionTextView.text) { (response) in            
            switch response {
            case .success:
                self.navigationController?.popViewController(animated: true)
            case .error:
                //Handle error
                break
            default:
                break
            }
        }
    }

    @IBAction func cancelAction(_ sender: Any) {
        self.navigationController?.popViewController(animated: true)
    }
    
}

extension AddNewInventoryViewController: UITextViewDelegate {
    func textViewDidBeginEditing(_ textView: UITextView) {
        if textView.textColor == #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1) {
            textView.text = nil
            textView.textColor = UIColor.black
        }
    }
    func textViewDidEndEditing(_ textView: UITextView) {
        if textView.text.isEmpty {
            textView.text = "Description (Optional)"
            textView.textColor = #colorLiteral(red: 0.8039215803, green: 0.8039215803, blue: 0.8039215803, alpha: 1)
        }
    }
}
