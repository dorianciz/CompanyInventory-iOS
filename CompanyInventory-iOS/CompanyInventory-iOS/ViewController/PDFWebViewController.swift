//
//  PDFWebViewController.swift
//  CompanyInventory-iOS
//
//  Created by Dorian Cizmar on 7/3/18.
//  Copyright © 2018 Dorian Cizmar. All rights reserved.
//

import UIKit
import WebKit
import MessageUI

class PDFWebViewController: UIViewController {

    @IBOutlet weak var mailButton: UIButton!
    
    var webView: WKWebView!
    var pdfFilePath: String?
    
    private let documentHandler = DocumentManager()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        let webConfiguration = WKWebViewConfiguration()
        webView = WKWebView(frame: view.frame, configuration: webConfiguration)
        webView.allowsBackForwardNavigationGestures = true
        webView.allowsLinkPreview = true
        
        view.addSubview(webView)
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        loadPdf()
        
        mailButton.layoutIfNeeded()
        ThemeManager.sharedInstance.styleClearButton(button: mailButton)
        mailButton.backgroundColor = #colorLiteral(red: 1.0, green: 1.0, blue: 1.0, alpha: 1.0)
        view.bringSubview(toFront: mailButton)
    }
    
    private func loadPdf() {
        guard let filePath = pdfFilePath, let fileData = documentHandler.getFileFromDocument(withName: filePath) else {
            return
        }
        
        webView.load(fileData, mimeType: "application/pdf", characterEncodingName: "", baseURL: URL(fileURLWithPath: filePath))
    }

    @IBAction func mailAction(_ sender: Any) {
        guard let filePath = pdfFilePath else {
            return
        }
        if let fileData = documentHandler.getFileFromDocument(withName: filePath) {
            if MFMailComposeViewController.canSendMail() {
                let mail = MFMailComposeViewController()
                mail.mailComposeDelegate = self
                mail.setSubject("Inventory report")
                mail.setMessageBody("<p>Dear ,<br><br>There is PDF file report in attachment for your company.<br><br>Best regards</p>", isHTML: true)
                mail.addAttachmentData(fileData, mimeType: "application/pdf", fileName: "Report.pdf")
                
                present(mail, animated: true)
            } else {
                // show failure alert
            }
        }
    }

}

extension PDFWebViewController: MFMailComposeViewControllerDelegate {
    func mailComposeController(_ controller: MFMailComposeViewController, didFinishWith result: MFMailComposeResult, error: Error?) {
        dismiss(animated: true, completion: nil)
    }
}
