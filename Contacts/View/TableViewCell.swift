//
//  TableViewCell.swift
//  Contacts
//
//  Created by Daniel Savchak on 30.05.2020.
//  Copyright © 2020 Danylo-Savchak. All rights reserved.
//

import UIKit

class TableViewCell: UITableViewCell {

    private var isOnline: Bool?
    var myImageView =  UIImageView()
    private var myTextLabel =  UILabel()
    var isOnlineView = UIView()
    
    
    override func layoutSubviews() {
        super.layoutSubviews()
        contentView.addSubview(myTextLabel)
        contentView.addSubview(myImageView)
        contentView.addSubview(isOnlineView)
        

        myImageView.translatesAutoresizingMaskIntoConstraints = false
        myImageView.contentMode = .scaleAspectFit
        myTextLabel.translatesAutoresizingMaskIntoConstraints = false
        myImageView.layer.cornerRadius = (myImageView.frame.size.width)/2
        myImageView.clipsToBounds = true
        
        isOnlineView.translatesAutoresizingMaskIntoConstraints = false
        isOnlineView.layer.cornerRadius = (isOnlineView.frame.width)/2
        isOnlineView.clipsToBounds = true
        if isOnline == true {
            isOnlineView.backgroundColor = .green
        }
        
        isOnlineView.trailingAnchor.constraint(equalTo: myImageView.trailingAnchor).isActive = true
        isOnlineView.bottomAnchor.constraint(equalTo: myImageView.bottomAnchor).isActive = true
        isOnlineView.widthAnchor.constraint(equalToConstant: 15).isActive = true
        isOnlineView.heightAnchor.constraint(equalToConstant: 15).isActive = true
        myImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor).isActive = true
        myImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
        myTextLabel.leadingAnchor.constraint(equalTo: myImageView.trailingAnchor, constant: 20).isActive = true
        myTextLabel.centerYAnchor.constraint(equalTo: contentView.centerYAnchor).isActive = true
    }

    
    func setData(isOnline: Bool, text: String, photo: UIImage) {
        self.isOnline = isOnline
        self.myImageView.image = photo
        self.myTextLabel.text = text
        
        myImageView.frame = CGRect(x: .zero, y: .zero, width: photo.size.width, height: photo.size.height)
        isOnlineView.frame = CGRect(x: .zero, y: .zero, width: 15, height: 15)
        
    }
}
