//
//  SavedData.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 25.04.2021.
//

import Foundation

protocol SavedData {
    
    var isFavourite: Bool { get }
    var image: String? { get }
    var title: String? { get }
    var subtitle: String?  { get }
    
}
