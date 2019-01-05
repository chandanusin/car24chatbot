//
//  LoginManager.swift
//  
//
//  Created by Adarsh on 05/01/19.
//

import Foundation

class LoginManager: NSObject {
    
    static let sharedInstance: LoginManager = {
        let instance = LoginManager()
        // setup code
        return instance
    }()
    
    private var userName: String = ""
    private var mobileNumber : String? = ""
    private var emailId : String? = ""
    
    private var userId = ""
    
    func login(userName: String, mobileNumber : String?, emailId: String?) {
        self.userName = userName
        self.mobileNumber = mobileNumber
        self.emailId = emailId
        self.userId = UUID().uuidString
    }
    
    func getUserName() -> String {
        return userName
    }
    
    func getUserId() -> String {
        return userId
    }
    
    func getMobileNumber() -> String? {
        return mobileNumber
    }
    
    func getEmailId() -> String? {
        return emailId
    }
    
}
