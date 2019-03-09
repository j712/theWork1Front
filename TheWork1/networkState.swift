//
//  networkState.swift
//  TheWork1
//
//  Created by umeda yodai on 2019/02/02.
//  Copyright © 2019 umeda yodai. All rights reserved.
//

import UIKit
import Reachability

class networkState {
    class func state() -> Bool{
        let reach = Reachability()!
        let tf = reach.connection == .wifi || reach.connection == .cellular ? true : false
        print("wifi:",reach.connection == .wifi)
        print("cellular:",reach.connection == .cellular)
        print("none:",reach.connection == .none)
        return tf
    }
    
}
