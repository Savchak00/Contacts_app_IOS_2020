//
//  Builder.swift
//  Contacts
//
//  Created by Daniel Savchak on 31.05.2020.
//  Copyright © 2020 Danylo-Savchak. All rights reserved.
//

import UIKit


class Builder {
    static func createMain() -> UIViewController {
        let view = MainViewController()
        let presenter = ContactsPresenter(view: view)
        view.presenter = presenter
        return view
     }
}
