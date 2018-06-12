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
    static var employees:[User] = []
    static var shiftsToTake:[ShiftToTake] = []
    
    
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
                user.address = snapshot?.get("address") as! String
                user.phoneNumber = snapshot?.get("phoneNumber") as! String
                user.accountNr = snapshot?.get("accountNr") as! String
                user.bankName = snapshot?.get("bankName") as! String
                user.socialSecurityNumber = snapshot?.get("socialSecurityNumber") as! Int
                user.email = snapshot?.get("email") as! String
                user.employeeId = id!
                
                self.getEmployees()
                
                
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
                    shift.OBmoney = snap.get("OBmoney") as! Int
                    shift.OBnattHours = snap.get("OBnattHours") as! Double
                    shift.OBnattMoney = snap.get("OBnattMoney") as! Int
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
                    shift.shiftId =  snap.documentID
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
    
    static func getAcceptedShifts() -> Observable<[Shift]>{
        return  Observable.create { (sub) -> Disposable in
            Firestore.firestore().collection("users").document(user.employeeId).collection("acceptedShifts").addSnapshotListener({ (snapshot, error) in
                
                var shifts:[Shift] = []
                
                for snap:QueryDocumentSnapshot in snapshot!.documents{
                    var shift = Shift()
                    
                    shift.firstName = (snap.data()["firstName"] ?? "") as! String
                    shift.lastName = (snap.get("lastName") ?? "") as! String
                    shift.OBhours = snap.get("OBhours") as! Double
                    shift.OBmoney = snap.get("OBmoney") as! Int
                    shift.OBnattHours = snap.get("OBnattHours") as! Double
                    shift.OBnattMoney = snap.get("OBnattMoney") as! Int
                    shift.basePay = snap.get("basePay") as! Int
                    shift.brutto = snap.get("brutto") as! Int
                    shift.duration = snap.get("duration") as! Double
                    shift.employeeId = snap.get("employeeId") as! String
                    shift.employeeSalary = snap.get("employeeSalary") as! Int
                    shift.employmentType =  (snap.get("employmentType") ?? "" )as! String
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
        }
        
    }
    
    static func getEmployees() {
        Firestore.firestore().collection("companies").document(self.user.companyId).collection("employees").addSnapshotListener({ (snapshots, error) in
            
            for snapshot:QueryDocumentSnapshot in snapshots!.documents{
                var user = User()
                user.firstName = snapshot.get("firstName") as! String
                user.lastName = snapshot.get("lastName") as! String
                user.phoneNumber = snapshot.get("phoneNumber") as! String
                user.email = snapshot.get("email") as! String
                user.role = snapshot.get("role") as! String
                employees.append(user)
            }
        })
    }
    
    static func getShiftsToTake() -> Observable<[ShiftToTake]>{
        return Observable.create { (sub) -> Disposable in Firestore.firestore().collection("companies").document(user.companyId).collection("shiftsToTake").addSnapshotListener({ (snapshots, error) in
            
            var shiftsToTake:[ShiftToTake] = []
            for snapshot in snapshots!.documents{
                var shift = ShiftToTake()
                shift.date = (snapshot.get("date") as! Timestamp).dateValue()
                shift.startDate = (snapshot.get("startDate") as! Timestamp).dateValue()
                shift.endDate = (snapshot.get("endDate") as! Timestamp).dateValue()
                shift.departmentName = snapshot.get("departmentName") as! String
                shift.id = snapshot.documentID
                shiftsToTake.append(shift)
            }
            sub.onNext(shiftsToTake)
        })
            
            return Disposables.create()
        }
    }
    
    static func setUpShiftsToTake() {
        Firestore.firestore().collection("companies").document(user.companyId).collection("shiftsToTake").addSnapshotListener({ (snapshots, error) in
            
            var shiftsToTake:[ShiftToTake] = []
            for snapshot in snapshots!.documents{
                var shift = ShiftToTake()
                shift.date = (snapshot.get("date") as! Timestamp).dateValue()
                shift.startDate = (snapshot.get("startDate") as! Timestamp).dateValue()
                shift.endDate = (snapshot.get("endDate") as! Timestamp).dateValue()
                shift.departmentName = snapshot.get("departmentName") as! String
                shift.id = snapshot.documentID
                shiftsToTake.append(shift)
            }
            self.shiftsToTake =  shiftsToTake
            print("to take \(shiftsToTake.count)")
        })
    }
    
    static func getInterests() -> Observable<[Interest]>{
        return  Observable.create { (obs) -> Disposable in
            Firestore.firestore().collection("companies").document(user.companyId).collection("interests").addSnapshotListener({ (snapshots, error) in
                var interests:[Interest] = []
                for snapshot in snapshots!.documents{
                    var interest = Interest()
                    interest.dateAdded = (snapshot.get("dateAdded") as! Timestamp).dateValue()
                    interest.department = snapshot.get("department") as! String
                    interest.employeeId = snapshot.get("employeeId") as! String
                    interest.startDate = (snapshot.get("startDate") as! Timestamp).dateValue()
                    interest.endDate = (snapshot.get("endDate") as! Timestamp).dateValue()
                    interest.shiftToTakeId = snapshot.get("shiftToTakeId") as! String
                    interest.interestId = snapshot.documentID
                    
                    interests.append(interest)
                    
                }
                obs.onNext(interests)
                print("eee \(interests.count)")
            })
            return Disposables.create()
        }
    }
    
    static func addInterest(interest:[String:Any]){
        Firestore.firestore().collection("companies").document(user.companyId).collection("interests").addDocument(data: interest) { (error) in
            
        }
    }
    
    static func removeInterest(id:String){
        Firestore.firestore().collection("companies").document(user.companyId).collection("interests").document(id).delete()
    }
    
    static func getActiveShifts() -> Observable<[ClockedShift]>{
        return Observable.create { (sub) -> Disposable in
            Firestore.firestore().collection("companies").document(user.companyId)
                .collection("activeShifts").addSnapshotListener({ (snapshots, error) in
                    
                    var activeShifts:[ClockedShift] = []
                    for snapshot in (snapshots?.documents)!{
                        var clockShift = ClockedShift()
                        clockShift.clockedShiftId = snapshot.documentID
                        print(snapshot.documentID)
                        clockShift.employeeId =  snapshot.get("employeeId") as! String
                        clockShift.firstName = snapshot.get("firstName") as! String
                        clockShift.lastName = snapshot.get("lastName") as! String
                        clockShift.timeStempIn = snapshot.get("timeStempIn") as! CLong
                        clockShift.messageIn = snapshot.get("messageIn") as!String
                        
                        activeShifts.append(clockShift)
                    }
                    sub.onNext(activeShifts)
                    
                })
            return Disposables.create()
        }
    }
    static func clockOutShift(clockShift:ClockedShift){
        print("clockoutshift \(clockShift.clockedShiftId)")
        Firestore.firestore().collection("companies").document(user.companyId).collection("activeShifts").document(clockShift.clockedShiftId).delete { (error) in
            if(error == nil){
                  addToShiftToAccept(shift: clockShift)
            }
        }
    }
    
    static func clockInShift(clockInShift:ClockedShift){
        let doc:[String : Any] = ["employeeId":clockInShift.employeeId, "firstName":clockInShift.firstName, "lastName":clockInShift.lastName, "messageIn":clockInShift.messageIn, "timeStempIn":clockInShift.timeStempIn]
        
        print("rr \(doc)")
        Firestore.firestore().collection("companies").document(user.companyId)
            .collection("activeShifts").addDocument(data: doc)
    }
    
    static func addToShiftToAccept(shift:ClockedShift){
        let doc:[String:Any] = ["employeeId":user.employeeId, "firstName":shift.firstName, "lastName":shift.lastName, "messageIn":shift.messageIn, "messageOut":shift.messageOut, "timeStempIn":shift.timeStempIn, "timeStempOut":shift.timeStempOut]
        Firestore.firestore().collection("companies").document(user.companyId).collection("shiftsToAccept").addDocument(data: doc)
    }
    
}
