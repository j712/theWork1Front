//
//  ViewController.swift
//  TheWork1
//
//  Created by umeda yodai on 2018/12/03.
//  Copyright © 2018 umeda yodai. All rights reserved.
//

import UIKit
import JTAppleCalendar
import RealmSwift
import HNToaster

class ViewController: UIViewController,UITextFieldDelegate {
    @IBOutlet weak var calendarView: JTAppleCalendarView!
    //画面下の部品
    @IBOutlet weak var selectedDate: UILabel!
    @IBOutlet weak var eventLabel: UILabel!
    @IBOutlet weak var limitLabel: UILabel!
    @IBOutlet weak var getupLabel: UILabel!
    @IBOutlet weak var departureLabel: UILabel!
    @IBOutlet weak var goingToBedLabel: UILabel!
    @IBOutlet weak var insert: UIButton!
    @IBOutlet weak var delete: UIButton!
    @IBOutlet weak var limitLabeldefault: UILabel!
    @IBOutlet weak var departureLabelDefault: UILabel!
    @IBOutlet weak var getupLabelDefault: UILabel!
    @IBOutlet weak var goingToBedDefault: UILabel!
    
    @IBOutlet weak var goView: UIStackView!
    @IBOutlet weak var timeInsert: UITextField!
    
    @IBOutlet weak var yearLabel: UINavigationItem!
    
    var Preparation: [Int] = [0,0]
    var eventsFromTheServer: [String:[String]] = [:]
    let datePicker = UIDatePicker()
    
    let formatter: DateFormatter = {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy MM dd"
        dateFormatter.timeZone = Calendar.current.timeZone
        dateFormatter.locale = Locale(identifier: "ja_JP")
        return dateFormatter
    }()
    let pv = UIPickerView()
    let dp = UIDatePicker()
    let items = ["日","月","火","水","木","金","土"]
    var sunSat = "日"
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        eventsFromTheServer = [:]
        timeInsert.delegate = self
        yearLabel.title = ""
        DatePicker()
        //今日の日付をデフォルト選択
        Preparation = dateValueClass.defaultValue()
        loadCalendar()
        
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "secondVisitToFirst" {
            let secondVc = segue.destination as! firstViewController
            secondVc.visit = true
        }
    }
    
    @IBAction func insertClick(_ sender: Any) {
        if timeInsert.text != "" {
            insertSetting(sLimit: timeInsert.text!, sDate: selectedDate.text!)
            showAndLoad()
            
        }else{
            let alertController = UIAlertController(title:"未入力が存在します。",message:"予定と時刻を入力して下さい。",preferredStyle:UIAlertController.Style.alert)
            
            alertController.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler:nil))
            self.present(alertController,animated:true,completion:nil)
        }
    }
    
    
    @IBAction func tap(_ sender: Any) {
        let alert = UIAlertController(title: "曜日", message: "\n\n\n\n\n\n\n\n\n", preferredStyle: .alert)
        let okAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            
            let alert2 = UIAlertController(title: "曜日", message: self.yearLabel.title! + " " + self.sunSat + "曜日でよろしいですか？", preferredStyle: .alert)
            let okAction2 = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
                (action: UIAlertAction!) -> Void in
                
                print("sunSat:" + self.sunSat)
                print("dp:", self.dp.date)
                self.weekInsert()
                
                
            })
            let cancelAction2 = UIAlertAction(title: "Cancel", style: .cancel) { action in
            }
            
            alert2.addAction(okAction2)
            alert2.addAction(cancelAction2)
            self.present(alert2, animated: true, completion: nil)
        })
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel) { action in
        }
        dp.datePickerMode = .time
        dp.date = Date()
        formatter.dateFormat = "yyyy-MM-01 10:00:00"
        dp.date = formatter.date(from: formatter.string(from :dp.date))!
        print("dp_date",dp.date,dp.date.weekday)
        print("time",dp.date,dp.date.weekday)
        dp.frame = CGRect(x:self.view.bounds.width-(view.bounds.width * 0.65), y:50, width:view.bounds.width * 0.35, height:150)
        
        
        // PickerView
        pv.selectRow(0, inComponent: 0, animated: true) // 初期値
        pv.frame = CGRect(x:0, y:50, width:view.bounds.width * 0.35, height:150) // 配置、サイズ
        pv.dataSource = self
        pv.delegate = self
        alert.view.addSubview(pv)
        
        alert.view.addSubview(dp)
        
        alert.addAction(okAction)
        alert.addAction(cancelAction)
        present(alert, animated: true, completion: nil)
    }
    
    @IBAction func deletePlan(_ sender: Any) {
        let alert: UIAlertController = UIAlertController(title: "予定を削除してもいいですか？", message: nil, preferredStyle:  UIAlertController.Style.actionSheet)
        //okボタン
        let defaultAction: UIAlertAction = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler:{
            (action: UIAlertAction!) -> Void in
            self.okButton()
        })
        //キャンセルボタン
        let cancelAction: UIAlertAction = UIAlertAction(title: "キャンセル", style: UIAlertAction.Style.cancel, handler:{
            (action: UIAlertAction!) -> Void in
        })
        // UIAlertControllerにActionを追加
        alert.addAction(cancelAction)
        alert.addAction(defaultAction)
        //Alertを表示
        present(alert, animated: true, completion: nil)
    }
}

extension ViewController{
    func showAndLoad(){
        let message1: String = "登録完了！"
        Toaster.toast(onView: self.view, message: message1)
        timeInsert.text?.removeAll()
        loadCalendar()
    }
    
    func insertSetting(sLimit:String,sDate:String){
        //realmに登録する系
        formatter.dateFormat = "HH:mm"
        let limit = dateValueClass.dateZeroDelete(str: dateValueClass.formatDS(date: formatter.date(from: sLimit)!))
        let date = dateValueClass.selectedDateStr(str: sDate,flag: 0)
        let realm = try! Realm()
        //削除
        let delete = realm.objects(plans.self).filter("date == '" + date + "'")
        try! realm.write {
            realm.delete(delete)
        }
        //登録
        let dataInsert = plans()
        dataInsert.plan = "学校"
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
        alertClass.resetAlert(date: date)
        alertClass.datecomponentsArray(date: value3, number: "0")
        alertClass.datecomponentsArray(date: value2, number: "1")
        alertClass.datecomponentsArray(date: value1, number: "2")
        alertClass.datecomponentsArray(date: strYmd, number: "3")
        
//        let alertController = UIAlertController(title:"登録完了！",message: "",preferredStyle:UIAlertController.Style.alert)
//
//        alertController.addAction(UIAlertAction(title:"OK",style:UIAlertAction.Style.default,handler:nil))
//        self.present(alertController,animated:true,completion:nil)
    }
    
    func getServerEvents() -> [Date:[String]] {
        formatter.dateFormat = "yyyy MM dd"
        let realm = try! Realm()
        let realmResults = realm.objects(plans.self)
        var result = [Date:[String]]()
        for data in realmResults {
            result.updateValue([data.plan,data.limit], forKey: formatter.date(from: data.date)!)
        }
        
        
        return result
    }
    //選択された日付に対する情報の設定
    func selected(date:Date){
        //選択された日付を画面下部のViewに表示
        formatter.dateFormat = "yyyy年MM月dd日"
        selectedDate.text = formatter.string(from: date)
        formatter.dateFormat = "yyyy MM dd"
        //イベントのタイトルを取得し、画面下部のViewに表示
        if let array: [String] = eventsFromTheServer[formatter.string(from: date)]{
            goView.isHidden = false
            eventLabel.text = array[0]
            limitLabel.text = array[1]
            departureLabel.text = dateValueClass.limitMinusGetup(limit: array[1], flag: 0, full: false)
            getupLabel.text = dateValueClass.limitMinusGetup(limit: array[1], flag: 1, full: false)
            goingToBedLabel.text = dateValueClass.limitMinusGetup(limit: array[1], flag: 2, full: false)
            insert.setTitle("変更", for: .normal)
            delete.isEnabled = true
            delete.backgroundColor = UIColor.red
        }else{
            eventLabel.text = "予定なし"
            goView.isHidden = true
            insert.setTitle("登録", for: .normal)
            delete.isEnabled = false
            delete.backgroundColor = UIColor.gray
        }
    }
    //カレンダーの情報を読み込む
    func loadCalendar(){
        DispatchQueue.global().asyncAfter(deadline: .now() + 2) {
            let serverObjects = self.getServerEvents()
            print(serverObjects)
            for (date, event) in serverObjects {
                let stringDate = self.formatter.string(from: date)
                self.eventsFromTheServer[stringDate] = event
            }
            DispatchQueue.main.async {
                self.calendarView.reloadData()
            }
        }
        selected(date: Date())
        setupCalendarView()
    }
    
    func reloadViews() {
        loadCalendar()
        loadView()
        viewDidLoad()
    }
    
    //削除ボタンのアラートをOK押した時の処理
    func okButton(){
        var date:String = (self.selectedDate.text!).replacingOccurrences(of: "年", with: " ")
        date = date.replacingOccurrences(of: "月", with: " ")
        date = date.replacingOccurrences(of: "日", with: "")
        
        let realm = try! Realm()
        let results = realm.objects(plans.self).filter("date == '" + date + "'")
        try! realm.write {
            realm.delete(results)
        }
        self.eventsFromTheServer.removeAll()
        self.loadView()
        self.viewDidLoad()
    }
    
    func DatePicker(){
        datePicker.datePickerMode = .time
        datePicker.locale = Locale(identifier: "ja")
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja")
        formatter.dateFormat = "HH:mm"
        datePicker.date = formatter.date(from: "00:00")!
        timeInsert.inputView = datePicker
        // UIToolbarを設定
        let toolbar = UIToolbar()
        toolbar.sizeToFit()
        // Doneボタンを設定(押下時doneClickedが起動)
        let doneButton = UIBarButtonItem(barButtonSystemItem: .done, target: nil, action: #selector(doneClicked1))
        // Doneボタンを追加
        toolbar.setItems([doneButton], animated: true)
        timeInsert.inputAccessoryView = toolbar
    }
    
    func weekInsert(){
        let cal = Calendar.current
        //guard let nowMonth = cal.date(from: DateComponents(year: 2019, month: 2, day: 1)) else { return }
        var Day = cal.dateComponents([.year, .month, .day, .weekday], from: Date())
        //年月をformatする
        let year = yearLabel.title!
        Day.year = Int(String(year.prefix(4)))
        Day.month = Int(String(year[year.index(year.startIndex, offsetBy: 5)..<year.index(year.startIndex, offsetBy: 7)]))
        var date = Calendar.current.date(from: Day)!
        
        for i in 1 ... lastDay(date: date) {
            Day.day = i
            date = Calendar.current.date(from: Day)!
            
            if date.weekday.hasPrefix(sunSat) {
                 print("format:",formatter.string(from: date),date.weekday)
                formatter.dateFormat = "yyyy MM dd"
                let insertDate = formatter.string(from: date)
                formatter.dateFormat = "HH:mm"
                let insertLimit = formatter.string(from: dp.date)
                insertSetting(sLimit: insertLimit, sDate: insertDate)
            }
        }
        showAndLoad()
        let firstDay = Calendar.current.date(from: Day)!
        let str = formatter.string(from: firstDay)
   
        print("firstDay:",str)
        print("firstDayWeek:" + firstDay.weekday,firstDay)
    }
    
    @objc func doneClicked1(){
        formatter.dateFormat = "HH:mm"
        timeInsert.text = formatter.string(from: datePicker.date)
        // キーボードを閉じる
        self.view.endEditing(true)
    }
    
    func lastDay(date:Date) -> Int{
        var components = Calendar.current.dateComponents([.year, .month, .day], from:Date())
        let range = Calendar.current.range(of: .day, in: .month, for: date)
      
        components.day = range?.count
        let lastDate = Calendar.current.date(from: components)!
        formatter.dateFormat = "yyyy MM dd"
        let str = formatter.string(from: lastDate)
        print("date",date)
        print("str:",str)
        print("count:",Int(str.suffix(2))!)
        return Int(str.suffix(2))!
    }
}

extension ViewController: UIPickerViewDelegate, UIPickerViewDataSource {
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // PickerViewの列数
    func numberOfComponentsInPickerView(pickerView: UIPickerView) -> Int {
        return 1
    }
    
    // PickerViewの行数
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return items.count
    }
    
    // PickerViewの項目
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return items[row]
    }
    
    func pickerView(_ pickerView: UIPickerView, didSelectRow row: Int, inComponent component: Int) {
        sunSat = items[row]
    }
}


//カレンダー関連
extension ViewController: JTAppleCalendarViewDataSource,JTAppleCalendarViewDelegate{
    //カレンダーの範囲を選択
    func configureCalendar(_ calendar: JTAppleCalendarView) -> ConfigurationParameters {
        formatter.dateFormat = "yyyy MM dd"
        let startDate = formatter.date(from: "2019 03 01")!
        let endDate = formatter.date(from: "2020 03 31")!
        let parameters = ConfigurationParameters(startDate: startDate, endDate: endDate)
        return parameters
    }
    //選択されている年月の表示
    func setupViewOfCalendar(from visibleDates: DateSegmentInfo){
        let date = visibleDates.monthDates.first!.date
        formatter.dateFormat = "yyyy年MM月"
       
        print(formatter.string(from: date))
        var yearStr = formatter.string(from: date)
        if yearStr == "" {
            yearStr = ""
        }
        yearLabel.title = yearStr
    }
    //カレンダーの状態（今日、選択、非選択）に関する設定
    func configureCell(view: JTAppleCell?, cellState: CellState){
        guard let myCustomCell = view as? CustomCell else { return }
        //dayの色を状態毎に設定
        formatter.dateFormat = "yyyy MM dd"
        if formatter.string(from: Date()) == formatter.string(from: cellState.date){
            //今日の日付の設定
            myCustomCell.dateLabel.textColor = UIColor.black
            myCustomCell.todayView.isHidden = false
        }else{
            //今日以外で、選択・非選択で色を変更
            myCustomCell.dateLabel.textColor = cellState.isSelected ? UIColor.black : UIColor.black
            myCustomCell.todayView.isHidden = true
        }
        //該当しない月の日は非表示にする
        myCustomCell.isHidden = cellState.dateBelongsTo == .thisMonth ? false : true
        //イベントが存在する時ドットを設置
        myCustomCell.EventDotView.isHidden = !eventsFromTheServer.contains{ $0.key == formatter.string(from: cellState.date)} ? true : false
        print(eventsFromTheServer)
        //print(cellState.date,eventsFromTheServer.contains{ $0.key == formatter.string(from: cellState.date)})
        //状態に応じて表示非表示を行う
        myCustomCell.selectedView.isHidden = cellState.isSelected ? false : true
        if myCustomCell.selectedView.isHidden == false {
            selected(date: cellState.date)
        }
    }

    func calendar(_ calendar: JTAppleCalendarView, cellForItemAt date: Date, cellState: CellState, indexPath: IndexPath) -> JTAppleCell {
        let cell = calendar.dequeueReusableCell(withReuseIdentifier: "CustomCell", for: indexPath) as! CustomCell
        configureCell(view: cell, cellState: cellState)
        cell.dateLabel.text = cellState.text
        return cell
    }
    //選択時の日付
    func calendar(_ calendar: JTAppleCalendarView, didSelectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
          configureCell(view: cell, cellState: cellState)
    }
    //未選択時の日付
    func calendar(_ calendar: JTAppleCalendarView, didDeselectDate date: Date, cell: JTAppleCell?, cellState: CellState) {
         configureCell(view: cell, cellState: cellState)
    }
    func calendar(_ calendar: JTAppleCalendarView, didScrollToDateSegmentWith visibleDates: DateSegmentInfo) {
       setupViewOfCalendar(from: visibleDates)
    }
    func calendar(_ calendar: JTAppleCalendarView, willDisplay cell: JTAppleCell, forItemAt date: Date, cellState: CellState, indexPath: IndexPath) {
        let myCustomCell = cell as! CustomCell
        myCustomCell.dateLabel.text = cellState.text
    }
    func setupCalendarView(){
        calendarView.minimumLineSpacing = 0
        calendarView.minimumInteritemSpacing = 0
        calendarView.visibleDates{ (visibleDates) in
            self.setupViewOfCalendar(from: visibleDates)
        }
    }
}

extension Date {
    var weekday: String {
        let calendar = Calendar(identifier: .gregorian)
        let component = calendar.component(.weekday, from: self)
        let weekday = component - 1
        let formatter = DateFormatter()
        formatter.locale = Locale(identifier: "ja")
        return formatter.weekdaySymbols[weekday]
    }
}
