//
//  SignUpViewController.swift
//  npButton
//
//  Created by 浅田智哉 on 2022/05/23.
//

import UIKit
import NCMB
import KRProgressHUD

class SignUpViewController: UIViewController,UITextFieldDelegate {
    
    @IBOutlet var userIdTextField: UITextField!
    @IBOutlet var emailTextField: UITextField!
    @IBOutlet var passwordTextField: UITextField!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        userIdTextField.delegate = self
        emailTextField.delegate = self
        passwordTextField.delegate = self

        // Do any additional setup after loading the view.
    }
    
    func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    
    
    @IBAction func signUp() {
        let user = NCMBUser()
        
        user.userName = userIdTextField.text!
        user.mailAddress = emailTextField.text!
        
        user.password = passwordTextField.text!
        
        user.signUpInBackground { (error) in
            if error != nil{
                KRProgressHUD.showError(withMessage: "登録に失敗しました")

            }else{
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
