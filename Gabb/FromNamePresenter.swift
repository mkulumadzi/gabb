//
//  FromNamePresenter.swift
//  Gabb
//
//  Created by Evan Waters on 4/29/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import UIKit
import Chatto
import ChattoAdditions

class FromNameModel: ChatItemProtocol {
    let uid: String
    static var chatItemType: ChatItemType {
        return "decoration-Name"
    }
    
    var type: String { return FromNameModel.chatItemType }
    let fromPerson: GabbUser
    
    init (uid: String, fromPerson: GabbUser) {
        self.uid = uid
        self.fromPerson = fromPerson
    }
}

public class FromNamePresenterBuilder: ChatItemPresenterBuilderProtocol {
    
    public func canHandleChatItem(chatItem: ChatItemProtocol) -> Bool {
        return chatItem is FromNameModel ? true : false
    }
    
    public func createPresenterWithChatItem(chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        assert(self.canHandleChatItem(chatItem))
        return FromNamePresenter(
            fromNameModel: chatItem as! FromNameModel
        )
    }
    
    public var presenterType: ChatItemPresenterProtocol.Type {
        return FromNamePresenter.self
    }
}

class FromNamePresenter: ChatItemPresenterProtocol {
    
    let fromNameModel: FromNameModel
    init (fromNameModel: FromNameModel) {
        self.fromNameModel = fromNameModel
    }
    
    static func registerCells(collectionView: UICollectionView) {
        collectionView.registerNib(UINib(nibName: "FromNameCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FromNameCollectionViewCell")
    }
    
    func dequeueCell(collectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FromNameCollectionViewCell", forIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let fromNameCell = cell as? FromNameCollectionViewCell else {
            assert(false, "expecting from Name cell")
            return
        }
        
        let attrs = [
            NSFontAttributeName : UIFont.systemFontOfSize(10.0),
            NSForegroundColorAttributeName: UIColor.gabbDarkGreyColor()
        ]
        fromNameCell.text = NSAttributedString(
            string: self.fromNameModel.fromPerson.fullName(),
            attributes: attrs)
    }
    
    var canCalculateHeightInBackground: Bool {
        return true
    }
    
    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        return 19
    }
}