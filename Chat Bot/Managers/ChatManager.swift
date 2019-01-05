//
//  ChatManager.swift
//  Chat Bot
//
//  Created by Adarsh on 05/01/19.
//  Copyright © 2019 Pallav Trivedi. All rights reserved.
//

import Foundation
import JSQMessagesViewController
import ApiAI

protocol ChatManagerProtocol: class {
    func onNewMessageRecieved(message: JSQMessage)
}

class ChatManager: NSObject {
    static let sharedInstance: ChatManager = {
        let instance = ChatManager()
        // setup code
        return instance
    }()
    
    var delegate: ChatManagerProtocol? = nil
    
    
    func sendMessage(senderId: String, name: String, text: String) {
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        performQuery(senderId: senderId, name: name, text: text)
    }
    
   
    
    
    //MARK: Core Functionality
    func performQuery(senderId:String,name:String,text:String)
    {
        let request = ApiAI.shared().textRequest()
        if text != "" {
            request?.query = text
        } else {
            return
        }
        
        
        request?.setMappedCompletionBlockSuccess({ (request, response) in
            let response = response as! AIResponse
            if response.result.action == "tell.about"
            {
                if let parameters = response.result.parameters as? [String:AIResponseParameter]
                {
                    if let about = parameters["about"]?.stringValue
                    {
                        switch about
                        {
                        case "Kings":
                            print("Kings")
                        case "Heat":
                            print("Heat")
                        default:
                            print("Default")
                        }
                    }
                }
            }
            else if response.result.action == "tell.stats"
            {
                if let parameters = response.result.parameters as? [String:AIResponseParameter]
                {
                    if let stats = parameters["stats"]?.stringValue
                    {
                        switch stats
                        {
                        case "Lead":
                            print("Lead")
                        default:
                            print("Default")
                        }
                    }
                }
            }
            else if response.result.action == "bot.capabilities"
            {
                if let parameters = response.result.parameters as? [String:AIResponseParameter]
                {
                    if let capabilities = parameters["capabilities"]?.stringValue
                    {
                        switch capabilities
                        {
                        case "multimedia":
                            print("multimedia")
                        default:
                            print("Default")
                        }
                    }
                }
            }
            else if response.result.action == "bot.quit"
            {
                if let parameters = response.result.parameters as? [String:AIResponseParameter]
                {
                    if let quit = parameters["quit"]?.stringValue
                    {
                        let deadlineTime = DispatchTime.now() + .seconds(2)
                        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
                            self.minimiseBot()
                        })
                    }
                }
            }
            else
            {
                print("Unknown")
            }
            
            if let textResponse = response.result.fulfillment.speech
            {
                SpeechManager.shared.speak(text: textResponse)
                self.addMessage(withId: "BotId", name: "Bot", text: textResponse)
                self.finishReceivingMessage()
            }
        }, failure: { (request, error) in
            print(error)
        })
        ApiAI.shared().enqueue(request)
    }
    
}
