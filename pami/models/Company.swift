//
//  Company.swift
//  pami
//
//  Created by Pawel  on 2018-06-05.
//  Copyright © 2018 pami. All rights reserved.
//

import Foundation

struct Company{
    var locationType:Int=0
    var gpsLocation: PamiLocation = PamiLocation()

}

struct PamiLocation{
    
    var address:String = ""
    var latitude:Double = 0.0
    var longitude:Double = 0.0
    
}
