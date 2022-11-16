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
import SDWebImage


class FeedVC: UIViewController, UITableViewDelegate, UITableViewDataSource {

    
    let fireStoreDatabase = Firestore.firestore()
    var snapArray = [Snap]()
    var chosenSnap : Snap?
    
    @IBOutlet weak var tableView: UITableView!
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        tableView.delegate = self
        tableView.dataSource = self
        
        getSnapsFromFireBase()
        getUserInfo()
        
    }
    
    
    func getSnapsFromFireBase() {
        fireStoreDatabase.collection("Snaps").order(by: "date", descending: true).addSnapshotListener { snapshot, error in
            if error != nil {
                self.makeAlert(titleInput: "Error", messageInput: error?.localizedDescription ?? "Error")
            } else {
                if snapshot?.isEmpty == false && snapshot != nil {
                    
                    self.snapArray.removeAll(keepingCapacity: false)
                    
                    for document in snapshot!.documents {
                        
                        let documentId = document.documentID
                        
                        if let username = document.get("snapOwner") as? String {
                            if let imageUrlArray = document.get("imageUrlArray") as? [String] {
                                if let date = document.get("date") as? Timestamp {
                                    //Snap'in ilk atıldığı zamandan bu zamana ne kadar saat geçtiğini görmek için yani kaç saat kaldığını ekrana yazdırabilmek için Calender.Curret.datecomponents(component,from,to) olan fonksiyonu kullandık.
                                    if let timeDifference = Calendar.current.dateComponents([.hour], from: date.dateValue(), to: Date()).hour {
                                        
                                        if timeDifference >= 24 {
                                            //Firebaseden sil.
                                            //24 saati doldurmuşsa siliyoruz.
                                            self.fireStoreDatabase.collection("Snaps").document(documentId).delete()
                                            
                                        } else {
                                            //24 saat dolmamışsa kalan zamanı alıp view da göstericez
                                            //Timeleft -> SnapVC
                                            
                                            
                                            //Snap model içerisindeki time ile current time farkını böyle hesapladık
                                            let snap = Snap(username: username, imageArray: imageUrlArray, date: date.dateValue(), timeDifference: 24 - timeDifference)
                                            
                                            self.snapArray.append(snap)
                                            
                                        }
                                    }
                                    
                                    
                                    
                                }
                            }
                         }
                        
                    }
                    self.tableView.reloadData()
                    
                }
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return snapArray.count
    }
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath) as! FeedCell
        cell.feedUserNameLabel.text = snapArray[indexPath.row].username
        cell.feedImageView.sd_setImage(with: URL(string: snapArray[indexPath.row].imageArray[0]))
        
        return cell
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
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "toSnapVC" {
            
            let destinationVC = segue.destination as! SnapVC
            
            destinationVC.selectedSnap = chosenSnap
          
        }
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        chosenSnap = self.snapArray[indexPath.row]
        performSegue(withIdentifier: "toSnapVC", sender: nil)
    }
    
}
