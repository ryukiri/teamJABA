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
    
    @IBOutlet weak var priceChooser: UISegmentedControl!
    @IBOutlet weak var distanceSlider: UISlider!
    @IBOutlet weak var openNowSwitch: UISwitch!
    @IBOutlet weak var currentDistance: UILabel!
    
    @IBOutlet weak var checkImage: UIImageView!
    
    var savedSettings : settings? = nil
    var updatedSettings: Bool? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationController?.delegate = self
        self.checkImage.isHidden = true
        
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
        currentDistance.text = String(Int(distanceSlider.value))
        openNowSwitch.setOn(openNow, animated: false)
        
        var priceIndex = 0
        
        switch price {
            case "$": priceIndex = 0
            case "$$": priceIndex = 1
            case "$$$": priceIndex = 2
            case "$$$$": priceIndex = 3
            default: priceIndex = 4
        }
        
        priceChooser.selectedSegmentIndex = priceIndex
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func saveSettings(_ sender: Any) {
        self.updatedSettings = true
//        print(self.updatedSettings)
        savedSettings = settings(price: priceChooser.titleForSegment(at: priceChooser.selectedSegmentIndex)!, distance: Double(distanceSlider.value), openNow: openNowSwitch.isOn)
//        print("updated settings to: price = \(String(describing: savedSettings?.price)) distance = \(String(describing: savedSettings?.distance)) openNow = \(savedSettings?.openNow)")
        self.checkImage.isHidden = false
        self.checkImage.alpha = 1.0
        UIViewPropertyAnimator(duration: 1.3, curve: .easeOut, animations: {
            self.checkImage.alpha = 0.0
        }).startAnimation()
        
    }
    
    func navigationController(_ navigationController: UINavigationController, willShow viewController: UIViewController, animated: Bool) {
        if let settings = self.savedSettings, let updated = self.updatedSettings {
            let mainVC = viewController as? ViewController
            mainVC?.savedSettings = settings
            mainVC?.updatedSettings = updated
        }
    }

    @IBAction func distanceChanged(_ sender: Any) {
        self.currentDistance.text = String(Int(distanceSlider.value));
    }
    
}

