//
//  UpcommmingShiftRowTableViewCell.swift
//  pami
//
//  Created by Pawel  on 2018-06-07.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class UpcommmingShiftRowTableViewCell: UITableViewCell {

    @IBOutlet weak var dateNrLabel: UILabel!
    @IBOutlet weak var dateMonthLabel: UILabel!
    @IBOutlet weak var shiftTimeSpanLabel: UILabel!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var extraInfoLabel: UILabel!
    @IBOutlet weak var extraInfoMsg: UILabel!
    
    @IBOutlet weak var shiftMark: UIView!
    @IBOutlet weak var viewContainer: UIView!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
