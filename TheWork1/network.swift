//
//  network.swift
//  TheWork1
//
//  Created by umeda yodai on 2019/02/02.
//  Copyright © 2019 umeda yodai. All rights reserved.
//

import UIKit
import Reachability

class network {
    class func state() -> Bool{
        var tf = false
        
        let reach = Reachability()!
        tf = reach.connection == .wifi || reach.connection == .cellular || reach.connection == .none ? true : false
            print("wifi:",reach.connection == .wifi)
            print("cellular:",reach.connection == .cellular)
            print("none:",reach.connection == .none)
        
        print("tf:",tf)
        return tf
    }
    
}
