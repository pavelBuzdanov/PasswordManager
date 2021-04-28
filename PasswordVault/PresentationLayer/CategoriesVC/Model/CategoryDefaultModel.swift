//
//  CategoryDefaultModel.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 19.04.2021.
//

import Foundation

struct CategoryDefaultModel {
    let title: String
    let image: String
    let subtitle: String
}

extension CategoryDefaultModel {
    
    static let defaultModel = [
        CategoryDefaultModel(title: "Accounts", image: "accauntsIcon", subtitle: "Create new account"),
        CategoryDefaultModel(title: "Cards", image: "cardsIcon", subtitle: "Add new card"),
        CategoryDefaultModel(title: "Documents", image: "documentsIcon", subtitle: "Add new document"),
        CategoryDefaultModel(title: "Notes", image: "notesIcon", subtitle: "Add new secure note"),
    ]
}
