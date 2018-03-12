//
//  DateTimeHelpers.swift
//  Swipeable-View-Stack
//
//  Created by Bonnie Nguyen on 3/8/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit

class DateTimeHelper {
    
    // Returns the current date in yyyy-MM-dd formate without the time
    public func getTodayDate() -> String {
        let today = Date().description
        let todayArray = today.split(separator: " ")
        return String(todayArray[0])
    }
    
    // Returns the current day of the week as an Int
    public func getDayOfWeek() -> Int? {
        let today = self.getTodayDate()
        let formatter  = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd"
        guard let todayDate = formatter.date(from: today) else { return nil }
        let myCalendar = Calendar(identifier: .gregorian)
        let weekDay = myCalendar.component(.weekday, from: todayDate)
        return weekDay
    }
    
    // Pre: 24-hour format time
    // Post: Returns AM/PM format as string
    public func format24Hour(time: String) -> String {
        let formatter = DateFormatter()
        let timeArray = Array(time)
        
        var dateArray = Date().description.split(separator: " ")
        dateArray.remove(at: dateArray.count - 1)
        var newTime: String = ""
        
        for i in 0...(timeArray.count + 1) {
            if i < timeArray.count {
                newTime += String(timeArray[i])
            }
            if i % 2 != 0, i < (timeArray.count + 1) {
                newTime += ":"
            }
            if i > timeArray.count - 1 {
                newTime += "0"
            }
        }
        dateArray[1] = Substring(newTime)
        let newDateString = dateArray.joined(separator: " ")
        
        formatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        formatter.timeZone = NSTimeZone(name: "UTC") as TimeZone!
        let newDate = formatter.date(from: newDateString)
        
        formatter.dateFormat = "hh:mm a"
        let time = formatter.string(from: newDate as Date!)
        return time
    }
}

