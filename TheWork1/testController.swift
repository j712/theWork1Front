import UIKit

class testController: UIViewController {

    @IBOutlet weak var resultLabel1: UILabel!
    @IBOutlet weak var text1: UITextField!
    @IBOutlet weak var text2: UITextField!
    
    @IBAction func onTap(_ sender: Any) {
        if text1.text != "" && text2.text != "" {
            let title = text1.text!
            let note  = text2.text!
            
            let stringUrl = "http://ec2-18-216-191-59.us-east-2.compute.amazonaws.com/b.php?title=\(title)&note=\(note)"
            print(stringUrl)
            // Swift4からは書き方が変わりました。
            let url = URL(string: stringUrl.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)!)!
            let req = URLRequest(url: url)
            
            let task = URLSession.shared.dataTask(with: req, completionHandler: {
                (data, res, err) in
                if data != nil {
                    let text = NSString(data: data!, encoding: String.Encoding.utf8.rawValue)
                    DispatchQueue.main.async(execute: {
                        self.resultLabel1.text = text as String?
                    })
                }else{
                    DispatchQueue.main.async(execute: {
                        self.resultLabel1.text = "ERROR"
                    })
                }
            })
            task.resume()
        }else{
            // 未入力
            alert("error", messageString: "It is not entered.", buttonString: "OK")
        }
    }
    
    // 標準のアラートを表示させる
    func alert(_ titleString: String, messageString: String, buttonString: String){
        //Create UIAlertController
        let alert: UIAlertController = UIAlertController(title: titleString, message: messageString, preferredStyle: .alert)
        //Create action
        let action = UIAlertAction(title: buttonString, style: .default) { action in
            NSLog("\(titleString):Push button!")
        }
        //Add action
        alert.addAction(action)
        //Start
        present(alert, animated: true, completion: nil)
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool{
        //Close keyboard.
        textField.resignFirstResponder()
        
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
}
