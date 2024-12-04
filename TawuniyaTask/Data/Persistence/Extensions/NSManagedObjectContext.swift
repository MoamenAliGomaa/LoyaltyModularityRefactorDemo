//
//  NSManagedObjectContext.swift
//  TawuniyaTask
//
//  Created by moamen ali gomaa on 03/12/2024.
//

import Foundation
import CoreData

extension NSManagedObjectContext {
    func saveAndResetIfNeeded() throws {
        do {
            if hasChanges {
                try save()
                reset()
            }
        } catch {
           throw CoreDataError.saveFailed
        }
    }
    
    func saveIfNeeded() throws {
        do {
            if hasChanges {
               try save()
            }
        } catch {
            throw CoreDataError.saveFailed
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
