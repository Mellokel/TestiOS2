//
//  TimeManager.swift
//  iOSTest2
//
//  Created by Admin on 30.07.18.
//  Copyright © 2018 Admin. All rights reserved.
//

import UIKit

class ListTimeManager {
    
    func getComponentFrom(timeInterval interval: TimeInterval, component: Calendar.Component) -> Int {
        return NSCalendar.current.component(component, from: Date(timeIntervalSince1970: interval))
    }
    
    func getTime(timeIntervalFrom from: TimeInterval, timeIntervalTo to: TimeInterval) -> String {
        let hFrom = getComponentFrom(timeInterval: from, component: .hour)
        let mFrom = getComponentFrom(timeInterval: from, component: .minute)
        
        let hTo = getComponentFrom(timeInterval: to, component: .hour)
        let mTo = getComponentFrom(timeInterval: to, component: .minute)
        
        return "\(hFrom):m\(mFrom) - \(hTo):m\(mTo) "
    }
}
