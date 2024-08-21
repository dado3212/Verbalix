//
//  ShareViewController.swift
//  VerbalixShareExtension
//
//  Created by Alex Beals on 8/20/24.
//

import UIKit
import Social

class ShareViewController: SLComposeServiceViewController {

    override func isContentValid() -> Bool {
      print("validity")
//      print(self.contentText)
        // Do validation of contentText and/or NSExtensionContext attachments here
        return true
    }

    override func didSelectPost() {
      print(extensionContext)
      if let item = extensionContext?.inputItems.first as? NSExtensionItem,
             let itemProvider = item.attachments?.first {
              if itemProvider.hasItemConformingToTypeIdentifier("public.text") {
                  itemProvider.loadItem(forTypeIdentifier: "public.text", options: nil) { (item, error) in
                      if let text = item as? String {
                          // Handle the shared text
                      }
                  }
              }
          }
          extensionContext?.completeRequest(returningItems: [], completionHandler: nil)
        // This is called after the user selects Post. Do the upload of contentText and/or NSExtensionContext attachments.
    
        // Inform the host that we're done, so it un-blocks its UI. Note: Alternatively you could call super's -didSelectPost, which will similarly complete the extension context.
        self.extensionContext!.completeRequest(returningItems: [], completionHandler: nil)
    }

    override func configurationItems() -> [Any]! {
      print("configuration items")
        // To add configuration options via table cells at the bottom of the sheet, return an array of SLComposeSheetConfigurationItem here.
        return []
    }

}
