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
    var lists:[List] = []
    var editingTask: Task? {
        didSet {
            if !self.isViewLoaded {
                return
            }
            initFields()
        }
    }
    

    override func viewDidLoad() {
        super.viewDidLoad()
        self.newListSwitch.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        self.listPicker.dataSource = self
        self.listPicker.delegate = self
        self.newListField.isHidden = true
        self.newListSwitch.isOn = false
        self.initFields()
    }
    
    func numberOfComponents(in pickerView: UIPickerView) -> Int {
        return 1
    }
    
    func pickerView(_ pickerView: UIPickerView, numberOfRowsInComponent component: Int) -> Int {
        return self.lists.count
    }
    
    @IBAction func switchToNewList(_ sender: Any) {
        self.listPicker.isHidden = self.newListSwitch.isOn
        self.newListField.isHidden = !self.listPicker.isHidden
    }
    
    func pickerView(_ pickerView: UIPickerView, titleForRow row: Int, forComponent component: Int) -> String? {
        return self.lists[row].title
    }
    
    func initFields() {
        if let task = self.editingTask, task.title != self.nameField.text  {
            self.nameField.text = task.title
            let listIndex = self.lists.firstIndex { $0.uuid == task.listUuid } ?? 0
            self.listPicker.selectRow(listIndex, inComponent: 0, animated: false)
        }
        else if editingTask == nil {
            self.nameField.text = ""
            self.listPicker.selectRow(0, inComponent: 0, animated: false)
        }
    }
    
}
