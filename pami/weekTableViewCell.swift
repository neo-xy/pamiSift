//
//  weekTableViewCell.swift
//  pami
//
//  Created by Pawel  on 2018-06-14.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class weekTableViewCell: UITableViewCell {
    @IBOutlet var name: UILabel!
    @IBOutlet var time: UILabel!
    @IBOutlet var department: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
