//
//  HomeViewController.swift
//  pami
//
//  Created by Pawel  on 2018-06-06.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class HomeViewController: UIViewController {

    @IBOutlet weak var infoMessageLabel: UILabel!
    @IBOutlet weak var infoMessageFrame: UIView!
    override func viewDidLoad() {
        super.viewDidLoad()
        infoMessageFrame.layer.cornerRadius = 5
        
        

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
