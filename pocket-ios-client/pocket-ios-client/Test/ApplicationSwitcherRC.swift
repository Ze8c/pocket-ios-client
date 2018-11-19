//
//  ApplicationSwitcherRootController.swift
//  pocket-ios-client
//
//  Created by Damien on 09/10/2018.
//  Copyright © 2018 Damien Inc. All rights reserved.
//

import UIKit

class ApplicationSwitcherRC {
    
    static var rootVC: UIViewController!
    
    enum ChoiceRootVC {
        case login
        case tabbar
    }
    
    static func choiseRootVC() {
        
        let token = TokenService.getToken(forKey: "token")
        print (UserSelf.account_name + " " + UserSelf.email + " " + UserSelf.password)
        
        if token != nil {
            NetworkServices.getSelfUser(token: token!) { (json, statusCode) in
                
                if statusCode == 200 {
                    
                    DataBase.saveSelfUser(json: json)
                    DataBase.instance.loadAllContactsFromDB(keyId: UserSelf.uid)
                    
                    DispatchQueue.main.async {
                        initVC(choiseVC: .tabbar)
                    }
                }
                else {
                    //Костыль на случай протухания токена
                    TokenService.setToken(token: nil, forKey: "token")
                    DispatchQueue.main.async {
                        initVC(choiseVC: .login)
                    }
                }
            }
        }

        else {
            initVC(choiseVC: .login)
        }
    }
    
    static func ifServerDown() {
        
        initVC(choiseVC: .tabbar)
        
    }
    
    static func initVC(choiseVC: ChoiceRootVC) {
        let initVC = UIStoryboard.init(name: "Login", bundle: nil)
        
        switch choiseVC {
        case .login:
            rootVC = initVC.instantiateViewController(withIdentifier: "LoginViewController") as! LoginViewController
        case .tabbar:
            rootVC = initVC.instantiateViewController(withIdentifier: "TabBarController") as! InitAfterLogin            
        }
        
        let appDelegate = UIApplication.shared.delegate as! AppDelegate
        appDelegate.window?.rootViewController = rootVC
    }
}
