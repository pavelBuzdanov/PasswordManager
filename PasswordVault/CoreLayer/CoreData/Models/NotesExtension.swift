//
//  NotesExtension.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 24.04.2021.
//

import Foundation
import CoreData

extension Notes: SavedData {

    convenience init(isFavourite: Bool, image: String?, title: String?, subtitle: String?, text: String?,context: NSManagedObjectContext) {
        self.init(context: context)
        self.id = UUID()
        self.image = image
        self.isFavourite = isFavourite
        self.subtitle = subtitle
        self.title = title
        self.text = text
    }
}
