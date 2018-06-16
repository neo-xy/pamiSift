//
//  DayCollectionViewCell.swift
//  pami
//
//  Created by Pawel  on 2018-06-13.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit
import JTAppleCalendar

class DayCollectionViewCell: JTAppleCell {
    @IBOutlet var dayNr: UILabel!
    @IBOutlet weak var currentDayMark: UIView!
    @IBOutlet weak var workDayMark: UIView!
    @IBOutlet weak var notAvailableDay: UIView!
    @IBOutlet weak var dateLabel:UILabel!
    @IBOutlet weak var selectedDate: UIView!
}
