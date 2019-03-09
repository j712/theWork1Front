//
//  dateValueClass.swift
//  TheWork1
//
//  Created by umeda yodai on 2018/12/17.
//  Copyright © 2018 umeda yodai. All rights reserved.
//
import JTAppleCalendar

class dateValueClass {
    //dateの不要な０を消すクラス
    class func dateZeroDelete(str: String) -> String {
        var result: String = str
        if str.hasPrefix("0"){
            if let range = str.range(of: "0"){
                result = str.replacingCharacters(in: range, with: "")
            }
        }
        return result
    }
    //dateに必要な０を追加するクラス
    class func dateZeroAdd(str: String) -> String {
        var result: String = str
        if str.count == 4{
            result = "0" + str
        }
        return result
    }
    //date型に適した形式に置き換えるクラス
    class func selectedDateStr(str: String,flag: Int) -> String{
        var result = ""
        if flag == 0{
            result = str.replacingOccurrences(of: "年", with: " ")
            result = result.replacingOccurrences(of: "月", with: " ")
            result = result.replacingOccurrences(of: "日", with: "")
        }else if flag == 1{
            if str.count == 7{
                result = str.replacingOccurrences(of: "年", with: " 0")
            }else{
                result = str.replacingOccurrences(of: "年", with: " ")
            }
            result = result.replacingOccurrences(of: "月", with: "")
        }
        
        return result
    }
    //カレンダー画面にて表示する起床時間などの計算を行うクラス
    class func limitMinusGetup(limit :String, flag :Int, full :Bool) -> String {
        //userDefaultsにあるデータの取得
        let minusValue:[Int] = dateValueClass.defaultValue()
        
        let dateFormater = DateFormatter()
        dateFormater.locale = Locale(identifier: "ja_JP")
        dateFormater.dateFormat = full ? "yyyy MM dd HH:mm" : "HH:mm"
        
        //到着時間をdate型で格納
        var getupDate: Date = dateFormater.date(from: limit)!
        //到着時間から起床時間を割り出す引算
        let calendar = Calendar.current
        
        var minusHour = minusValue[0]
        var minusMinute = minusValue[1]
        if 0 < flag{
            minusHour = minusHour + minusValue[2]
            minusMinute = minusMinute + minusValue[3]
            if flag == 2 {
                minusHour = minusHour + minusValue[4]
                minusMinute = minusMinute + minusValue[5]
            }
        }
        let comps = DateComponents( hour: -minusHour,minute: -minusMinute)
        getupDate = calendar.date(byAdding: comps, to: getupDate)!
        //date型からstring型へ変換、先頭が０の場合それを削除
        let strDate = dateValueClass.dateZeroDelete(str: dateFormater.string(from: getupDate))
        
        return strDate
    }
    
    class func defaultValue() -> [Int]{
        let userDefaults = UserDefaults.standard
        // データの同期
        userDefaults.synchronize()
        // Keyを指定して読み込み
        var value: [Int] = [0,0,0,0,0,0]
        value[0] = Int(userDefaults.object(forKey: "outHH") as! String)!
        value[1] = Int(userDefaults.object(forKey: "outmm") as! String)!
        value[2] = Int(userDefaults.object(forKey: "getHH") as! String)!
        value[3] = Int(userDefaults.object(forKey: "getmm") as! String)!
        value[4] = Int(userDefaults.object(forKey: "bedHH") as! String)!
        value[5] = Int(userDefaults.object(forKey: "bedmm") as! String)!
        return value
    }
    
    class func defaultValue() -> [String]{
        let userDefaults = UserDefaults.standard
        // データの同期
        userDefaults.synchronize()
        // Keyを指定して読み込み
        var value: [String] = ["","","","","","",""]
        value[0] = userDefaults.object(forKey: "userName") as! String
        value[1] = userDefaults.object(forKey: "outHH") as! String
        value[2] = userDefaults.object(forKey: "outmm") as! String
        value[3] = userDefaults.object(forKey: "getHH") as! String
        value[4] = userDefaults.object(forKey: "getmm") as! String
        value[5] = userDefaults.object(forKey: "bedHH") as! String
        value[6] = userDefaults.object(forKey: "bedmm") as! String
        return value
    }
    
    class func insertDefaultValue(str:[String]){
        let userDefaults = UserDefaults.standard
        // デフォルト値
        //userDefaults.register(defaults: ["userName":"" ,"outHH": str[1], "outmm": str[2], "getHH": str[3], "getmm": str[4]])
        userDefaults.set(str[0], forKey: "userName")
        userDefaults.set(str[1], forKey: "outHH")
        userDefaults.set(str[2], forKey: "outmm")
        userDefaults.set(str[3], forKey: "getHH")
        userDefaults.set(str[4], forKey: "getmm")
        userDefaults.set(str[5], forKey: "bedHH")
        userDefaults.set(str[6], forKey: "bedmm")
    }
    
    class func formatDS(date:Date)->String{
        let dateformatter = DateFormatter()
        dateformatter.dateFormat = "HH:mm"
        let strDate = dateformatter.string(from: date)
        print(strDate)
        return strDate
    }
}
