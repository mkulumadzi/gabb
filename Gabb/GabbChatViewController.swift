//
//  GabbChatViewController.swift
//  Gabb
//
//  Created by Evan Waters on 4/10/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import UIKit
import Chatto
import ChattoAdditions
import SwiftyJSON

class GabbChatViewController: ChatViewController {
    
    var navBarBackgroundImage:UIImage?
    var navBarShadowImage:UIImage?
    
    var messageSender: GabbChatSender!
    
    var dataSource: GabbChatDataSource! {
        didSet {
            self.chatDataSource = self.dataSource
        }
    }
    
    lazy private var baseMessageHandler: BaseMessageHandler = {
        return BaseMessageHandler(messageSender: self.messageSender)
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        super.chatItemsDecorator = ChatItemsDecorator()
        
        NSNotificationCenter.defaultCenter().addObserver(self, selector: #selector(GabbChatViewController.notificationReceived), name: "ReceivedNotification", object: nil)
        
        navigationController?.navigationBar.titleTextAttributes = [NSFontAttributeName : UIFont.systemFontOfSize(20.0), NSForegroundColorAttributeName : UIColor.gabbRedColor()]
        navBarBackgroundImage = navigationController?.navigationBar.backgroundImageForBarMetrics(.Default)
        navBarShadowImage = navigationController?.navigationBar.shadowImage
        
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        navigationController?.navigationBar.tintColor = UIColor.gabbRedColor()
        navigationController?.navigationBar.barTintColor = UIColor.whiteColor()
        
        navigationController?.navigationBar.translucent = false
        if let backgroundImage = navBarBackgroundImage {
            navigationController?.navigationBar.setBackgroundImage(backgroundImage, forBarMetrics: .Default)
        }
        if let shadowImage = navBarShadowImage {
            navigationController?.navigationBar.shadowImage = shadowImage
        }
        
    }
    
    var chatInputPresenter: ChatInputBarPresenter!
    override func createChatInputView() -> UIView {
        let chatInputView = ChatInputBar.loadNib()
        self.configureChatInputBar(chatInputView)
        self.chatInputPresenter = ChatInputBarPresenter(chatInputView: chatInputView, chatInputItems: self.createChatInputItems())
        return chatInputView
    }
    
    func configureChatInputBar(chatInputBar: ChatInputBar) {
        var appearance = ChatInputBarAppearance()
        appearance.sendButtonTitle = NSLocalizedString("Send", comment: "")
        appearance.textPlaceholder = NSLocalizedString("Type a message", comment: "")
        chatInputBar.setAppearance(appearance)
    }
    
    override func createPresenterBuilders() -> [ChatItemType: [ChatItemPresenterBuilderProtocol]] {
        return [
            FromNameModel.chatItemType: [FromNamePresenterBuilder()],
            TextMessageModel.chatItemType: [
                TextMessagePresenterBuilder(
                    viewModelBuilder: TextMessageViewModelDefaultBuilder(),
                    interactionHandler: TextMessageHandler(baseHandler: self.baseMessageHandler)
                )
            ],
            SendingStatusModel.chatItemType: [SendingStatusPresenterBuilder()]
        ]
    }
    
    func createChatInputItems() -> [ChatInputItemProtocol] {
        var items = [ChatInputItemProtocol]()
        items.append(self.createTextInputItem())
        return items
    }
    
    func notificationReceived(localNotification: NSNotification) {
        print(localNotification.userInfo)
        if let userInfo = localNotification.userInfo {
            let notification = JSON(userInfo)
            let podcast = JSON(dataSource.podcast)
            if notification["podcast_id"].intValue == podcast["podcast_id"].intValue {
                getNotificationAndUpdateView(notification["uri"].stringValue)
            }
        }
    }
    
    func getNotificationAndUpdateView(uri: String?) {
        guard let uri = uri else {
            return
        }
        ChatService.getChat(uri, completion: { (error, result) -> Void in
            if let error = error {
                print (error)
            } else if let chat = result as? NSDictionary {
                self.dataSource.addIncomingMessage(chat)
            } else {
                print("Unexpected result: \(result)")
            }
        })
    }
    
    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }

}

