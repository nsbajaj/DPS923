//
//  DataModelManager+USDA.swift
//  Assignment4
//
//  Created by Nitish Bajaj on 2018-11-29.
//  Copyright © 2018 SICT. All rights reserved.
//

import Foundation

extension DataModelManager {
    
    func foodItem_Search(searchTerms: String){
        // Create a request object (and configure it if necessary)
        let request = WebApiRequest()
        
        // Send the request, and write a completion method to pass to the request
        
        request.sendRequest(toUrlPath: searchTerms, completion: {
            
            (result: NdbSearchPackage) in
            
            // Save the result in the manager property
            self.package = result
            
            // Post a notification
            NotificationCenter.default.post(name: Notification.Name("WebApiDataIsReady"), object: nil)
        })
    }
}
