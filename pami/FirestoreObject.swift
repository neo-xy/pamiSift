//
//  FirestoreObject.swift
//  pami
//
//  Created by Pawel  on 2018-06-04.
//  Copyright © 2018 pami. All rights reserved.
//

import Foundation
import Firebase
import FirebaseFirestore


class FirestoreObject: NSObject{
    let snapshot: DocumentSnapshot.self
    var key: String{return snapshot.key}
    
}
