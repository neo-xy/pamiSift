//
//  UnderlinedTextField.swift
//  pami
//
//  Created by Pawel  on 2018-06-06.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class UnderlinedTextField: UITextField {

    @IBOutlet weak var underlineView: UIView!

    override func awakeFromNib() {
        super.awakeFromNib()
        
        underlineView.backgroundColor = UIColor.lightGray
        
        // Highlight/unhighlight the underlined view when it's being edited.
//        reactive.controlEvents(.editingDidBegin).map { _ in
//            return UIColor.green
//            }.bind(to: underlineView.reactive.backgroundColor).dispose(in: reactive.bag)
//
//        reactive.controlEvents(.editingDidEnd).map { _ in
//            return UIColor.lightGray
//            }.bind(to: underlineView.reactive.backgroundColor).dispose(in: reactive.bag)
        
    }

}
