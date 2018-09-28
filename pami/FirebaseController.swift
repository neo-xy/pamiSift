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
                user.socialSecurityNumber = snapshot?.get("socialSecurityNumber") as! String
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
            Firestore.firestore().collection("users").document(self.user.employeeId).collection("scheduledShifts").addSnapshotListener({ (snapshot, error) in
                var shifts:[Shift] = []
                
                for snap:QueryDocumentSnapshot in snapshot!.documents{
                    var shift = Shift()
                    
                    shift.firstName = snap.data()["firstName"] as! String
                    shift.lastName = snap.get("lastName") as! String
                
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
                    if(snap.get("shiftStatus") != nil){
                        shift.shiftStatus = snap.get("shiftStatus") as! Int
                    }
                    
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
            Firestore.firestore().collection("users").document(user.employeeId).collection("shifts").addSnapshotListener({ (snapshot, error) in
                
                var shifts:[Shift] = []
                
                for snap:QueryDocumentSnapshot in snapshot!.documents{
                    
                    print("status "+String(ShiftStatus.Accepted.rawValue))
                       print("ssss "+String(snap.get("shiftStatus") as! Int))
                    if(snap.get("shiftStatus") as! Int==ShiftStatus.Accepted.rawValue){
                        print("iffff")
                        var shift = Shift()
                        shift.firstName = (snap.data()["firstName"] ?? "") as! String
                        shift.lastName = (snap.get("lastName") ?? "") as! String
                        shift.OBhours = snap.get("OBhours") as? Double ?? 0
                        shift.OBmoney = snap.get("OBmoney") as? Int ?? 0
                        shift.OBnattHours = snap.get("OBnattHours") as? Double ?? 0
                        shift.OBnattMoney = snap.get("OBnattMoney") as? Int ?? 0
                        shift.basePay = snap.get("basePay") as! Int
                        shift.brutto = snap.get("brutto") as! Int
                        shift.duration = snap.get("duration") as! Double
                        shift.employeeId = snap.get("employeeId") as! String
                        shift.employeeSalary = snap.get("employeeSalary") as! Int
                        shift.employmentType =  (snap.get("employmentType") ?? "" )as! String
                        shift.endDate = (snap.get("endDate") as! Timestamp).dateValue()
                        shift.startDate = (snap.get("startDate") as! Timestamp).dateValue()
                        shift.holidayCompensation = snap.get("holidayCompensation") as! Int
                        shift.message = snap.get("message") as? String ?? ""
                        shift.netto = snap.get("netto") as! Int
                        shift.shiftStatus = snap.get("shiftStatus") as! Int
                        shift.shiftId =  snap.documentID
                        var department = Department()
                        if(snap.data()["department"] as? NSMutableDictionary != nil){
                            department.color = ((snap.data()["department"] as!  NSMutableDictionary).value(forKey: "color")) as! String
                            department.id = ((snap.data()["department"] as!  NSMutableDictionary).value(forKey: "id")) as! String
                        }
                       
                        
                        shift.department = department
                        shifts.append(shift)
                    }
              
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
                user.role = snapshot.get("role") as! Int
              
                
                user.employeeId = snapshot.get("employeeId") as! String
                user.socialSecurityNumber = snapshot.get("socialSecurityNumber") as! String
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
                if(shift.startDate > Date()){
                     shiftsToTake.append(shift)
                }
               
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
                        clockShift.employeeId =  snapshot.get("employeeId") as! String
                        clockShift.firstName = snapshot.get("firstName") as! String
                        clockShift.lastName = snapshot.get("lastName") as! String
                        clockShift.messageIn = snapshot.get("messageIn") as!String
                        clockShift.startDate = (snapshot.get("startDate") as! Timestamp).dateValue()
                        
                        activeShifts.append(clockShift)
                    }
                    sub.onNext(activeShifts)
                    
                })
            return Disposables.create()
        }
    }
    static func clockOutShift(clockShift:ClockedShift){
        Firestore.firestore().collection("companies").document(user.companyId).collection("activeShifts").document(clockShift.clockedShiftId).delete { (error) in

            if(error == nil){
                  addToShiftToAccept(shift: clockShift)
            }
        }
    }
    
    static func clockInShift(clockInShift:ClockedShift){
        let doc:[String : Any] = ["employeeId":clockInShift.employeeId, "firstName":clockInShift.firstName, "lastName":clockInShift.lastName, "messageIn":clockInShift.messageIn, "startDate":clockInShift.startDate]

        Firestore.firestore().collection("companies").document(user.companyId)
            .collection("activeShifts").addDocument(data: doc)
    }
    
    static func addToShiftToAccept(shift:ClockedShift){
        let doc = ["employeeId":user.employeeId, "firstName":shift.firstName, "lastName":shift.lastName, "messageIn":shift.messageIn, "messageOut":shift.messageOut, "startDate":shift.startDate, "endDate":shift.endDate,
                   "logs":[
                    ["startDate":shift.logs[0].startDate,
                        "endDate":shift.logs[0].endDate,
                        "shiftStatus" : shift.logs[0].shiftStatus,
                        "bossId" : shift.logs[0].bossId,
                        "bossFirstName" : shift.logs[0].bossFirstName,
                        "bossLastName" : shift.logs[0].bossLastName,
                        "bossSocialNumber" : shift.logs[0].bossSocialNumber,
                        "date":shift.logs[0].date
                    ]
            ]] as [String : Any]
        
        Firestore.firestore().collection("companies").document(user.companyId).collection("shiftsToAccept").addDocument(data: doc)
        
        
        
    }
    
    static func getEmployeesShiftsOfMonth() -> Observable<[Shift]>{
        return Observable.create({ (sub) -> Disposable in
           Firestore.firestore().collection("companies").document(user.companyId).collection("scheduledShifts").addSnapshotListener({ (snapshots, error) in
                
                var shifts :[Shift] = []
                shifts.removeAll()
                for snap in snapshots!.documents{
                    var shift = Shift()
                    
                    shift.firstName = snap.data()["firstName"] as! String
                    shift.lastName = snap.get("lastName") as! String
                    
                    shift.duration = snap.get("duration") as! Double
                    shift.employeeId = snap.get("employeeId") as! String
                    shift.employeeSalary = snap.get("employeeSalary") as! Int
                    shift.employmentType =  snap.get("employmentType") as! String
                    shift.endDate = (snap.get("endDate") as! Timestamp).dateValue()
                    shift.startDate = (snap.get("startDate") as! Timestamp).dateValue()
                    shift.holidayCompensation = snap.get("holidayCompensation") as! Int
                    shift.message = snap.get("message") as! String
                    if(snap.get("shiftStatus") != nil){
                         shift.shiftStatus = snap.get("shiftStatus") as! Int
                    }
                   
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
    
    static func getUnavailableDates() -> Observable<[UnavailableDate]>{
       return Observable.create { (sub) -> Disposable in        
        Firestore.firestore().collection("users").document(user.employeeId).collection("datesUnavailable").addSnapshotListener({ (snapshots, error) in
            
            var uds: [UnavailableDate] = []
            for snap in (snapshots?.documents)!{
                var ud = UnavailableDate()
                ud.date = (snap.get("date") as! Timestamp).dateValue()
                ud.id = snap.documentID
                ud.employeeId = snap.get("employeeId") as! String
                ud.markDate = (snap.get("markDate") as! Timestamp).dateValue()
                ud.message = snap.get("message") as! String
                uds.append(ud)
            }
            sub.onNext(uds)
        })
            return Disposables.create()
        }
    }
    
    static func addUnavailableDate(ud:UnavailableDate){
        let doc = [
            "employeeId": ud.employeeId,
            "date":ud.date,
            "id":ud.id,
            "markDate":ud.markDate,
            "message":ud.message
            ] as [String : Any]
        Firestore.firestore().collection("companies").document(user.companyId).collection("datesUnavailable").addDocument(data: doc).addSnapshotListener { (snapShot, error) in
            Firestore.firestore().collection("users").document(user.employeeId).collection("datesUnavailable").document((snapShot?.documentID)!).setData(doc)
        }
    }
    
    static func removedUnavailable(id:String){
    Firestore.firestore().collection("companies").document(user.companyId).collection("datesUnavailable").document(id).delete()
    Firestore.firestore().collection("users").document(user.employeeId).collection("datesUnavailable").document(id).delete()
    }
    
    static func getCompany()-> Observable<Company>{
        return Observable.create{ (sub) -> Disposable in
            Firestore.firestore().collection("companies").document(user.companyId).addSnapshotListener({ (snap, error) in
                var address = snap?.get("gpsLocation") as! Any

                var comp:Company = Company()
                
            })
             return Disposables.create()
        }
    }
    
    
    static func getSalariesSpec()->Observable<[SalarySpecification]>{
        return Observable.create{(sub)->Disposable in
            Firestore.firestore().collection("users").document(self.user.employeeId).collection("salarySpec").addSnapshotListener({ (snapshots, error) in
                
                var specifications :[SalarySpecification] = []
                for snap in (snapshots?.documents)! {
                    var spec = SalarySpecification()
                    spec.brutto = snap.get("brutto") as! Int
                    spec.netto = snap.get("netto") as! Int
                    spec.path = snap.get("path") as! String
                    spec.id = snap.documentID
                    specifications.append(spec)
                }
             
                sub.onNext(specifications)
            })
            return Disposables.create()
        }
        
    }
    
    static func getPdf(path:String){
        print("1111")
        let ref = Storage.storage().reference().child(path)
        print(ref)
        
//        ref.getData(maxSize: 1024*1024){data,error in
//            if let error = error{
//
//            }else{
//                let pdf =
//            }
//        }
        
        ref.downloadURL { (url, error) in
          print("2222")
            if(error != nil){
                print(error!)
            }
            
            print("else")
            // Converting string to URL Object
            let urlStr = url?.absoluteString
            let url = URL(string: urlStr!)
            
            // Get the PDF Data form the Url in a Data Object
            let pdfData = try? Data.init(contentsOf: url!)
            
            print(pdfData?.count)
            let resourceDocPath = (FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)).last as! URL
            
            // The New Directory/folder name
            let newPath = resourceDocPath.appendingPathComponent("QMSDocuments")
            
            // Creating the New Directory inside Documents Directory
            do {
                try FileManager.default.createDirectory(atPath: newPath.path, withIntermediateDirectories: true, attributes: nil)
            } catch let error as NSError {
                NSLog("Unable to create directory \(error.debugDescription)")
            }
            
            // Split the url into a string Array by separator "/" to get the pdf name
            let  pdfNameFromUrlArr = "eeee.pdf"
            
            // Appending to the newly created directory path with the pdf name
           let actualPath = newPath.appendingPathComponent(pdfNameFromUrlArr)
            print("rrrr")
            print(actualPath)
        }
    
    }
}
