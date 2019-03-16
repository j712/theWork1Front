//
//  downloadViewController.swift
//  
//
//  Created by umeda yodai on 2019/02/05.
//

import UIKit
import Eureka
import RealmSwift

struct result : Codable {
    var date: String
    var plan: String
    var time: String
}

class downloadViewController: FormViewController {
    
    var code : String = ""
    var buttonFlag = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eureka_download()
    }
    
    func download(){
        let urlString = "SeverName等/download.php"
        let request = NSMutableURLRequest(url: URL(string: urlString)!)
        request.httpMethod = "POST"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")

        let params:[String:Any] = ["id+name": code]
        do{
            request.httpBody = try JSONSerialization.data(withJSONObject: params, options: .prettyPrinted)
            let task:URLSessionDataTask = URLSession.shared.dataTask(with: request as URLRequest, completionHandler: {(data,response,error) -> Void in
                let resultData = String(data: data!, encoding: .utf8)!

                let decoder = JSONDecoder()
                let feed = try? decoder.decode([result].self, from:resultData.data(using: .utf8)!)
                
                //リセット用コマンド
                let realm = try! Realm()
                if self.code == "ww" {
                    let results = realm.objects(plans.self)
                    try! realm.write {
                        realm.delete(results)
                    }
                }
                
                for i in 0 ..< feed!.count {
                    let dataInsert = plans()
                    dataInsert.plan = feed![i].plan
                    dataInsert.limit = feed![i].time
                    dataInsert.date = feed![i].date
                    try! realm.write() {
                        realm.add(dataInsert, update: true)
                    }
                }
                 print(Realm.Configuration.defaultConfiguration.fileURL)
                
            })
            task.resume()
        }catch{
            print("Error:\(error)")
            return
        }
        self.showAlert(title: "ダウンロード完了", message:"カレンダーに予定が登録されました。",flag: true)
        self.navigationController?.popViewController(animated: true)
    }
    
    //画面を作成する
    func eureka_download(){
        form
            +++ Section("")
            <<< TextRow() {
                $0.title = "コード"
                $0.placeholder = "コードを入力して下さい"
                
                //ボタン押下時の処理
                }.onChange {[unowned self] row in
                    //nilの場合空文字に置き換える
                    self.code = row.value != nil ? row.value! : ""
                    self.buttonFlag = self.code != "" ? true : false
            }
            <<< ButtonRow() {
                $0.title = "ダウンロード"
                $0.onCellSelection{ [unowned self] cell, row in
                    if self.buttonFlag {
                        if self.netCon() {
                            self.download()
                        }else{
                            self.showAlert(title: "ネットワークエラー", message: "ネットワーク接続の確認をして下さい。",flag: false)
                        }
                    }else{
                        self.showAlert(title: "未入力項目があります。", message: "コンテンツコードを入力してください。",flag: false)
                    }
                }
        }
    }
    
    //ダイアログを表示する
    func showAlert(title:String,message:String,flag:Bool){
        let alertController = UIAlertController(title:title,message:message,preferredStyle:UIAlertController.Style.alert)
        if flag{
            //登録が完了の際は前の画面へ戻る
            alertController.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler:{
                (action:UIAlertAction!) -> Void in self.navigationController?.popViewController(animated: true)
            }))
        }else{
            alertController.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler:nil))
        }
        self.present(alertController,animated:true,completion:nil)
    }
    
    //インターネットに接続しているかboolで返す
    func netCon() -> Bool{
        return networkState.state()
    }
}
