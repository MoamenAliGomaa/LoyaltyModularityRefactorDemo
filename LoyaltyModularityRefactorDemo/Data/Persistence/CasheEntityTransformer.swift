//
//  CasheEntityTransformer.swift
//  LoyaltyModularityRefactorDemo
//
//  Created by moamen ali gomaa on 27/12/2024.
//

import Foundation
import PersistenceModule
import CoreData

final class CasheEntityTransformer: EntityTransformer {
    typealias DomainType = CashedDomainResponse
    typealias ManagedObjectType = CacheEntity
    
    var managedObjectType: NSManagedObject.Type {
        return CacheEntity.self
    }
    
    public func toStorageEntity(_ entity: CashedDomainResponse?, context: NSManagedObjectContext) -> CacheEntity? {
        guard let managedObj = context.create(CacheEntity.self) as? CacheEntity,
                let entity else {
            return nil
        }
        
        managedObj.key = entity.key
        managedObj.data = entity.data
        managedObj.timestamp = entity.timestamp
        
        return managedObj
    }
    
    func toDomainEntity(_ object: CacheEntity?) -> CashedDomainResponse? {
        guard let object = object else { return nil }
        // Force fire faults if needed
        if object.isFault {
            object.managedObjectContext?.refresh(object, mergeChanges: true)
        }
        
        // Access properties to ensure they're loaded
        guard let key = object.key,
              let timestamp = object.timestamp else {
            return nil
        }
        
        return CashedDomainResponse(
            key: key,
            data: object.data ?? Data(),
            timestamp: timestamp
        )
    }
}
