//
//  ViewController.swift
//  ScoutiumTest
//
//  Created by Eyüp YASUNTİMUR on 10.12.2020.
//

import UIKit
import FirebaseRemoteConfig



class ViewController: UIViewController {
    
    @IBOutlet weak var internetStatusLabel: UILabel!
    @IBOutlet weak var rcLabel: UILabel! // Remote Config Label
    
    let reachability = try! Reachability() // Accesses the Reachability class for internet connection control
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupRemoteConfigDefaults()
        displayNewValues()
        fetchRemoteConfig()
    }


    override func viewWillAppear(_ animated: Bool) {
        NotificationCenter.default.addObserver(self, selector: #selector(reachabilityChanged(note:)), name: .reachabilityChanged, object: reachability)
        do {
            try reachability.startNotifier()
        } catch {
            print("Unable to start notifier")
        }
    }

    //Prints connection type and equals to internetStatusLabel
    @objc func reachabilityChanged(note: Notification) {
        let reachability = note.object as! Reachability

        switch reachability.connection {
        case .wifi:
            print("Wifi Connection")
            self.internetStatusLabel.isHidden = true
        case .cellular:
            print("Cellular Connection")
            self.internetStatusLabel.isHidden = true
        case .unavailable:
            print("No Connection")
            self.internetStatusLabel.text = "No Connection"
        case .none:
            print("No Connection")
            self.internetStatusLabel.text = "No Connection"
        }
        
        // Makes 3 seconds delay to move MainScreeVC
        if (internetStatusLabel.text != "No Connection"){
            DispatchQueue.main.asyncAfter(deadline:.now() + 3.0, execute: {self.performSegue(withIdentifier:"toMainScreenVC",sender: self)})
        }
        else {
            rcLabel.text = "" // If there is no connection, it changes the "SCOUTIUM" text coming from firebase.
        }
    }
   
    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)
        reachability.stopNotifier()
        NotificationCenter.default.removeObserver(self, name: .reachabilityChanged, object: reachability)
    }
    
    func setupRemoteConfigDefaults() {
        let defaultValue : [String:NSObject] = ["label_text" : "" as NSObject]
        remoteConfig.setDefaults(defaultValue)
    }
    
    func fetchRemoteConfig(){
        remoteConfig.fetch(withExpirationDuration: 0) {
            [unowned self] (status, error) in
            guard error == nil
            else { return }
            remoteConfig.activate()
            self.displayNewValues()
        }
    }
    
    // Displays string value from Firebase Remote Config
    func displayNewValues(){
        let newLabelText = remoteConfig.configValue(forKey: "label_text").stringValue ?? ""
        rcLabel.text = newLabelText
    }

}
    


