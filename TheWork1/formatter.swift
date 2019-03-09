//
//  formatter.swift
//  TheWork1
//
//  Created by umeda yodai on 2018/12/12.
//  Copyright © 2018 umeda yodai. All rights reserved.


import JTAppleCalendar
class formatter{
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        return dateFormatter
    }()

}
