//
//  ClockTableViewCell.swift
//  pami
//
//  Created by Pawel  on 2018-06-12.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class ClockTableViewCell: UITableViewCell {

    @IBOutlet weak var name: UILabel!
    @IBOutlet weak var time: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
