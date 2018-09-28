//
//  ContactTableViewCell.swift
//  pami
//
//  Created by Pawel  on 2018-06-09.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class ContactTableViewCell: UITableViewCell {

    @IBOutlet weak var contactRect: UIView!
    @IBOutlet weak var phoneLabel: UILabel!
    @IBOutlet weak var emailLabel: UILabel!
    
    @IBOutlet weak var emailBtn: UIButton!
    @IBOutlet weak var phoneBtn: UIButton!
    @IBOutlet weak var nameLabel: UILabel!
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    @IBAction func onPhoneNrClicked(_ sender: UIButton) {
        guard let number = sender.title(for: .normal) else {return}
        let url = URL(string: "tel://\(number)")
        
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    @IBAction func onEmailClicked(_ sender: UIButton) {
        
        guard let number = sender.title(for: .normal) else {return}
        let url = URL(string: "mail://\(number)")
      
        UIApplication.shared.open(url!, options: [:], completionHandler: nil)
    }
    
}
