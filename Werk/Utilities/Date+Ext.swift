//
//  Date+Ext.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/12/22.
//

import Foundation
//
extension Date {
    static func randomDateThisYear() -> Date {
        var dateComponent = DateComponents()
        dateComponent.calendar = Calendar.current
        dateComponent.month = 1
        dateComponent.day = 1
        dateComponent.year = Calendar.current.component(.year, from: Date())
        
        
        var enddateComponent = DateComponents()
        enddateComponent.calendar = Calendar.current
        enddateComponent.month = 12
        enddateComponent.day = 31
        enddateComponent.year = Calendar.current.component(.year, from: Date())
        
        guard let startDate = dateComponent.date, let endDate = enddateComponent.date else { return Date() }
        
        return random(in: (startDate..<endDate))
    }
    
    static func randomDateFrom(firstDate:(Int,Int), secondDate:(Int, Int))-> Date {
        var startDateComponents = DateComponents()
        startDateComponents.month = firstDate.0
        startDateComponents.day = firstDate.1
        startDateComponents.year = Calendar.current.component(.year, from:Date())
        
        var endDateComponents = DateComponents()
        endDateComponents.month = secondDate.0
        endDateComponents.day = secondDate.1
        endDateComponents.year = Calendar.current.component(.year, from:Date())
        
        guard let startDate = Calendar.current.date(from: startDateComponents),
                let endDate = Calendar.current.date(from: endDateComponents) else { return Date() }
        
        
        return random(in:startDate..<endDate)
        
    }
    
    
    static func random(in range: Range<Date>) -> Date {
        let startInterval = range.lowerBound.timeIntervalSince1970
        let endInterval = range.upperBound.timeIntervalSince1970
        let timestamp = (Int(startInterval)...Int(endInterval)).map { $0 }.randomElement() ?? 0
        return Date(timeIntervalSince1970: Double(timestamp))
    }
    
    static func weekOfDates(weekOfYear: Int) -> [Date] {
        let date = Calendar.current.date(from: DateComponents(calendar: Calendar.current, weekOfYear: weekOfYear))!

        let days = (1...7).map { dayValue -> Date? in
            let component = DateComponents(calendar: Calendar.current,
                                           month: Calendar.current.dateComponents([.month], from:date).month,
                                           weekday: dayValue,
                                           weekOfYear: weekOfYear
            )
            return component.date
        }.compactMap { $0 }
        
        return days
    }
    
    
    static func weekOfDates(today: Date) -> [Date] {
       
        let days = (1...7).map { dayValue -> Date? in
            let component = DateComponents(calendar: Calendar.current,
                                           month: Calendar.current.dateComponents([.month], from: today).month,
                                           weekday: dayValue,
                                           weekOfYear: Calendar.current.dateComponents([.weekOfYear], from: today).weekOfYear
            )
            return component.date
        }.compactMap { $0 }
        
        return days
    }
    
    
    func isSameDay(_ date: Date) -> Bool {
        let dayMatches = Calendar.current.compare(self, to: date, toGranularity: .day) == .orderedSame
        let monthMatches = Calendar.current.compare(self, to: date, toGranularity: .month) == .orderedSame
        return dayMatches && monthMatches
        
    }
}
