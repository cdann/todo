//
//  FormViewController.swift
//  todo2
//
//  Created by celine dann on 01/02/2019.
//  Copyright © 2019 celine dann. All rights reserved.
//

import UIKit

class EditViewController: UIViewController, UIPickerViewDataSource, UIPickerViewDelegate {
    @IBOutlet weak var nameField: UITextField!
    @IBOutlet weak var newListSwitch: UISwitch!
    @IBOutlet weak var newListField: UITextField!
    @IBOutlet weak var listPicker: UIPickerView!
    

    override func viewDidLoad() {
        super.viewDidLoad()
        newListSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        listPicker.dataSource = self
        listPicker.delegate = self
        newListField.isHidden = true
        newListSwitch.isOn = false
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return List.lists.count
    }
    @IBAction func switchToNewList(_ sender: Any) {
        listPicker.isHidden = newListSwitch.isOn
        newListField.isHidden = !listPicker.isHidden
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return List.lists[row].title
    }
    
}
