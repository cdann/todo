//
//  SettingsViewController.swift
//  todo2
//
//  Created by celine dann on 02/02/2019.
//  Copyright © 2019 celine dann. All rights reserved.
//

import UIKit

class SettingsViewController: UIViewController {
    @IBOutlet weak var displayDoneSwitch: UISwitch!
    @IBOutlet weak var displayByListSwitch: UISwitch!
    var displaySettings:Settings? {
        didSet {
            if isViewLoaded && displaySettings != nil {
                self.displayDoneSwitch.isOn = displaySettings!.displayDone
                self.displayByListSwitch.isOn = displaySettings!.displayByList
            }
        }
    }

    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.displayDoneSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.displayDoneSwitch.isOn = displaySettings?.displayDone ?? false
        self.displayByListSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.displayByListSwitch.isOn = displaySettings?.displayByList ?? false
    }
    

}
