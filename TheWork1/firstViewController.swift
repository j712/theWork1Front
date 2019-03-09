//
//  firstViewController.swift
//  TheWork1
//
//  Created by umeda yodai on 2018/12/27.
//  Copyright © 2018 umeda yodai. All rights reserved.
//

import UIKit
import Eureka


class firstViewController: UIViewController,UITextFieldDelegate{
    
    let printFormatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "HH時間mm分"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Calendar.current.locale
        return dateFormatter
    }()
    
    @IBOutlet weak var userName: UITextField!
    @IBOutlet weak var getUp: UITextField!
    @IBOutlet weak var departure:UITextField!
    @IBOutlet weak var goingToBed: UITextField!
    @IBOutlet weak var insertButton: UIButton!
    
    var flag: Int = 0
    var text: String = ""
    var value: [String] = ["","","","","","","",""]
    var check: [Bool] = [false,false,false,false]
    //ViewControllerから遷移時trueになる
    var visit: Bool = false
    let datePicker = UIDatePicker()

    override func viewDidLoad() {
        super.viewDidLoad()
        userName.delegate = self
        getUp.delegate = self
        departure.delegate = self
        
        userName.placeholder = "ユーザネームを入力して下さい。"
        defaultDatePicker()
        if visit {
            defaultSet()
            checkTextField()
        }
    }
    
    //UserDefaultsに格納するためのデータ加工
    
    @IBAction func departureClick(_ sender: Any) {
        departure.text = text
        value[1] = String(text.prefix(2))
        value[2] = String(text[text.index(text.startIndex, offsetBy: 4)..<text.index(text.startIndex, offsetBy: 6)])
    }
    @IBAction func getUpClick(_ sender: Any) {
        getUp.text = text
        value[3] = String(text.prefix(2))
        value[4] = String(text[text.index(text.startIndex, offsetBy: 4)..<text.index(text.startIndex, offsetBy: 6)])
    }
    @IBAction func goingToBedClick(_ sender: Any) {
        goingToBed.text = text
        value[5] = String(text.prefix(2))
        value[6] = String(text[text.index(text.startIndex, offsetBy: 4)..<text.index(text.startIndex, offsetBy: 6)])
    }
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        checkTextField()
    }
    
    func checkTextField() {
        check[0] = userName.text != "" ? true : false
        check[1] = getUp.text != "" ? true : false
        check[2] = goingToBed.text != "" ? true : false
        check[3] = departure.text != "" ? true : false
        if check[0] == true && check[1] == true && check[2] == true && check[3]{
            insertButton.isEnabled = true
        }else{
            insertButton.isEnabled = false
        }
        print(check)
    }
    
    
    func defaultDatePicker(){
        datePicker.datePickerMode = .time
        datePicker.locale = NSLocale(localeIdentifier: "ja_JP") as Locale
        timeReset()
        // textFieldのinputViewにdatepickerを設定
        getUp.inputView = datePicker
        departure.inputView = datePicker
        goingToBed.inputView = datePicker
        // UIToolbarを設定
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // Doneボタンを設定(押下時doneClickedが起動)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked))
        // Doneボタンを追加
        toolbar.setItems([doneButton], animated: true)
        // FieldにToolbarを追加
        getUp.inputAccessoryView = toolbar
        departure.inputAccessoryView = toolbar
        goingToBed.inputAccessoryView = toolbar
    }
    
    @objc func doneClicked(){
        text = printFormatter.string(from: datePicker.date)
        timeReset()
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // キーボードを閉じる
        self.view.endEditing(true)
        return true
    }
    
    @IBAction func insert(_ sender: Any) {
        value[0] = userName.text!
        dateValueClass.insertDefaultValue(str: value)
        if visit {
            //リロードを設定する
            let nav = self.navigationController
            // 一つ前のViewControllerを取得する
            let beforeViewController = nav?.viewControllers[(nav?.viewControllers.count)!-2] as! ViewController
            // 値を渡す
            beforeViewController.loadCalendar()
            
            _ = navigationController?.popViewController(animated: true)
        }else{
            self.performSegue(withIdentifier: "toCalendar", sender: nil)
        }
    }
    
    func timeReset(){
        let formatter = DateFormatter()
        formatter.dateFormat = "HH:mm"
        datePicker.date = formatter.date(from: "00:00")!
    }
    
    func defaultSet(){
        value = dateValueClass.defaultValue()
        userName.text = value[0]
        departure.text = value[1] + "時間" + value[2] + "分"
        getUp.text = value[3] + "時間" + value[4] + "分"
        goingToBed.text = value[5] + "時間" + value[6] + "分"
    }
}
