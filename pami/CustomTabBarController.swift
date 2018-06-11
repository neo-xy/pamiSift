//
//  CustomTabBarController.swift
//  pami
//
//  Created by Pawel  on 2018-06-06.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var label = UILabel()
        label.text = "MER"
        

        self.moreNavigationController.navigationBar.topItem?.title = "Mer"
        self.moreNavigationController.navigationBar.backgroundColor = UIColor.white
        self.moreNavigationController.topViewController?.view.tintColor = UIColor(named: "primaryDark")
       (self.moreNavigationController.topViewController?.view as! UITableView).separatorStyle = UITableViewCellSeparatorStyle.none
       
        
        self.tabBar.tintColor = UIColor(named: "primaryDark")
        
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
