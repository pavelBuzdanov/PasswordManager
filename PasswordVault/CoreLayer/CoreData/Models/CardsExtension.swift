//
//  CardsExtension.swift
//  PasswordVault
//
//  Created by Pavel Buzdanov on 24.04.2021.
//

import CoreData

extension Cards: SavedData {

    convenience init(isFavourite: Bool, image: String?, title: String?, subtitle: String?, note: String?, pin: String?, date: String?,
                     holderName: String?, cardType: String?,cvv: String?, cardNumber: String?, context: NSManagedObjectContext) {
        
        self.init(context: context)
        self.id = UUID()
        self.isFavourite = isFavourite
        self.image = image
        self.title = title
        self.subtitle = subtitle
        self.note = note
        self.pin = pin
        self.holderName = holderName
        self.date = date
        self.cvv = cvv
        self.cardType = cardType
        self.cardNumber = cardNumber
    }
    
}
