//
//  NetworkService.swift
//  Contacts
//
//  Created by Daniel Savchak on 29.05.2020.
//  Copyright © 2020 Danylo-Savchak. All rights reserved.
//

import Foundation
import Alamofire
import AlamofireImage

class NetworkService {
    static let shared = NetworkService()
    private init() {}
    
    func getImage(hex: String, result: @escaping ((UIImage?) -> ())) {
        AF.request("https://www.gravatar.com/avatar/\(hex)").responseImage {
            response in
            if case .success(let image) = response.result {
                result(image)
            }
        }
    }
}
