//
//  ViewController.swift
//  SnapchatClone
//
//  Created by Berke Topcu on 14.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseCore
import FirebaseFirestore


class SignInVC: UIViewController {

    @IBOutlet weak var emailText: UITextField!
    @IBOutlet weak var usernameText: UITextField!
    @IBOutlet weak var passwordText: UITextField!
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        
        
    }

    @IBAction func signInClicked(_ sender: Any) {
        //Kullanıcı var mı kontrolü yaptık varsa giriş yapıldı.
        if emailText.text != "" && passwordText.text != "" {
            Auth.auth().signIn(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else{
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
        } else {
            self.makeAlert(titleInput: "Error", messageInput: "Username/Pass?")
        }
    }
    
    @IBAction func signUpClicked(_ sender: Any) {
        
        if emailText.text != "" && usernameText.text != "" && passwordText.text != "" {
            Auth.auth().createUser(withEmail: emailText.text!, password: passwordText.text!) { authdata, error in
                if error != nil {
                    self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                } else {
                    /* Kullanıcı oluşturulurken kullanıcı adını auth içerisinde tutamadığımız için firestore
                    içerisinde yeni bir collection oluşturup oraya kaydettik.
                     */
                    let fireStore = Firestore.firestore()
                    let userDictionary = ["email" : self.emailText.text, "username" : self.usernameText.text] as [String : Any]
                    fireStore.collection("UserInfo").addDocument(data: userDictionary) { error in
                        if error != nil  {
                            self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
                        }
                    }
                    
                    self.performSegue(withIdentifier: "toFeedVC", sender: nil)
                }
                
            }
        } else {
            self.makeAlert(titleInput: "Error", messageInput: "Email/Username/Password?")
            
        }
    }
    
    
    
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        self.present(alert, animated: true, completion: nil)
        alert.addAction(button)
    }
    
    
}

