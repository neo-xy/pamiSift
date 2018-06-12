//
//  InterestsTableViewCell.swift
//  pami
//
//  Created by Pawel  on 2018-06-11.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class InterestsTableViewCell: UITableViewCell {


    @IBOutlet weak var switcher: UISwitch!
    @IBOutlet weak var departmentLabel: UILabel!
    @IBOutlet weak var timeLabel: UILabel!
    @IBOutlet weak var dateLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    

}
