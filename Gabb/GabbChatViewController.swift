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
    
    var dataSource:GabbChatDataSource!
    var chatInputPresenter:ChatInputBarPresenter!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        chatDataSource = dataSource
    }
    
//    override func createPresenterBuilders() -> [ChatItemType : [ChatItemPresenterBuilderProtocol]] {
//
//        
//        return [
//            "Text Message": [
//                TextMessagePresenterBuilder(
//                    viewModelBuilder: TextMessageViewModelDefaultBuilder(),
//                    interactionHandler: nil
//                )   
//            ]
//        ]
//        
//    }

    
    override func createChatInputView() -> UIView {
        return ChattoAdditions.ChatInputBar()
    }

}

