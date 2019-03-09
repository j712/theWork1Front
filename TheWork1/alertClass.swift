//
//  alertClass.swift
//  TheWork1
//
//  Created by umeda yodai on 2018/12/25.
//  Copyright © 2018 umeda yodai. All rights reserved.
//

import UserNotifications

class alertClass {
    
    
    
    
    class func notification(component: DateComponents, date:String, message: String) {
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
        }
        // 通知内容の設定
        let content = UNMutableNotificationContent()
        
        content.title = NSString.localizedUserNotificationString(forKey: "Title", arguments: nil)
        content.body = NSString.localizedUserNotificationString(forKey: message, arguments: nil)
        content.sound = UNNotificationSound(named:UNNotificationSoundName(rawValue: "masao.mp3"))
       
        let trigger = UNCalendarNotificationTrigger(dateMatching: component, repeats: false)
        print(trigger)
        let request = UNNotificationRequest(identifier: date, content: content, trigger: trigger)
        // 通知を登録
        center.add(request) { (error : Error?) in
            if error != nil {
                // エラー処理
            }
        }
    }
    
    class func datecomponentsArray(date: String, number: String) {
        let value: [String] = ["就寝時間になりました、寝ましょう。","起床時間になりました、起きて下さい！","準備は済みましたか？目的地へ出発しましょう。","目的地へ到着、できましたよね？"]
        var component = DateComponents()
        component.year = Int(date[date.index(date.startIndex, offsetBy: 0)..<date.index(date.startIndex, offsetBy: 4)])
        component.month = Int(date[date.index(date.startIndex, offsetBy: 5)..<date.index(date.startIndex, offsetBy: 7)])
        component.day = Int(date[date.index(date.startIndex, offsetBy: 8)..<date.index(date.startIndex, offsetBy: 10)])
        component.hour = Int(date[date.index(date.startIndex, offsetBy: 11)..<date.index(date.startIndex, offsetBy: 13)])
        component.minute = Int(date[date.index(date.startIndex, offsetBy: 14)..<date.index(date.startIndex, offsetBy: 16)])
        let identifier: String = String(date.prefix(10)) + number
        alertClass.notification(component: component,date: identifier,message: value[Int(number)!])
    }
    
    class func resetAlert(date: String){
        let center = UNUserNotificationCenter.current()
        center.requestAuthorization(options: [.alert, .sound, .badge]) {
            (granted, error) in
        }
        //reset処理
        for i in 0...3{
            center.removePendingNotificationRequests(withIdentifiers: [date + String(i)])
        }
    }
}
