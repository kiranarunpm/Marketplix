//
//  Image+Extension.swift
//  Marketplix
//
//  Created by Kiran P M on 14/08/23.
//

import UIKit

extension UIImage{
    
    static var checkBox : UIImage {return UIImage(named: "checkbox-check") ?? UIImage()}
    static var un_checkBox : UIImage {return UIImage(named: "checkbox-unchecked") ?? UIImage()}
    
}






extension String{
    
    func convertDateFormat(dateFormat: String) -> String {
        
        let olDateFormatter = DateFormatter()
        olDateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss.SSSSSS'Z'"
        
        let oldDate = olDateFormatter.date(from: self)
        
        let convertDateFormatter = DateFormatter()
        convertDateFormatter.dateFormat = dateFormat
        
        return convertDateFormatter.string(from: oldDate!)
    }
    
    func dateFormat(_ date: String)->String{
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd HH:mm:ss"
        
        // Replace with your input date string
        let inputDateString = date
        if let inputDate = dateFormatter.date(from: inputDateString) {
            let timeAgo = daysAndHoursAgo(from: inputDate)
            print("\(inputDateString) was \(timeAgo)")
            return timeAgo
        } else {
            print("Invalid input date format")
            return ""
        }
    }
    func daysAndHoursAgo(from inputDate: Date) -> String {
        let currentDate = Date()
        var calendar = Calendar.current
        calendar.timeZone = TimeZone(abbreviation: "UTC")! 
        let components = calendar.dateComponents([.year, .month, .day, .hour, .minute, .second], from: inputDate, to: currentDate)
        if let years = components.year, years > 0 {
            return years == 1 ? "1 year ago" : "\(years) years ago"
        }
        else if let months = components.month, months > 0 {
            return months == 1 ? "1 month ago" : "\(months) months ago"
        } else if let days = components.day, days > 0 {
            return days == 1 ? "1 day ago" : "\(days) days ago"
        } else if let hours = components.hour, hours > 0 {
            return hours == 1 ? "1 hour ago" : "\(hours) hours ago"
        } else if let minutes = components.minute, minutes > 0 {
            return minutes == 1 ? "1 minute ago" : "\(minutes) minutes ago"
        } else if let seconds = components.second, seconds > 0 {
            return seconds == 1 ? "1 second ago" : "\(seconds) seconds ago"
        } else {
            return "Just now"
        } }
    
}


