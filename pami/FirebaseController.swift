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
                user.employeeId = id!
                
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
    
    static func getUserShifts() -> Observable<[Shift]>{
        return Observable.create({ (sub) -> Disposable in
            Firestore.firestore().collection("users").document(self.user.employeeId).collection("shifts").addSnapshotListener({ (snapshot, error) in
                var shifts:[Shift] = []
                
                for snap:QueryDocumentSnapshot in snapshot!.documents{
                    var shift = Shift()
                    
                    shift.firstName = snap.data()["firstName"] as! String
                    shift.lastName = snap.get("lastName") as! String
                    shift.OBhours = snap.get("OBhours") as! Double
                    shift.OBmoney = snap.get("OBmoney") as! Double
                    shift.OBnattHours = snap.get("OBnattHours") as! Double
                    shift.OBnattMoney = snap.get("OBnattMoney") as! Double
                    shift.basePay = snap.get("basePay") as! Int
                    shift.brutto = snap.get("brutto") as! Int
                    shift.duration = snap.get("duration") as! Double
                    shift.employeeId = snap.get("employeeId") as! String
                    shift.employeeSalary = snap.get("employeeSalary") as! Int
                    shift.employmentType =  snap.get("employmentType") as! String
                    shift.endDate = (snap.get("endDate") as! Timestamp).dateValue()
                    shift.startDate = (snap.get("startDate") as! Timestamp).dateValue()
                    shift.holidayCompensation = snap.get("holidayCompensation") as! Int
                    shift.message = snap.get("message") as! String
                    shift.netto = snap.get("netto") as! Int
                    shift.shiftStatus = snap.get("shiftStatus") as! String
                    shift.shiftId =  snap.documentID as! String
                    var department = Department()
                    department.color = ((snap.data()["department"] as!  NSMutableDictionary).value(forKey: "color")) as! String
                    department.id = ((snap.data()["department"] as!  NSMutableDictionary).value(forKey: "id")) as! String
                    
                    shift.department = department
                    shifts.append(shift)
                }
                sub.onNext(shifts)
            })
            return Disposables.create()
        })
    }
    
}
