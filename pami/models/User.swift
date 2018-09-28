//
//  User.swift
//  pami
//
//  Created by Pawel  on 2018-06-03.
//  Copyright © 2018 pami. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore

struct User {
    var firstName = "",
    lastName = "",
    employeeId = "",
    city = "",
    email = "",
    salaries = [Salary](),
    datesUnavailable = [Int](),
    imgUrl = "",
    employmentStatus = "",
    companyId = "",
    address = "",
    accountNr = "",
    bankName = "",
    clearNr = "",
    role = 1,
    phoneNumber = "",
    socialSecurityNumber = "",
    companyName = ""
    
//    init(firstNam:String, lastNam:String) {
//        self.firstName = firstNam
//        self.lastName = lastNam
//    }
}

struct Salary{
   var employeeId = "",
    duration = 0,
    month = 0,
    year = 0,
    total = 0,
    salary = 0

}

enum RoleType:Int {
    case Boss = 0
    case Employee
    case Accountant
}
