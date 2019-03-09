//
//  onlineViewController.swift
//  
//
//  Created by umeda yodai on 2019/01/17.
//

import UIKit
import Eureka
import RealmSwift

class onlineViewController: FormViewController,UINavigationControllerDelegate {
    
    let lab = [LabelRow(),LabelRow(),LabelRow(),LabelRow(),LabelRow()]
    
    override func viewDidLoad() {
        super.viewDidLoad()
        navigationController?.delegate = self
        onlineViewRealm()
        eureka_online()
    }
    
    //画面作成
    func eureka_online(){
        form
            +++ Section("")
            <<< ButtonRow() {
                $0.title = "アップロード"
                $0.onCellSelection{ [unowned self] cell, row in
                    self.performSegue(withIdentifier: "toUpLoad", sender: nil)
                }
            }
            <<< ButtonRow() {
                $0.title = "ダウンロード"
                $0.onCellSelection{ [unowned self] cell, row in
                    self.performSegue(withIdentifier: "nwInsert", sender: nil)
                }
            }
        +++ Section("登録したIDと年月")
            <<< lab[0]
            <<< lab[1]
            <<< lab[2]
            <<< lab[3]
            <<< lab[4]
        
    }
    
    
    //戻るボタンを押した時、メインのViewControllerを更新する
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let controller = viewController as? ViewController {
            controller.reloadViews()
            _ = navigationController.popViewController(animated: true)
        }
    }
    //画面下部の履歴を表示する
    func onlineViewRealm(){
        let realm = try! Realm()
        let realmResults = realm.objects(uploadItem.self).sorted(byKeyPath: "yearMonth",ascending: false)
        var i = 0
        for data in realmResults {
            if i == 5{
                break
            }else{
                lab[i].title = data.yearMonth  + ":" + data.idName
                i += 1
            }
        }
    }
}
