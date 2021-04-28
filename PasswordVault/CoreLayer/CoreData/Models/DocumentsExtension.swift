//
//  DocumentsExtension.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 24.04.2021.
//

import Foundation
import CoreData


extension Documents: SavedData {

    convenience init(isFavourite: Bool, image: String?, title: String?, subtitle: String?, note: String?, phone: String?,
                     firstName: String?, lastName: String?, job: String?, birthday: String?, adress: String?, context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.id = UUID()
        self.isFavourite = isFavourite
        self.title = title
        self.image = image
        self.subtitle = subtitle
        self.note = note
        self.phone = phone
        self.lastName = lastName
        self.firstName = firstName
        self.email = email
        self.job = job
        self.adress = adress
        self.birthday = birthday
    }
    
}
