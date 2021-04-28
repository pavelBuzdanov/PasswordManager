
import Foundation
import CoreData

extension Category {
    
    convenience init(title: String, image: String, context: NSManagedObjectContext) {
        self.init(context: context)
        self.title = title
        self.image = image
    }
    
    var count: Int? {
        if self.account?.count != 0 {
            return self.account?.count
        }
        
        if self.notes?.count != 0 {
            return self.notes?.count
        }
        
        if self.cards?.count != 0 {
            return self.cards?.count
        }
        
        if self.documents?.count != 0 {
            return self.documents?.count
        }

        
        return 0
    }
    
}
