//
//  ChoseViewController.swift
//  Swipeable-View-Stack
//
//  Created by Austin Quach on 3/2/18.
//  Copyright © 2018 Phill Farrugia. All rights reserved.
//

import UIKit
import GoogleMaps
import GooglePlaces
import EventKit
import UserNotifications

class ChoseViewController: UIViewController, GMSMapViewDelegate, UNUserNotificationCenterDelegate {
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var addressLabel: UILabel!
    @IBOutlet weak var mapView: GMSMapView!
    var eventStore = EKEventStore()
    var calendars:Array<EKCalendar> = []
    
    let yelpRepo = YelpRepo.shared
    
    var business: BusinessCard? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        UNUserNotificationCenter.current().delegate = self
        
        guard
            let id = business?.id,
            let name = business?.name,
            let location = business?.location,
            let address = location.displayAddress,
            let image = business?.image
        else {
            return
        }
        var addressString: String = ""
        for line in address {
            addressString += "\(line)\n"
        }
        historyList.insert(business!, at: 0)
        //UserDefaults.standard.set(historyList, forKey: "history")
        nameLabel.text = name
        addressLabel.text = addressString
        self.image.image = image
        

        // fetch coordinates
        self.yelpRepo.searchBusinessWithID(id: id) { (response) in
            if let business = response {
                guard
                    let coords = business.coordinates,
                    let lat = coords.latitude,
                    let long = coords.longitude
                else {
                    return
                }
                let businessCoords: CLLocationCoordinate2D = CLLocationCoordinate2DMake(lat, long)
                let camera = GMSCameraPosition.camera(withLatitude: lat, longitude: long, zoom: 16)
                
                self.mapView.camera = camera
                self.mapView.delegate = self
                self.mapView.isMyLocationEnabled = true
                self.mapView.settings.myLocationButton = true
                self.mapView.settings.zoomGestures = true
                GoogleMapsHelper.createMarker(title: "Test", coords: businessCoords, mapView: self.mapView)
            }
        }
        
        // get permission
        eventStore.requestAccess(to: EKEntityType.reminder, completion:
            {(granted, error) in
                if !granted {
                    print("Access to store not granted")
                }
        })
        
        // you need calender's permission for the reminders as they live there
        calendars = eventStore.calendars(for: EKEntityType.reminder)
        
        for calendar in calendars as [EKCalendar] {
            print("Calendar = \(calendar.title)")
        }
    }

    let regionRadius: CLLocationDistance = 500
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    private func getDataFromUrl(url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url) { data, response, error in
            completion(data, response, error)
            }.resume()
    }

    @IBAction func navigateButton(_ sender: Any) {
        let id = business?.id
        
        self.yelpRepo.searchBusinessWithID(id: id!) { (response) in
            if let business = response {
                guard
                    let coords = business.coordinates,
                    let lat = coords.latitude,
                    let long = coords.longitude
                    else {
                        return
                }
                
                if (UIApplication.shared.canOpenURL(URL(string:"comgooglemaps://")!))
                {
                    UIApplication.shared.openURL(NSURL(string:
                        "comgooglemaps://?saddr=&daddr=\(Float((lat))),\(Float((long)))&directionsmode=driving")! as URL)
                } else
                {
                    NSLog("Can't use com.google.maps://");
                }
            }
        }
    }
    
    @IBAction func shareButton(_ sender: Any) {
        let text = "Some message"
        
        if UIApplication.shared.canOpenURL(URL(string:"sms:")!) {
            UIApplication.shared.open(URL(string:"sms:")!, options: [:], completionHandler: nil)
        }
    }
    
    
    @IBAction func remindButton(_ sender: Any) {
        let name = business?.name
        
        let center = UNUserNotificationCenter.current()
        let options: UNAuthorizationOptions = [.alert, .sound]
        center.requestAuthorization(options: options) { (granted, error) in
            if !granted {
                print("Something went wrong")
            }
        }
        center.getNotificationSettings { (settings) in
            if settings.authorizationStatus != .authorized {
                // Notifications not allowed
            }
        }
        
        let content = UNMutableNotificationContent()
        content.title = "Don't forget about"
        content.body = "your food plans at \(name!)"
        content.sound = UNNotificationSound.default()
        
        let alert = UIAlertController(title: "Reminder", message: "When do you want us to remind you?", preferredStyle: UIAlertControllerStyle.alert)
        alert.addAction(UIAlertAction(title: "Cancel", style: UIAlertActionStyle.default, handler: nil))
        alert.addAction(UIAlertAction(title: "1 min", style: UIAlertActionStyle.default, handler: {
            (act: UIAlertAction) in
            print("1 min")
  
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 60, repeats: false)
            let identifier = "UYLLocalNotification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print("Something went wrong.")
                }
            })

        }))
        alert.addAction(UIAlertAction(title: "1 hour", style: UIAlertActionStyle.default, handler: {
            (act: UIAlertAction) in
            print("1 hour")
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 3600, repeats: false)
            let identifier = "UYLLocalNotification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print("Something went wrong.")
                }
            })
            
        }))
        alert.addAction(UIAlertAction(title: "6 hours", style: UIAlertActionStyle.default, handler: {
            (act: UIAlertAction) in
            print("1 hour")
            
            let trigger = UNTimeIntervalNotificationTrigger(timeInterval: 21600, repeats: false)
            let identifier = "UYLLocalNotification"
            let request = UNNotificationRequest(identifier: identifier, content: content, trigger: trigger)
            
            center.add(request, withCompletionHandler: { (error) in
                if let error = error {
                    print("Something went wrong.")
                }
            })
            
        }))
        self.present(alert, animated: true, completion: nil)
    }
    
    //for displaying notification when app is in foreground
    func userNotificationCenter(_ center: UNUserNotificationCenter, willPresent notification: UNNotification, withCompletionHandler completionHandler: @escaping (UNNotificationPresentationOptions) -> Void) {
        
        //If you don't want to show notification when app is open, do something here else and make a return here.
        //Even you you don't implement this delegate method, you will not see the notification on the specified controller. So, you have to implement this delegate and make sure the below line execute. i.e. completionHandler.
        
        completionHandler([.alert, .badge, .sound])
    }

    
}
