//
//  TableViewController.swift
//  todo2
//
//  Created by celine dann on 01/02/2019.
//  Copyright © 2019 celine dann. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    //var uncompleteTasks:[Task]
    var settings:(displayDone:Bool, displayByList:Bool) = (displayDone: true, displayByList: true)
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        List.lists = List.sampleList()
        self.tableView.sectionHeaderHeight = 50
        self.reloadData()
    }
    
    func reloadData() {
        List.lists.forEach { (list) in
            list.sortByDone()
        }
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return List.lists.count
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.settings.displayDone ? List.lists[section].tasks.count : List.lists[section].getUndone().count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let list =  List.lists[indexPath.section]
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoTableViewCell
        let tasks = self.settings.displayDone ? list.tasks : list.getUndone()
        cell.task = tasks[indexPath.row]
        cell.onSwitchDone = self.reloadData
        return cell
    }
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        //let horizontalConstraint = NSLayoutConstraint(item: newView, attribute: NSLayoutConstraint.Attribute.centerX, relatedBy: NSLayoutConstraint.Relation.equal, toItem: view, attribute: NSLayoutConstraint.Attribute.centerX, multiplier: 1, constant: 0)
        view.addSubview(label)
        var constraints:[NSLayoutConstraint] = []
        constraints.append(NSLayoutConstraint(item: label, attribute: .top, relatedBy: .equal, toItem: view, attribute: .top, multiplier: 1, constant: 15))
        constraints.append(NSLayoutConstraint(item: label, attribute: .bottom, relatedBy: .equal, toItem: view, attribute: .bottom, multiplier: 1, constant: 10))
        constraints.append(NSLayoutConstraint(item: label, attribute: .leading, relatedBy: .equal, toItem: view, attribute: .leading, multiplier: 1, constant: 15))
        constraints.append(NSLayoutConstraint(item: label, attribute: .trailing, relatedBy: .equal, toItem: view, attribute: .trailing, multiplier: 1, constant: -15))
        // constraints.append(NSLayoutConstraint(item: view, attribute: .height, relatedBy: .equal, toItem: nil, attribute: .notAnAttribute, multiplier: 0, constant: 90))
        
        view.addConstraints(constraints)
        
        label.text = List.lists[section].title
        //label.textAlignment = NSTextAlignment.center
        label.textColor = UIColor(named: "sectionTitleColor")
        label.font = label.font.withSize(20)
        
        return view
    }
    
    @IBAction func unwindValidateEdit(sender: UIStoryboardSegue) {
        let source = sender.source as! EditViewController
        guard let taskName = source.nameField.text else {
            return
        }
        let list = source.newListSwitch.isOn ? List(title: source.newListField.text ?? "") : List.lists[source.listPicker.selectedRow(inComponent: 0)]
        list.tasks.append(Task(title: taskName))
        if source.newListSwitch.isOn {
            List.lists.append(list)
        }
        self.reloadData()
    }

    @IBAction func unwindCancel(sender: UIStoryboardSegue) {
        return
    }
    
    @IBAction func unwindSettings(sender: UIStoryboardSegue) {
        let source = sender.source as! SettingsViewController
        self.settings.displayDone = source.displayDoneSwitch.isOn
        tableView.reloadData()
        return
    }
}
