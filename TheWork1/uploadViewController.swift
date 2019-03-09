//
//  uploadViewController.swift
//  TheWork1
//
//  Created by umeda yodai on 2019/01/21.
//  Copyright © 2019 umeda yodai. All rights reserved.
//

import UIKit
import Eureka
import RealmSwift

class uploadViewController: FormViewController{
    var userID : String = ""
    var keyword : String = ""
    var selectedPicker : String = ""
    var dict:[String:[String:String]] = [:]
    var buttonFlag = false
    var dictFlag = false
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        return dateFormatter
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eureka_upload()
    }
    
    func check(){
        if userID != "" && keyword != "" && selectedPicker != ""{
            buttonFlag = true
        }else{
            buttonFlag = false
        }
    }
    
    
    func eureka_upload(){
        form
            +++ Section("登録情報")
            <<< LabelRow() { row in
                row.title = "ユーザID"
                row.value = "0001"
                userID = row.value!
            }
            <<< TextRow() {
                $0.title = "キーワード"
                $0.placeholder = "英数で入力して下さい。"
                //$0.keyboardReturnType =
                
                //ボタン押下時の処理
                }.onChange {[unowned self] row in
                    //nilの場合空文字に置き換える
                    if row.value == nil {
                        row.value = ""
                    }
                    self.keyword = row.value!
                    self.check()
            }
            <<< PickerInlineRow<String>() { row in
                row.title = "指定年月"
                row.options = ["","2019年3月","2019年4月","2019年5月","2019年6月","2019年7月","2019年8月","2019年9月","2019年10月","2019年11月","2019年12月","2020年1月","2020年2月","2020年3月"]
                row.value = row.options.first
                }.onChange {[unowned self] row in
                    self.selectedPicker = row.value!
                    print(self.selectedPicker )
                    self.check()
            }
            
            <<< ButtonRow() {
                $0.title = "アップロード"
                $0.onCellSelection{ [unowned self] cell, row in
                    if self.buttonFlag {
                        if self.netCon() {
                           self.upload()
                        }else{
                            self.showAlert(title: "ネットワークエラー", message: "ネットワーク接続の確認をして下さい。",flag: false)
                        }
                    }else{
                        self.showAlert(title: "未入力項目があります。", message: "全ての項目を入力してください。",flag: false)
                    }
                }
            }
    }
    
    func upload(){
        getServerEvents()
        
        if !dictFlag {
            self.showAlert(title: self.selectedPicker + "の予定がありません。", message: "予定が登録されている年月のみ登録できます。" ,flag: false)
        }else{
            let urlString = "http://ec2-18-221-89-226.us-east-2.compute.amazonaws.com/c.php"
            let request = NSMutableURLRequest(url: URL(string: urlString)!)
            request.httpMethod = "POST"
            request.addValue("application/json", forHTTPHeaderField: "Content-Type")
            
            let params:[String:Any] = ["id+name": userID + keyword,"dates":dict]
            do{
                request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
                let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                    let resultData = String(data: data!, encoding: .utf8)!
                    print("result:\(resultData)")
                    print("response:\(response)")
                })
                task.resume()
            }catch{
                print("Error:\(error)")
                return
            }
            
            let realm = try! Realm()
            //登録
            let uploadRealm = uploadItem()
            uploadRealm.yearMonth = selectedPicker
            uploadRealm.idName = userID + keyword

            try! realm.write() {
                realm.add(uploadRealm)
            }
            print(Realm.Configuration.defaultConfiguration.fileURL)
            self.showAlert(title: "登録完了", message: userID + keyword + "で" + selectedPicker + "分が登録されました。",flag: true)
            self.navigationController?.popViewController(animated: true)
        }
    }
    
    
    
    func getServerEvents() {
        let date = dateValueClass.selectedDateStr(str: selectedPicker,flag: 1)
        print(selectedPicker)
        let realm = try! Realm()
        let realmResults = realm.objects(plans.self).filter("date BEGINSWITH '" + date + "'")
        var i : Int = 0
        for data in realmResults{
            dict.updateValue(["date":data.date, "plan":data.plan, "time":data.limit], forKey: String(i))
            i = i + 1
            dictFlag = true
        }
        print(dict)
        
    }
    
    //ダイアログを表示する機能
    func showAlert(title:String,message:String,flag:Bool){
        let alertController = UIAlertController(title:title,message:message,preferredStyle:UIAlertController.Style.alert)
        if flag{
            //登録が完了の際は前の画面へ戻る
            alertController.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler:{
                    (action:UIAlertAction!) -> Void in self.navigationController?.popViewController(animated: true)
                }
            ))
        }else{
            alertController.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler:nil))
        }
        self.present(alertController,animated:true,completion:nil)
    }
    
    func netCon() -> Bool{
        return networkState.state()
    }
}
