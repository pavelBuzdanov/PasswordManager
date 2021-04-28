//
//  AccountExtension.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 23.04.2021.
//

import Foundation
import CoreData

extension Accounts: SavedData {

    convenience init(isFavourite: Bool, image: String?, title: String?, subtitle: String?, notes: String?, password: String?, url: String?, username: String?, context: NSManagedObjectContext) {
        self.init(context: context)
        self.image = image
        self.id = UUID()
        self.isFavourite = isFavourite
        self.title = title
        self.notes = notes
        self.url = url
        self.subtitle = subtitle
        self.password = password
        self.username = username
    }
    
}
