//
//  NSManagedObjectContextExtension.swift
//
//
//  Created by moamen ali gomaa on 07/11/2024.
//

import CoreData
import Foundation

extension NSManagedObjectContext {
    func saveAndResetIfNeeded() throws {
        do {
            if hasChanges {
                try save()
                reset()
            }
        } catch {
           throw CoreDataError.saveFailed(error)
        }
    }
    
    func saveIfNeeded() throws {
        do {
            if hasChanges {
               try save()
            }
        } catch {
            throw CoreDataError.saveFailed(error)
        }
    }
    
    public func create(_ model: NSManagedObject.Type) -> NSManagedObject? {
        guard let name = model.fetchRequest().entity?.name,
              let entityDescription =  NSEntityDescription.entity(forEntityName: name, in: self)  else {
            return nil
        }
        
        return NSManagedObject(entity: entityDescription, insertInto: self)
    }
}
