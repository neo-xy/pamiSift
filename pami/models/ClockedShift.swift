//
//  ClockedShift.swift
//  pami
//
//  Created by Pawel  on 2018-06-12.
//  Copyright © 2018 pami. All rights reserved.
//

import Foundation

struct ClockedShift{
    var employeeId = "",
    firstName = "",
    lastName = "",
    clockedShiftId = "",
    messageIn = "",
    messageOut = "",
    startDate = Date(),
    endDate = Date(),
    logs :[ShiftLog] = []
   
    
}


struct ShiftLog{
    var startDate:Date = Date(),
    endDate:Date = Date(),
    bossId:String = "",
    bossFirstName = "",
    bossLastName = "",
    message = "",
    date:Date = Date(),
    shiftStatus = 1,
    bossSocialNumber = ""
}

