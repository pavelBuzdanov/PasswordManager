//
//  AddModel.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 24.04.2021.
//

import Foundation

struct AddModel {
    let title: String
    let subtitle: String
    let imageName: String
}

extension AddModel {
    
    static let defaultModel = [
        AddModel(title: "Account", subtitle: "Add new account", imageName: "accauntsIcon"),
        AddModel(title: "Note", subtitle: "Add new secure note", imageName: "notesIcon"),
        AddModel(title: "Card", subtitle: "Add new card", imageName: "cardsIcon"),
        AddModel(title: "Document", subtitle: "Add new document", imageName: "documentsIcon")
    ]
    
}
