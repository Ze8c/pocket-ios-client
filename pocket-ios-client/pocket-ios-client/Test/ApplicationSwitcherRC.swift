//
//  ApplicationSwitcherRootController.swift
//  pocket-ios-client
//
//  Created by Damien on 09/10/2018.
//  Copyright © 2018 Damien Inc. All rights reserved.
//

import UIKit

class ApplicationSwitcherRC {
    
    static var response: String!
    
    static func choiseRootVC() {
    
        var rootVC: UIViewController
        
        let token = UserDefaults.standard.string(forKey: "token")
        
        if token != nil {
            NetworkServices.getSelfUser(token: token!) { (response) in
                self.response = response
            }
          
            // Грязный хак пока выполняется паралельный запрос
            // Такое себе, чуть позже сделаю нормально
            // Но работает :)
            // Но на самом деле нет - если с сервака придёт nil - будет бесконечный цикл
            while response == nil {
            }
            
            rootVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "TabBarController") as! UITabBarController
        }
        
        else {
            rootVC = UIStoryboard.init(name: "Login", bundle: nil).instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        }
        
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
    
}