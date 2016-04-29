//
//  FromAvatarPresenter.swift
//  Gabb
//
//  Created by Evan Waters on 4/29/16.
//  Copyright © 2016 Evan Waters. All rights reserved.
//

import Foundation
import UIKit
import Chatto
import ChattoAdditions

class FromAvatarModel: ChatItemProtocol {
    let uid: String
    static var chatItemType: ChatItemType {
        return "decoration-avatar"
    }
    
    var type: String { return FromAvatarModel.chatItemType }
    let from: GabbUser
    
    init (uid: String, from: GabbUser) {
        self.uid = uid
        self.from = from
    }
}

public class FromAvatarPresenterBuilder: ChatItemPresenterBuilderProtocol {
    
    public func canHandleChatItem(chatItem: ChatItemProtocol) -> Bool {
        return chatItem is FromAvatarModel ? true : false
    }
    
    public func createPresenterWithChatItem(chatItem: ChatItemProtocol) -> ChatItemPresenterProtocol {
        assert(self.canHandleChatItem(chatItem))
        return FromAvatarPresenter(
            fromAvatarModel: chatItem as! FromAvatarModel
        )
    }
    
    public var presenterType: ChatItemPresenterProtocol.Type {
        return FromAvatarPresenter.self
    }
}

class FromAvatarPresenter: ChatItemPresenterProtocol {
    
    let fromAvatarModel: FromAvatarModel
    init (fromAvatarModel: FromAvatarModel) {
        self.fromAvatarModel = fromAvatarModel
    }
    
    static func registerCells(collectionView: UICollectionView) {
        collectionView.registerNib(UINib(nibName: "FromAvatarCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "FromAvatarCollectionViewCell")
    }
    
    func dequeueCell(collectionView collectionView: UICollectionView, indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier("FromAvatarCollectionViewCell", forIndexPath: indexPath)
        return cell
    }
    
    func configureCell(cell: UICollectionViewCell, decorationAttributes: ChatItemDecorationAttributesProtocol?) {
        guard let fromAvatarCell = cell as? FromAvatarCollectionViewCell else {
            assert(false, "expecting from avatar cell")
            return
        }
        
        let attrs = [
            NSFontAttributeName : UIFont.systemFontOfSize(12.0),
            NSForegroundColorAttributeName: UIColor.blackColor()
        ]
        fromAvatarCell.text = NSAttributedString(
            string: "EW",
            attributes: attrs)
    }
    
    var canCalculateHeightInBackground: Bool {
        return true
    }
    
    func heightForCell(maximumWidth width: CGFloat, decorationAttributes: ChatItemDecorationAttributesProtocol?) -> CGFloat {
        return 19
    }
}