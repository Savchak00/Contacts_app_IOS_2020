//
//  CollectionViewCell.swift
//  Contacts
//
//  Created by Daniel Savchak on 30.05.2020.
//  Copyright © 2020 Danylo-Savchak. All rights reserved.
//

import UIKit

class CollectionViewCell: UICollectionViewCell {
    var avatar = UIImageView()
    var isOnlineView = UIView()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        avatar.contentMode = .scaleAspectFill
        avatar.frame = bounds
        avatar.layer.cornerRadius = avatar.frame.size.width/2
        avatar.clipsToBounds = true
        contentView.addSubview(avatar)
        
        isOnlineView.frame = CGRect(x: .zero, y: .zero, width: 15, height: 15)
        isOnlineView.translatesAutoresizingMaskIntoConstraints = false
        isOnlineView.layer.cornerRadius = (isOnlineView.frame.width)/2
        isOnlineView.clipsToBounds = true
        contentView.addSubview(isOnlineView)
        
        isOnlineView.trailingAnchor.constraint(equalTo: avatar.trailingAnchor).isActive = true
        isOnlineView.bottomAnchor.constraint(equalTo: avatar.bottomAnchor).isActive = true
        isOnlineView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        isOnlineView.heightAnchor.constraint(equalToConstant: 15).isActive = true
    }
    
    func setPhoto(image: UIImage,isOnline: Bool) {
        self.avatar.image = image
        if isOnline {
            isOnlineView.backgroundColor = .green
        }
    }
}
