//
//  SettingsViewController.swift
//  Swipeable-View-Stack
//
//  Created by Julia Zaratan on 2/28/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//
import UIKit

struct settings {
    let price : String
    let distance : Double
    let openNow : Bool
}

class SettingsViewController: UIViewController, UINavigationControllerDelegate {
    
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var openNowSwitch: UISwitch!
    
    var savedSettings : settings? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        
        self.title = "Settings"
        
        //load current settings
        guard
            let distance = savedSettings?.distance,
            let price = savedSettings?.price,
            let openNow = savedSettings?.openNow
        else {
            return
        }
        
        distanceSlider.value = Float(distance)
        openNowSwitch.setOn(openNow, animated: false)
    }
    
    //    @IBAction func backToMain(_ sender: Any) {
    //        print("sending settings as: price = \(savedSettings?.price) distance = \(savedSettings?.distance) openNow = \(savedSettings?.openNow)")
    //    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSettings(_ sender: Any) {
        savedSettings = settings(price: "$", distance: Double(distanceSlider.value), openNow: openNowSwitch.isOn)
        print("updated settings to: price = \(savedSettings?.price) distance = \(savedSettings?.distance) openNow = \(savedSettings?.openNow)")
    }
    
    func navigationController(_ navigationController: UINavigationController, didShow viewController: UIViewController, animated: Bool) {
        if let settings = self.savedSettings {
          (viewController as? ViewController)?.savedSettings = settings
        }
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
        if segue.identifier == "settingsToMainSegue" {
            let viewController = segue.destination as? ViewController
            viewController?.savedSettings = savedSettings!
            print("sending settings as: price = \(savedSettings?.price) distance = \(savedSettings?.distance) openNow = \(savedSettings?.openNow)")
        }
    }
    
}

