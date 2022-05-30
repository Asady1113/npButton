//
//  TeacherViewController.swift
//  npButton
//
//  Created by 浅田智哉 on 2022/05/23.
//

import UIKit
import NCMB
import KRProgressHUD

class TeacherViewController: UIViewController,UITableViewDataSource,UITableViewDelegate {

    
    var classArray = [NCMBObject]()
    
    @IBOutlet var classNameTableView : UITableView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        
        loadClass()

        // Do any additional setup after loading the view.
        classNameTableView.dataSource = self
        classNameTableView.delegate = self
    }
    

    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        
        classArray.count
    }
   
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "classCell")!
        
        let classLabel = cell.viewWithTag(1) as! UILabel
        
        classLabel.text = classArray[indexPath.row].object(forKey: "className") as! String
        
        return cell
        
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        
        self.performSegue(withIdentifier: "toStudentList", sender: nil)
        
        tableView.deselectRow(at: indexPath, animated: true)
        
    }
    
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    
        let studentListViewController = segue.destination as! StudentListViewController
        let selectedIndex = classNameTableView.indexPathForSelectedRow!
        studentListViewController.selectedClass = classArray[selectedIndex.row]
    }
    
    
    
    func loadClass() {
        let query = NCMBQuery(className: "Class")
        
        query?.findObjectsInBackground({ result, error in
            if error != nil {
                KRProgressHUD.showError(withMessage: "読み込み失敗")
            } else {
                self.classArray = result as! [NCMBObject]
            }
            
            self.classNameTableView.reloadData()
        })
    }
    
    
    @IBAction func logOut(){
        let alertController = UIAlertController(title: nil, message: "ログアウトしますか？", preferredStyle: .actionSheet)
        let signOutAction = UIAlertAction(title: "ログアウト", style: .default) { (action) in
                    NCMBUser.logOutInBackground { (error) in
                        if error != nil{
                            KRProgressHUD.showMessage("ログアウトに失敗しました")
                          
                        }else{
                            let storyboard = UIStoryboard(name: "SignIn", bundle: Bundle.main)
                            let rootViewController = storyboard.instantiateViewController(identifier: "SignInNavigationController")
                            UIApplication.shared.keyWindow?.rootViewController = rootViewController
                   
                            let ud = UserDefaults.standard
                            ud.set("", forKey: "isLogin")
                            ud.synchronize()
                        }
                    }
                }
                let cancelAction = UIAlertAction(title: "キャンセル", style: .cancel) { (action) in
                    alertController.dismiss(animated: true, completion: nil)
                }
                
                alertController.addAction(signOutAction)
                alertController.addAction(cancelAction)
                self.present(alertController, animated: true, completion: nil)
            }

    
}
