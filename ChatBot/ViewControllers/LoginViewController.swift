//
//  ViewController.swift
//  NBA Bot
//
//  Created by Pallav Trivedi on 07/02/18.
//  Copyright © 2018 Pallav Trivedi. All rights reserved.
//

import UIKit
import ApiAI
import AVFoundation

class LoginViewController: UIViewController {
    
    @IBOutlet var userName: UITextField!
    @IBOutlet var emailId: UITextField!
    @IBOutlet var contactNum: UITextField!
    @IBOutlet var chatNowButton: UIButton!
    
    @IBAction func onChatNowTapped(_ sender: Any) {
        guard isValidChatRequest() else { return }
        
        //Login Manager
        
        LoginManager.sharedInstance.login(userName: userName.text!, mobileNumber: contactNum.text, emailId: emailId?.text)
        
        let chatVc = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: kLoginVCStoryboardID) as? ChatViewController
        UIApplication.shared.sendAction(#selector(UIResponder.resignFirstResponder), to: nil, from: nil, for: nil)
        UIView.animate(withDuration: 0.5) {
            chatVc?.view.frame = CGRect(x: self.view.frame.origin.x, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height - 20)
            self.view.addSubview((chatVc?.view)!)
            self.addChildViewController(chatVc!)
            self.didMove(toParentViewController: chatVc)
        }
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    override func viewDidAppear(_ animated: Bool) {
        
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .lightContent
    }
    
    func isValidChatRequest() -> Bool {
        guard let username = userName.text, !username.isEmpty else { return false }
        return true
    }
}


