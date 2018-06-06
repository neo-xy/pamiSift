//
//  FirebaseController.swift
//  pami
//
//  Created by Pawel  on 2018-06-03.
//  Copyright © 2018 pami. All rights reserved.
//

import Foundation
import Firebase
import FirebaseAuth
import FirebaseFirestore
import RxSwift

class FirebaseController{
    
    static var user = User()
    
    static func setUpUser() -> Observable<Bool>{
        let db = Firestore.firestore()
        let settings = db.settings
        settings.areTimestampsInSnapshotsEnabled = true
        db.settings = settings
        
        let id = Auth.auth().currentUser?.uid
        
        return Observable.create { (sub) -> Disposable in
            Firestore.firestore().collection("users").document(id!).getDocument(completion: { (snapshot, error) in
                user.firstName = snapshot?.data()!["firstName"] as! String
                user.lastName = snapshot?.get("lastName") as! String
                user.imgUrl = snapshot?.get("imgUrl") as! String
                user.companyName = snapshot?.get("companyName") as! String
                user.companyId = snapshot?.get("companyId") as! String
                
                sub.onNext(true)
            })
            return Disposables.create()
        }
    }
    
    static func getInfoMessage() -> Observable<InfoMessage>{
        
        return Observable.create({ (sub) -> Disposable in
            Firestore.firestore().collection("companies").document(self.user.companyId).addSnapshotListener({ (snapshot, error) in
                
                var infoMessage:InfoMessage = InfoMessage()
                
                if ((snapshot?.data()!["infoMessage"]) != nil){
                    let infoMsg = snapshot?.data()!["infoMessage"] as! NSMutableDictionary
                    let fsTimeStemp = infoMsg.value(forKey: "date") as! Timestamp
                    
                    infoMessage.author = infoMsg.value(forKey: "author") as! String
                    infoMessage.message = infoMsg.value(forKey: "message") as! String
                    infoMessage.date = fsTimeStemp.dateValue()
                }
                
                sub.onNext(infoMessage)
            })
            return Disposables.create()
        })
        
    }
    
}
