//
//  File.swift
//  
//
//  Created by moamen ali gomaa on 10/12/2024.
//

import Foundation

public struct QueryPredicate {
    public enum Operator {
        case equals
        case notEquals
        case greaterThan
        case lessThan
        case contains
        case beginsWith
        case endsWith
        case `in`
        case between
        case and
        case or
    }
    
    let field: String
    let operation: Operator
    let value: Any
    let additionalValue: Any?
    
    public init(
        field: String,
        operation: Operator,
        value: Any,
        additionalValue: Any? = nil
    ) {
        self.field = field
        self.operation = operation
        self.value = value
        self.additionalValue = additionalValue
    }
}

// Extension to convert to NSPredicate
extension QueryPredicate {
    func toNSPredicate() -> NSPredicate? {
        switch operation {
        case .equals:
            guard let value = value as? CVarArg else {
                return nil
            }
            return NSPredicate(format: "%K == %@", field, value)
            
        case .notEquals:
            guard let value = value as? CVarArg else {
                return nil
            }
            return NSPredicate(format: "%K != %@", field, value)
            
        case .greaterThan:
            if let dateValue = value as? Date {
                return NSPredicate(format: "%K > %@", field, dateValue as NSDate)
            }
            
            guard let value = value as? CVarArg else {
                return nil
            }
            return NSPredicate(format: "%K > %@", field, value)
            
        case .lessThan:
            if let dateValue = value as? Date {
                return NSPredicate(format: "%K < %@", field, dateValue as NSDate)
            }
            
            guard let value = value as? CVarArg else {
                return nil
            }
            
            return NSPredicate(format: "%K < %@", field, value)
            
        case .contains:
            guard let value = value as? CVarArg else {
                return nil
            }
            return NSPredicate(format: "%K CONTAINS[cd] %@", field, value)
            
        case .beginsWith:
            guard let value = value as? CVarArg else {
                return nil
            }
            return NSPredicate(format: "%K BEGINSWITH[cd] %@", field, value)
            
        case .endsWith:
            guard let value = value as? CVarArg else {
                return nil
            }
            return NSPredicate(format: "%K ENDSWITH[cd] %@", field, value)
            
        case .in:
            guard let array = value as? [Any] else {
                return NSPredicate(value: false)
            }
            return NSPredicate(format: "%K IN %@", field, array as CVarArg)
            
        case .between:
            guard let additionalValue = additionalValue else {
                return NSPredicate(value: false)
            }
            return NSPredicate(
                format: "%K BETWEEN {%@, %@}",
                field,
                value as! CVarArg,
                additionalValue as! CVarArg
            )
            
        case .and:
            guard let predicates = value as? [QueryPredicate] else {
                return NSPredicate(value: false)
            }
            let nspredicates = predicates.compactMap { $0.toNSPredicate() }
            return NSCompoundPredicate(andPredicateWithSubpredicates: nspredicates)
            
        case .or:
            guard let predicates = value as? [QueryPredicate] else {
                return NSPredicate(value: false)
            }
            let nspredicates = predicates.compactMap { $0.toNSPredicate() }
            return NSCompoundPredicate(orPredicateWithSubpredicates: nspredicates)
        }
    }
}

public struct QuerySort {
    public enum Direction {
        case ascending
        case descending
        
        var isAscending: Bool {
            self == .ascending
        }
    }
    
    let field: String
    let direction: Direction
    let caseInsensitive: Bool
    
    public init(
        field: String,
        direction: Direction = .ascending,
        caseInsensitive: Bool = true
    ) {
        self.field = field
        self.direction = direction
        self.caseInsensitive = caseInsensitive
    }
    
    func toNSSortDescriptor() -> NSSortDescriptor {
        if caseInsensitive {
            return NSSortDescriptor(
                key: field,
                ascending: direction.isAscending,
                selector: #selector(NSString.caseInsensitiveCompare(_:))
            )
        } else {
            return NSSortDescriptor(
                key: field,
                ascending: direction.isAscending
            )
        }
    }
}
