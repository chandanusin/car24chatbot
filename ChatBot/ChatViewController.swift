//
//  ChatViewController.swift
//  NBA Bot
//
//  Created by Pallav Trivedi on 07/02/18.
//  Copyright © 2018 Pallav Trivedi. All rights reserved.
//

import ApiAI
import JSQMessagesViewController
import UIKit
import Speech

enum ChatWindowStatus
{
    case minimised
    case maximised
}

class ChatViewController: JSQMessagesViewController {
    
    
    @IBOutlet var activityIndicator: UIActivityIndicatorView!
    var messages = [JSQMessage]()
    lazy var outgoingBubbleImageView: JSQMessagesBubbleImage = self.setupOutgoingBubble()
    lazy var incomingBubbleImageView: JSQMessagesBubbleImage = self.setupIncomingBubble()
    lazy var speechSynthesizer = AVSpeechSynthesizer()
    lazy var botImageView = UIImageView()
    
    var chatWindowStatus : ChatWindowStatus = .maximised
    var botImageTapGesture: UITapGestureRecognizer?
    var indicator: UIActivityIndicatorView!
    //MARK: Lifecycle Methods
    override func viewDidLoad()
    {
        super.viewDidLoad()
        self.senderId = LoginManager.sharedInstance.getUserId()
        self.senderDisplayName = LoginManager.sharedInstance.getUserName()
        
        SpeechManager.shared.delegate = self
        let swipeGesture = UIPanGestureRecognizer(target: self, action: #selector(handleSwipe(gesture:)))
        self.view.addGestureRecognizer(swipeGesture)
        self.addMicButton()
        
        // No avatars
        collectionView!.collectionViewLayout.incomingAvatarViewSize = CGSize.zero
        collectionView!.collectionViewLayout.outgoingAvatarViewSize = CGSize.zero
        
        let deadlineTime = DispatchTime.now() + .seconds(2)
        DispatchQueue.main.asyncAfter(deadline: deadlineTime, execute: {
            self.populateWithWelcomeMessage()
        })
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let view = ChatViewController.getTopViewController()?.view {
            let activityView = UIActivityIndicatorView(activityIndicatorStyle: .gray)
            activityView.center = view.center
            indicator = activityView
            indicator.isHidden = true
            view.addSubview(activityView)
        }
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //MARK: Helper Methods
    func addMicButton()
    {
        let height = self.inputToolbar.contentView.leftBarButtonContainerView.frame.size.height
        let micButton = UIButton(type: .custom)
        micButton.setImage(#imageLiteral(resourceName: "microphone"), for: .normal)
        micButton.frame = CGRect(x: 0, y: 0, width: 25, height: height)
        
        self.inputToolbar.contentView.leftBarButtonItemWidth = 25
        self.inputToolbar.contentView.leftBarButtonContainerView.addSubview(micButton)
        self.inputToolbar.contentView.leftBarButtonItem.isHidden = true
        
        let longPressGesture = UILongPressGestureRecognizer(target: self, action: #selector(handleLongPressOfMic(gesture:)))
        micButton.addGestureRecognizer(longPressGesture)
    }
    
    func populateWithWelcomeMessage()
    {
        self.addMessage(withId: "BotId", name: "Bot", text: "Hi I am Car24x7")
        self.finishReceivingMessage()
        self.addMessage(withId: "BotId", name: "Bot", text: "I am here to help you about anything related to buy and sell your car")
        self.finishReceivingMessage()
        self.addMessage(withId: "BotId", name: "Bot", text: "At any moment you feel that I am troubling you, you can ask me sit quiet or swipe on the screen")
        self.finishReceivingMessage()
    }
    
    private func addMessage(withId id: String, name: String, text: String) {
        if let message = JSQMessage(senderId: id, displayName: name, text: text) {
            messages.append(message)
        }
    }
    
    func minimiseBot()
    {
        if chatWindowStatus == .maximised
        {
            self.inputToolbar.contentView.textView.resignFirstResponder()
            UIView.animate(withDuration: 0.5, animations: {
                let rect = CGRect(x: 300, y: 50, width: 70, height: 70)
                self.view.frame = rect
                self.view.clipsToBounds = true
                self.view.layer.cornerRadius = 35
            }, completion: { (completed) in
                self.inputToolbar.isUserInteractionEnabled = false
                self.botImageView.frame = CGRect(x: 0, y: 0, width: 70, height: 70)
                self.botImageView.image = #imageLiteral(resourceName: "BotImage")
                self.botImageView.clipsToBounds = true
                self.botImageView.layer.cornerRadius = 35
                self.view.addSubview(self.botImageView)
                self.chatWindowStatus = .minimised
                self.botImageTapGesture = UITapGestureRecognizer(target: self, action: #selector(self.handleTap(gesture:)))
                self.view.addGestureRecognizer(self.botImageTapGesture!)
            })
        }
    }
    
    override var preferredStatusBarStyle: UIStatusBarStyle {
        return .default
    }
    
    //MARK: Gesture Handler Methods
    @objc func handleLongPressOfMic(gesture:UILongPressGestureRecognizer)
    {
        if gesture.state == .began
        {
            SpeechManager.shared.startRecording()
        }
        else if gesture.state == .ended
        {
            SpeechManager.shared.stopRecording()
            if inputToolbar.contentView.textView.text == "Say something, I'm listening!"
            {
                inputToolbar.contentView.textView.text = ""
            }
        }
    }
    
    
    @objc func handleSwipe(gesture: UISwipeGestureRecognizer)
    {
        minimiseBot()
    }
    
    @objc func handleTap(gesture: UITapGestureRecognizer)
    {
        if chatWindowStatus == .minimised
        {
            botImageView.removeFromSuperview()
            UIView.animate(withDuration: 0.5, animations: {
                let rect = CGRect(x: 0, y: 0, width: UIScreen.main.bounds.width, height: UIScreen.main.bounds.height)
                self.view.frame = rect
                self.view.clipsToBounds = true
                self.view.layer.cornerRadius = 0
                self.chatWindowStatus = .maximised
            }, completion: { (completed) in
                self.inputToolbar.isUserInteractionEnabled = true
                self.view.removeGestureRecognizer(self.botImageTapGesture!)
            })
        }
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
            
            if  response.result.actionIncomplete == 0 {
                if response.result.metadata.intentName == "Buy"{
                    if let parameters = response.result.parameters as? [String:AIResponseParameter] {
                        let buyerDetails = BuyerDetails()
                        var engineType: engineType = .engineTypePetrol;
                        if  parameters["engineType"]!.stringValue == "diesel" {
                            engineType = .engineTypeDiesel
                        } else if parameters["engineType"]!.stringValue == "petrol"  {
                            engineType = .engineTypePetrol
                        } else  {
                            engineType = .engineTypeElectric
                        }
                        buyerDetails.engineType = engineType
                        buyerDetails.kilometres = parameters["kmsDrive"]!.numberValue as! Int
                        buyerDetails.targetPrice = parameters["budget"]!.numberValue as! Int
                        buyerDetails.vehicleModel = parameters["model"]!.stringValue
                        buyerDetails.brand = parameters["brand"]!.stringValue
                        buyerDetails.ownership = parameters["ownership"]!.stringValue
                        buyerDetails.carType = parameters["carType"]!.stringValue
                        self.indicator.isHidden = false
                        self.indicator.startAnimating()
                        TransactionManager.sharedInstance.getListOfCarDetailsWithBuyerDetails(details: buyerDetails, completion: { (list, error) in
                            self.indicator.stopAnimating()
                            self.indicator.isHidden = true
                            let chatVc = UIStoryboard(name: "Views", bundle: nil).instantiateViewController(withIdentifier: kViewStoryboardID) as? ResponseViewController
                            
                            UIView.animate(withDuration: 0.5) {
                                chatVc?.view.frame = CGRect(x: self.view.frame.origin.x, y: 20, width: self.view.frame.size.width, height: self.view.frame.size.height - 20)
                                self.view.addSubview((chatVc?.view)!)
                                self.addChildViewController(chatVc!)
                                self.didMove(toParentViewController: chatVc)
                                chatVc?.setModelData(list)
                            }
                        })
                    }
                }
            }
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
    
    //MARK: JSQMessageViewController Methods
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageDataForItemAt indexPath: IndexPath!) -> JSQMessageData! {
        return messages[indexPath.item]
    }
    
    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return messages.count
    }
    
    private func setupOutgoingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.outgoingMessagesBubbleImage(with: UIColor.jsq_messageBubbleBlue())
    }
    
    private func setupIncomingBubble() -> JSQMessagesBubbleImage {
        let bubbleImageFactory = JSQMessagesBubbleImageFactory()
        return bubbleImageFactory!.incomingMessagesBubbleImage(with: UIColor.jsq_messageBubbleLightGray())
    }
    
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, messageBubbleImageDataForItemAt indexPath: IndexPath!) -> JSQMessageBubbleImageDataSource! {
        let message = messages[indexPath.item] // 1
        if message.senderId == senderId { // 2
            return outgoingBubbleImageView
        } else { // 3
            return incomingBubbleImageView
        }
    }
    
    //removing avatars
    override func collectionView(_ collectionView: JSQMessagesCollectionView!, avatarImageDataForItemAt indexPath: IndexPath!) -> JSQMessageAvatarImageDataSource! {
        return nil
    }
    
    override func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = super.collectionView(collectionView, cellForItemAt: indexPath) as! JSQMessagesCollectionViewCell
        let message = messages[indexPath.item]
        
        if message.senderId == senderId {
            cell.textView?.textColor = UIColor.white
        } else {
            cell.textView?.textColor = UIColor.black
        }
        return cell
    }
    
    override func didPressSend(_ button: UIButton!, withMessageText text: String!, senderId: String!, senderDisplayName: String!, date: Date!) {
        
        addMessage(withId: senderId, name: senderDisplayName!, text: text!)
        JSQSystemSoundPlayer.jsq_playMessageSentSound()
        
        finishSendingMessage()
        performQuery(senderId: senderId, name: senderDisplayName, text: text!)
        
    }
    
    override func didPressAccessoryButton(_ sender: UIButton)
    {
        performQuery(senderId: senderId, name: senderDisplayName, text: "Multimedia")
        
    }
}
extension ChatViewController:SpeechManagerDelegate
{
    func didStartedListening(status:Bool)
    {
        if status
        {
            self.inputToolbar.contentView.textView.text = "Say something, I'm listening!"
        }
    }
    
    func didReceiveText(text: String)
    {
        self.inputToolbar.contentView.textView.text = text
        
        if text != "Say something, I'm listening!"
        {
            self.inputToolbar.contentView.rightBarButtonItem.isEnabled = true
        }
    }
    
    
    func onNewMessageRecieved(message: JSQMessage) {
        
        
    }
    
    class func getTopViewController() -> UIViewController? {
        var topViewController:UIViewController? = nil;
        if var topController = UIApplication.shared.keyWindow?.rootViewController {
            topViewController = topController;
            while let presentedViewController = topController.presentedViewController {
                topController = presentedViewController;
                topViewController = topController;
            }
        }
        return topViewController;
    }
}
