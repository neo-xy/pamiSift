//
//  Shift.swift
//  pami
//
//  Created by Pawel  on 2018-06-06.
//  Copyright © 2018 pami. All rights reserved.
//

import Foundation


struct Shift{
    var OBhours:Double = 0.0,
    OBmoney = 0,
    OBnattHours = 0.0,
    OBnattMoney = 0,
    basePay = 0,
    brutto = 0,
    department = Department(),
    duration = 0.0,
    employeeId = "",
    employeeSalary = 0,
    employmentType = "",
    startDate = Date(),
    endDate = Date(),
    firstName = "",
    lastName = "",
    holidayCompensation = 0,
    message = "",
    netto = 0,
    shiftStatus = "",
    tax = 0,
    timeStemp = 0,
    timeStempIn = 0,
    timeStempOut = 0,
    vat = 0,
    shiftId = "",
    messageIn = "",
    messageOut = ""
    
    
}
struct Department{
    var color = "",
    id = ""
}
