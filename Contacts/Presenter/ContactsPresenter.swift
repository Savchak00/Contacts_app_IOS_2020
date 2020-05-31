//
//  Presenter.swift
//  Contacts
//
//  Created by Daniel Savchak on 28.05.2020.
//  Copyright © 2020 Danylo-Savchak. All rights reserved.
//

import Foundation
import var CommonCrypto.CC_MD5_DIGEST_LENGTH
import func CommonCrypto.CC_MD5
import typealias CommonCrypto.CC_LONG
import Alamofire
import AlamofireImage

class ContactsPresenter: ContactsPresenterProtocol {
    
    
    
    var controller:  ViewProtocol
    var contactsData = Users(users: []).users
    
    required init(view: ViewProtocol) {
        self.controller = view
    }
    
    func loadContacts() {
        let dispatchGroup = DispatchGroup()
        let randomCount = Int.random(in: 5...20)
        for _ in 0...randomCount {
            let randomNameIndex = Int.random(in: 0..<10)
            let name = names[randomNameIndex]
            let randomMailIndex = Int.random(in: 0..<5)
            let email = emails[randomMailIndex]
            let isOnline:Bool = {
                let rand = Int.random(in: 0...1)
                if rand == 0 {
                    return false
                } else {
                    return true
                }
            }()
            let md5Data = MD5(string: email)
            let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
            var image1 = UIImage()
            dispatchGroup.enter()
            NetworkService.shared.getImage(hex: md5Hex, result: {
                image1 = $0!
                self.contactsData += [User(name: name, isOnline: isOnline, email: email,hex: md5Hex, photo: image1)]
                dispatchGroup.leave()
            })
        }
        dispatchGroup.notify(queue: .main) {
            self.controller.loadContacts()
        }
    }
    
    func simulateChanges() {
        var array = contactsData
        // firstly - delete users
        let randomNumberOfDeletedUsers = Int.random(in: 1...array.count)
        for _ in 1...randomNumberOfDeletedUsers {
            let randomUserIndex = Int.random(in: 0..<array.count)
            array.remove(at: randomUserIndex)
        }
        // secondary - make changes
        if array.count != 0 {
            let numberOfUserForChanges = Int.random(in: 0..<array.count)
            let dispatchGroup = DispatchGroup()
            for index in 0..<numberOfUserForChanges {
                let n = Int.random(in: 0...2)
                if n == 0 {
                    array[index].isOnline = !array[index].isOnline
                } else if n == 1 {
                    let randomNameIndex = Int.random(in: 0..<10)
                    let name = names[randomNameIndex]
                    array[index].name = name
                } else if n == 2 {
                    let randomMailIndex = Int.random(in: 0..<5)
                    let email = emails[randomMailIndex]
                    if array[index].email != email {
                        array[index].email = email
                        let md5Data = MD5(string: email)
                        let md5Hex =  md5Data.map { String(format: "%02hhx", $0) }.joined()
                        dispatchGroup.enter()
                        NetworkService.shared.getImage(hex: md5Hex) { (image) in
                            array[index].photo = image!
                            dispatchGroup.leave()
                        }
                    }
                }
            }
        }
        self.contactsData = array
        // thirdly lets create users
        loadContacts()
    }
    
    //MARK:  - getting hash by mail

    func MD5(string: String) -> Data {
            let length = Int(CC_MD5_DIGEST_LENGTH)
            let messageData = string.data(using:.utf8)!
            var digestData = Data(count: length)

            _ = digestData.withUnsafeMutableBytes { digestBytes -> UInt8 in
                messageData.withUnsafeBytes { messageBytes -> UInt8 in
                    if let messageBytesBaseAddress = messageBytes.baseAddress, let digestBytesBlindMemory = digestBytes.bindMemory(to: UInt8.self).baseAddress {
                        let messageLength = CC_LONG(messageData.count)
                        CC_MD5(messageBytesBaseAddress, messageLength, digestBytesBlindMemory)
                    }
                    return 0
                }
            }
            return digestData
    }
}
