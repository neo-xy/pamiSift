//
//  salaryTableViewCell.swift
//  pami
//
//  Created by Pawel  on 2018-06-11.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class salaryTableViewCell: UITableViewCell {

    @IBOutlet weak var dayCell: UILabel!
    @IBOutlet weak var startCell: UILabel!
    @IBOutlet weak var endCell: UILabel!
    @IBOutlet weak var durationCell: UILabel!
    @IBOutlet weak var payCell: UILabel!
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
