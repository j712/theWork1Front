//
//  value.swift
//  TheWork1
//
//  Created by umeda yodai on 2018/12/15.
//  Copyright © 2018 umeda yodai. All rights reserved.
//

import UIKit

class value {
   
    func format(date:Date)->String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        let strDate = dateformatter.string(from: date)
        
        return strDate
    }
    
    

}
