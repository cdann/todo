//
//  TableViewController.swift
//  todo2
//
//  Created by celine dann on 01/02/2019.
//  Copyright © 2019 celine dann. All rights reserved.
//

import UIKit

class ListTableViewController: UITableViewController {
    
    var viewModel: ListTableViewModel = ListTableViewModel()
    var editingTask: Task? = nil
    
    override func viewDidLoad() {
        super.viewDidLoad()
        definesPresentationContext = true
        self.tableView.separatorStyle = UITableViewCell.SeparatorStyle.none
        self.viewModel = ListTableViewModel(lists: List.sampleList(), onSectionsChange: {
            [unowned self] in
            self.tableView.reloadData() })
        self.tableView.sectionHeaderHeight = 50
        tableView.reloadData()
    }

    // MARK: - Table view data source

    override func numberOfSections(in tableView: UITableView) -> Int {
        return self.viewModel.numberOfSections()
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.viewModel.numberOfRows(section: section)
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "todoCell", for: indexPath) as! ToDoTableViewCell
        cell.task = self.viewModel.getRowTask(section: indexPath.section, row: indexPath.row)
        cell.onSwitchDone = viewModel.sortOrHideDoneInSections
        cell.onTaskEdit = {
            [weak self] in
            self?.editingTask = cell.task
            self?.performSegue(withIdentifier: "editTaskSegue", sender: nil)
        }
        return cell
    }
    
    
    override func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let view = UIView()
        let label = UILabel()
        label.translatesAutoresizingMaskIntoConstraints = false
        view.addSubview(label)
        let createConstraint:(NSLayoutConstraint.Attribute, CGFloat) -> (NSLayoutConstraint) = {
            attribute, constant in
            return NSLayoutConstraint(item: label, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1, constant: constant)
        }
        let constraints:[NSLayoutConstraint] = [
            createConstraint(.top, 15),
            createConstraint(.bottom, 15),
            createConstraint(.leading, 15),
            createConstraint(.trailing, -15),
        ]
        view.addConstraints(constraints)
        label.text = viewModel.getSectionTitle(section: section)
        label.textColor = UIColor(named: "sectionTitleColor")
        label.font = label.font.withSize(20)
        return view
    }
    
    @IBAction func unwindValidateEdit(sender: UIStoryboardSegue) {
        let source = sender.source as! EditViewController
        guard let taskName = source.nameField.text else {
            return
        }
        var list : List
        if source.newListSwitch.isOn {
            list = viewModel.createList(listTitle: source.newListField.text ?? "new list")
        } else {
            list = source.lists[source.listPicker.selectedRow(inComponent: 0)]
        }
        if let editTask = self.editingTask {
            editTask.title = taskName
        }
        let task = self.editingTask ?? Task(title: taskName, done: false, listUuid: list.uuid)
        viewModel.putTaskInList(list: list, task: task)
        self.editingTask = nil
    }

    @IBAction func unwindCancel(sender: UIStoryboardSegue) {
        return
    }
    
    @IBAction func unwindSettings(sender: UIStoryboardSegue) {
        if let source = sender.source as? SettingsViewController {
            let settings = (displayDone: source.displayDoneSwitch.isOn, displayByList:source.displayByListSwitch.isOn)
            viewModel.changeSettings(settings: settings)
        }
        return
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let editCtrl = segue.destination as? EditViewController {
            editCtrl.lists = viewModel.getAllLists()
            editCtrl.editingTask = self.editingTask
        }
        if let settingCtrl = segue.destination as? SettingsViewController {
            settingCtrl.displaySettings = viewModel.settings
        }
    }
    
}
