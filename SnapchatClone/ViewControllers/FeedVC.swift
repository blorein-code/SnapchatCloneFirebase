//
//  FeedVC.swift
//  SnapchatClone
//
//  Created by Berke Topcu on 15.11.2022.
//

import UIKit
import FirebaseAuth
import FirebaseFirestore
import FirebaseCore

class FeedVC: UIViewController {

    
    let fireStoreDatabase = Firestore.firestore()
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        
        getUserInfo()
    }
    

    func getUserInfo() {
        /*
         Kullanıcı adı bilgisini alabilmek için Firestore içinde oluşturduğumuz UserInfo collection içerisinden
         email bilgisini çektik
         */
        fireStoreDatabase.collection("UserInfo").whereField("email", isEqualTo: Auth.auth().currentUser!.email!).getDocuments { snapshot, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    for document in snapshot!.documents {
                        if let userName =  document.get("username") as? String {
                            UserSingleton.sharedUserInfo.email = Auth.auth().currentUser!.email!
                            UserSingleton.sharedUserInfo.username = userName
                        }
                    }
                }
            }
        }
    }
    
    func makeAlert(titleInput:String, messageInput:String) {
        let alert = UIAlertController(title: titleInput, message: messageInput, preferredStyle: UIAlertController.Style.alert)
        let button = UIAlertAction(title: "OK", style: UIAlertAction.Style.default, handler: nil)
        alert.addAction(button)
        self.present(alert, animated: true, completion: nil)
    }
    
}
