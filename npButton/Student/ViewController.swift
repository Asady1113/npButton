//
//  ViewController.swift
//  npButton
//
//  Created by 浅田智哉 on 2022/05/23.
//

import UIKit
import NCMB
import KRProgressHUD

class ViewController: UIViewController {
    
    var selectedClass : NCMBObject!
    var npInfo = [NCMBObject]()
    
    @IBOutlet var countLabel : UILabel!
    @IBOutlet var npButton : UIButton!
    @IBOutlet var studentNameLabel : UILabel!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        studentNameLabel.text = NCMBUser.current().userName
        
    }
    
    @IBAction func didTapNPbutton() {
        np()
        
    }

    
    @objc private func timerUpdate() {
      // 30秒後に実行したい処理を記述
        reset()
    }
    
    //30秒後復活関数
    func reset() {
        
        for object in npInfo {
            object.setObject(false, forKey: "isNP")
            
            object.saveInBackground { error in
                if error != nil {
                    KRProgressHUD.showError(withMessage: "ボタンエラー")
                } else {
                    //リセット完了
                    self.npButton.isHidden = false
                }
            }
        }
        
    }
    
    //意見ないよ関数
    func np() {
        let query = NCMBQuery(className: "studentList")
        query?.whereKey("joinClass", equalTo: selectedClass.objectId)
        query?.whereKey("student", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ result, error in
            if error != nil {
                KRProgressHUD.showError(withMessage: "ボタンエラー")
            } else {
                
                self.npInfo = result as! [NCMBObject]
                
                for object in self.npInfo {
                    
                    let npCount = object.object(forKey: "npCount") as! Int
                    let newNPCount = npCount + 1
                    
                    object.setObject(true, forKey: "isNP")
                    object.setObject(newNPCount, forKey: "npCount")
                    
                    object.saveInBackground { error in
                        if error != nil {
                            KRProgressHUD.showError(withMessage: "ボタンエラー")
                        } else {
                            //ボタン完了
                            
                            self.countLabel.text = String(newNPCount)
                            Timer.scheduledTimer(timeInterval: 10, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: false)

                            self.npButton.isHidden = true
                        }
                    }
                }
                
            }
        })
        
    }
    
    
    
    //クラス退出
    @IBAction func out() {
        let query = NCMBQuery(className: "studentList")
        
        query?.whereKey("joinClass", equalTo: selectedClass.objectId)
        query?.whereKey("student", equalTo: NCMBUser.current())
        
        query?.findObjectsInBackground({ result, error in
            if error != nil {
                KRProgressHUD.showError(withMessage: "退出失敗")
            } else {
                
                for object in result as! [NCMBObject] {
                    object.deleteInBackground { error in
                        if error != nil {
                            KRProgressHUD.showError(withMessage: "退出失敗")
                        } else {
                            KRProgressHUD.showSuccess(withMessage: "退出完了")
                            self.dismiss(animated: true)
                        }
                    }
                    
                }
                
            }
            
        })
        
    }
    
}

