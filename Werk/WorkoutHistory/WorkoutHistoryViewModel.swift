
import Foundation
import SwiftUI
import Charts


class DateHolder: ObservableObject {
    var calendar = Calendar.current
    var date = Date()
    
    func showCurrentWeekNumber(startDate: Date) -> Int {
        var calendar = Calendar.current
        calendar.firstWeekday =  1 // Monday
        calendar.locale = Locale.current
        
        
        let weekNumberForSatrtDate = calendar.component(.weekOfYear, from: startDate)
        
        
        
        return weekNumberForSatrtDate
    }
    
}

func weekRangeOfYear(week: Int)->(Date, Date, String)  {
    var week: Int = 42
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



// graph has to coencide with each week of the year and their individual days
// mus show colors of workout progressing vertically


