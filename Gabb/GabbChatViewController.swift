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

class GabbChatViewController: ChatViewController {
    
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
    
    private func createTextInputItem() -> TextChatInputItem {
        let item = TextChatInputItem()
        item.textInputHandler = { [weak self] text in
            self?.dataSource.addTextMessage(text)
        }
        return item
    }

}

