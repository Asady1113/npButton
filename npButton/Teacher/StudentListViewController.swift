//
//  StudentListViewController.swift
//  npButton
//
//  Created by 浅田智哉 on 2022/05/23.
//

import UIKit
import NCMB
import KRProgressHUD

class StudentListViewController: UIViewController,UITableViewDataSource {
    
    var selectedClass : NCMBObject!
    
    var studentList = [NCMBUser]()
    var countArray = [Int]()
    
    @IBOutlet var studentTableView : UITableView!

    override func viewDidLoad() {
        super.viewDidLoad()

        
        print(selectedClass)
        studentTableView.dataSource = self
        loadStudent()
     
        // Do any additional setup after loading the view.
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
      
        return studentList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "studentCell")!
        let studentLabel = cell.viewWithTag(1) as! UILabel
        let countLabel = cell.viewWithTag(2) as! UILabel
        
        studentLabel.text = studentList[indexPath.row].userName
        countLabel.text = String(countArray[indexPath.row])
        
        return cell
        
    }
    
    func reload() {
        Timer.scheduledTimer(timeInterval: 1, target: self, selector: #selector(self.timerUpdate), userInfo: nil, repeats: false)
    }
    
    @objc private func timerUpdate() {
      // 30秒後に実行したい処理を記述
        loadStudent()
      
    }
    
    func loadStudent() {
        
        studentList = [NCMBUser]()
        countArray = [Int]()
        
        let query = NCMBQuery(className: "studentList")
        query?.includeKey("student")
        query?.whereKey("joinClass", equalTo: selectedClass.objectId)
        query?.whereKey("isNP", notEqualTo: true)
        
        
        query?.findObjectsInBackground({ result, error in
            if error != nil {
                KRProgressHUD.showError(withMessage: "読み込み失敗")
            } else {
                
                for object in result as! [NCMBObject] {
                    let student = object.object(forKey: "student") as! NCMBUser
                    let count = object.object(forKey: "npCount") as! Int
                    
                    self.countArray.append(count)
                    self.studentList.append(student)
                }
            }
            self.studentTableView.reloadData()
            self.reload()
        })
        
    }
    

}
