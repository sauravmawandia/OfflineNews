//
//  LoginManager.swift
//  iNews
//
//  Created by Ashish Bansal on 12/11/17.
//  Copyright © 2017 iNews. All rights reserved.
//

import Foundation
import AWSAuthCore
import AWSAuthUI
import AWSAuthCore
import AWSCore

class LoginManager {
    
    static let sharedInstance = LoginManager()
    
    private init() {
        
    }
    
    var isLoggedIn: Bool {
        return AWSSignInManager.sharedInstance().isLoggedIn
    }
    
    func logout(completion: @escaping ((Bool) -> Void)) {
        AWSSignInManager.sharedInstance().logout { (result, error) in
            completion(error != nil)
        }
    }
}
