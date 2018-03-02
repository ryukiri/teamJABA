//
//  DetailsViewController.swift
//  Swipeable-View-Stack
//
//  Created by Bonnie Nguyen on 3/1/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit

class DetailsViewController: UIViewController {
    var business: BusinessCard? = nil

    @IBOutlet weak var businessNameLabel: UILabel!
    @IBOutlet weak var businessImage: UIImageView!
    
    var initialTouchPoint: CGPoint = CGPoint(x: 0,y: 0)
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(false)
        
        self.view.layer.cornerRadius = 10
        self.view.clipsToBounds = true
        
        self.businessNameLabel.text = business?.name
        //        self.businessImage = business?.imageURL
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func onClickPan(_ sender: UIPanGestureRecognizer) {
        let touchPoint = (sender as AnyObject).location(in: self.view?.window)
        
        if sender.state == UIGestureRecognizerState.began {
            initialTouchPoint = touchPoint
        } else if sender.state == UIGestureRecognizerState.changed {
            if touchPoint.y - initialTouchPoint.y > 0 {
                self.view.frame = CGRect(x: 0, y: touchPoint.y - initialTouchPoint.y, width: self.view.frame.size.width, height: self.view.frame.size.height)
            }
        } else if sender.state == UIGestureRecognizerState.ended || sender.state == UIGestureRecognizerState.cancelled {
            if touchPoint.y - initialTouchPoint.y > 100 {
                self.dismiss(animated: true, completion: nil)
            } else {
                UIView.animate(withDuration: 0.3, animations: {
                    self.view.frame = CGRect(x: 0, y: 0, width: self.view.frame.size.width, height: self.view.frame.size.height)
                })
            }
        }
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
