//
//  ContactsPresenterProtocol.swift
//  Contacts
//
//  Created by Daniel Savchak on 28.05.2020.
//  Copyright © 2020 Danylo-Savchak. All rights reserved.
//

import Foundation

protocol ContactsPresenterProtocol: class {
    
    var contactsData: [User] {get set}
    
    func loadContacts()
    
    func simulateChanges()
    
    init(view: ViewProtocol)
}
