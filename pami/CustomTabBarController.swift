//
//  CustomTabBarController.swift
//  pami
//
//  Created by Pawel  on 2018-06-06.
//  Copyright © 2018 pami. All rights reserved.
//

import UIKit

class CustomTabBarController: UITabBarController {
    var shiftsToTake:[ShiftToTake] = []

    override func viewDidLoad() {
        super.viewDidLoad()
        
        var label = UILabel()
        label.text = "MER"
        

        self.moreNavigationController.navigationBar.topItem?.title = "Mer"
        self.moreNavigationController.navigationBar.backgroundColor = UIColor.white
        self.moreNavigationController.topViewController?.view.tintColor = UIColor(named: "primaryDark")
       (self.moreNavigationController.topViewController?.view as! UITableView).separatorStyle = UITableViewCellSeparatorStyle.none
       
        
        self.tabBar.tintColor = UIColor(named: "primaryDark")
        
        FirebaseController.getShiftsToTake().subscribe { (event) in
            self.shiftsToTake = event.element!
            if(self.shiftsToTake.count < 1){
                (self.tabBar.items![3] as UITabBarItem).badgeValue = nil
            }else{
                (self.tabBar.items![3] as UITabBarItem).badgeValue = String(self.shiftsToTake.count)
            }
            
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}
