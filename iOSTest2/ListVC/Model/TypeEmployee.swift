//
//  TypeEmployee.swift
//  iOSTest2
//
//  Created by Admin on 30.07.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import Foundation

class TypeEmployeeManager {
    enum TypeEmployee: String {
        case Accountant = "Accountant"
        case Manager = "Manager"
        case Worker = "Worker"
        
    }
    
    func getTypesAsArray() -> [TypeEmployee] {
        return [.Accountant, .Manager, .Worker]
    }
    
    func getTypeFor(rawValue: String) -> TypeEmployee? {
        guard let type = TypeEmployee(rawValue: rawValue) else { return nil}
        switch type {
        case .Accountant:
            return .Accountant
        case .Manager:
            return .Manager
        case .Worker:
            return .Worker
        }
    }
}

