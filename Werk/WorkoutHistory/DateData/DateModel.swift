//
//  DateModel.swift
//  Werk
//
//  Created by Shaquil Campbell on 12/12/22.
//

import Foundation



func dayStringFrom(date: Date) -> String {
    let day = Calendar.current.dateComponents([.weekday], from: date).weekday!
    let dayString = ["S","M","T","W","T","F","S"][day - 1]
    return dayString
}
func showCurrentWeekNumber(startDate: Date) -> Int {
    var calendar = Calendar.current
    calendar.firstWeekday =  1 // Monday
    calendar.locale = Locale.current
    
    
    let weekNumberForSatrtDate = calendar.component(.weekOfYear, from: startDate)
    
    
    
    return weekNumberForSatrtDate
}

func weekRangeOfYear(week: Int)->(Date, Date, String)  {
    
    var calendar = Calendar.current
    calendar.locale = Locale.current
    var weekStartComponents = DateComponents()
    weekStartComponents.weekOfYear = week
    weekStartComponents.weekday = 1
    weekStartComponents.year = calendar.component(.year, from: Date())
    
    var weekEndComponenets = DateComponents()
    weekEndComponenets.weekOfYear = week
    weekEndComponenets.weekday = 7  //days of the months go from 1 - 7
    weekEndComponenets.year = calendar.component(.year, from: Date())
    
    let weekStartDate = calendar.date(from: weekStartComponents)
    let weekEndDate = calendar.date(from: weekEndComponenets)
    
    let formatter = DateFormatter()
    formatter.dateFormat = "LLL dd"
    let weekStarDayString = formatter.string(from: weekStartDate!)
    let weekEndDayString = formatter.string(from: weekEndDate!)
    print(weekStartDate)
    print(weekEndDate)
    
    return (weekStartDate!, weekEndDate!, "\(weekStarDayString) - \(weekEndDayString)")
}
