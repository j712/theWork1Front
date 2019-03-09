//
//  insertViewController.swift
//  TheWork1
//
//  Created by umeda yodai on 2018/12/15.
//  Copyright © 2018 umeda yodai. All rights reserved.
//

import UIKit
import RealmSwift
import Eureka

class insertViewController: FormViewController,UITextFieldDelegate {
    
//    @IBOutlet weak var selectedDate: UILabel!
//    @IBOutlet weak var planName: UITextField!
//    @IBOutlet weak var timePicker: UIDatePicker!
//    @IBOutlet weak var aLabel: UILabel!
//    @IBOutlet weak var insertButton: UIButton!
    var plan = ""
    var date = ""
    var flag = false
    var strLimit:String = ""
    var limit:Date!
    var check: Bool = false
   
    override func viewDidLoad() {
        super.viewDidLoad()
        eureka1()
       
    }
    
    @IBAction func register(_ sender: Any) {
        if self.plan != "" && self.limit != nil{
            //realmに登録する系
            let plan = self.plan
            let limit = dateValueClass.dateZeroDelete(str: dateValueClass.formatDS(date: self.limit))
            let date = dateValueClass.selectedDateStr(str: self.date,flag: 0)
            let realm = try! Realm()
            //削除
            let delete = realm.objects(plans.self).filter("date == '" + date + "'")
            try! realm.write {
                realm.delete(delete)
            }
            //登録
            let dataInsert = plans()
            dataInsert.plan = plan
            dataInsert.limit = limit
            dataInsert.date = date
            try! realm.write() {
                realm.add(dataInsert)
            }
            //alert設定系
            let strYmd = date + " " + dateValueClass.dateZeroAdd(str: limit) + ":00"
            print(Realm.Configuration.defaultConfiguration.fileURL)
            //stringの日付をDateComponent型にしてそのまま通知の登録を行う
        
            let value1 = dateValueClass.limitMinusGetup(limit: date + " " + limit, flag: 0,full: true) + ":00"
            let value2 = dateValueClass.limitMinusGetup(limit: date + " " + limit, flag: 1,full: true) + ":00"
            let value3 = dateValueClass.limitMinusGetup(limit: date + " " + limit, flag: 2,full: true) + ":00"
            print(value1)
            print(value2)
            print(value3)
            alertClass.resetAlert(date: date)
            alertClass.datecomponentsArray(date: value3, number: "0")
            alertClass.datecomponentsArray(date: value2, number: "1")
            alertClass.datecomponentsArray(date: value1, number: "2")
            alertClass.datecomponentsArray(date: strYmd, number: "3")
            //画面遷移系
            //登録完了後のリロードを設定
            let nav = self.navigationController
            // 一つ前のViewControllerを取得
            let beforeViewController = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! ViewController
            // 値を渡す
            beforeViewController.loadCalendar()
            _ = navigationController?.popViewController(animated: true)
        }else{
            let alertController = UIAlertController(title:"未入力が存在します。",message:"予定と時刻を入力して下さい。",preferredStyle:UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler:nil))
            self.present(alertController,animated:true,completion:nil)
        
        }
    }
    func textFieldDidEndEditing(_ textField: UITextField) {
        //checkTextField()
    }
    
    
    
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        self.view.endEditing(true)
        return true
    }
    
    
    func eureka1(){
        form
            +++ Section("セクション1")
            <<< TextRow(){
                $0.title = "予定"
                $0.placeholder = "予定名を入力して下さい。"
                //ボタン押下時の処理
                $0.value = plan
                }.onChange {[unowned self] row in
                    if row.value == nil {
                        row.value = ""
                    }
                    self.plan = row.value!
            }
            <<< TimeInlineRow("") {
                $0.title = "時刻を選択"
                let dateFormater = DateFormatter()
                dateFormater.locale = Locale(identifier: "ja_JP")
                dateFormater.dateFormat = "HH:mm"
                $0.value = dateFormater.date(from: self.strLimit)
                
                //$0.value =
                }.onChange() { row in
                    // 選択された日を表示
                    self.limit = row.value!
                    print(row.value!)
                }
    }
    
    
   
}
