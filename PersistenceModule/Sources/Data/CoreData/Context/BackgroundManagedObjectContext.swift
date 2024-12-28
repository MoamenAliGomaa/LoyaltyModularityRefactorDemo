//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 07/11/2024.
//

import CoreData
import Foundation

final class BackgroundManagedObjectContext {
    var context: NSManagedObjectContext?
    
    init(_ container: NSPersistentContainer, _ setup: (NSManagedObjectContext)->Void) {
        self.context = container.newBackgroundContext()
    }
    
    deinit {
        context.map {
            context = nil
            $0.performAndWait {}
        }
    }
}
