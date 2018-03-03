//
//  SettingsViewController.swift
//  Swipeable-View-Stack
//
//  Created by Julia Zaratan on 2/28/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    
    var yelpRepo : YelpRepo? = nil

    @IBOutlet weak var openNowSwitch: UISwitch!
    
    @IBAction func `switch`(_ sender: UISwitch) {
        if sender.isOn {
           yelpRepo?.filterOpenNow();
        } 
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
   
    */
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        let viewController = segue.destination as! ViewController
        viewController.yelpRepo = self.yelpRepo!
    }

}
