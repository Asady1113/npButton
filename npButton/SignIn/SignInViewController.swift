//
//  SignInViewController.swift
//  npButton
//
//  Created by 浅田智哉 on 2022/05/23.
//

import UIKit
import NCMB
import KRProgressHUD

class SignInViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()

        userIdTextField.delegate = self
        passwordTextField.delegate = self
        // Do any additional setup after loading the view.
    }
    

    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    @IBAction func signIn() {
        
        NCMBUser.logInWithUsername(inBackground: userIdTextField.text!, password: passwordTextField.text!) { (user, error) in
            if error != nil{
                KRProgressHUD.showError(withMessage: "サインインに失敗しました")
                
            }else{
                
                if self.userIdTextField.text == "Teacher" && self.passwordTextField.text == "teacher"{
                    
                    let storyboard = UIStoryboard(name: "Teacher", bundle: Bundle.main)
                    let teacherViewController = storyboard.instantiateViewController(identifier: "TeacherViewController")
                    UIApplication.shared.keyWindow?.rootViewController = teacherViewController
                    
                    let ud = UserDefaults.standard
                    ud.set("teacher", forKey: "isLogin")
                    ud.synchronize()

                } else {
                    let storyboard = UIStoryboard(name: "Main", bundle: Bundle.main)
                    let mainViewController = storyboard.instantiateViewController(identifier: "MainViewController")
                    UIApplication.shared.keyWindow?.rootViewController = mainViewController
                    
                    let ud = UserDefaults.standard
                    ud.set("student", forKey: "isLogin")
                    ud.synchronize()

                }
            }
        }
    
    }
   

}
