//
//  ListTableViewCell.swift
//  todo2
//
//  Created by celine dann on 01/02/2019.
//  Copyright © 2019 celine dann. All rights reserved.
//

import UIKit

class ToDoTableViewCell: UITableViewCell {
    //@IBOutlet weak var switchDone: UISwitch!
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var containerView: UIImageView!
    @IBOutlet weak var checkDoneButton: UIButton!
    var onSwitchDone:(() -> ())?
    var task:Task? {
        didSet {
            guard let task = self.task else {
                return
            }
            label.text = task.title
            styleIfDone()
        }
    }
    
    //@IBAction func doSwitchDone(_sender: Any) {
    @IBAction func doCheckDone(_sender: Any) {
        guard let task = self.task else {
            return
        }
        task.done = !task.done
        styleIfDone()
        self.onSwitchDone?()
    }
    
    override func draw(_ rect: CGRect) {
        //self.switchDone.transform = CGAffineTransform(scaleX: 0.75, y: 0.75)
        containerView.clipsToBounds = true
        containerView.layer.cornerRadius = 10.0
        self.label.textColor = UIColor.white
        self.checkDoneButton.backgroundColor = nil
    }
    
    func styleIfDone() {
        let taskIsDone = task?.done ?? false
        self.containerView.alpha = taskIsDone ? 0.7 : 1
        let imageName = taskIsDone ? "checked" : "unchecked"
        self.checkDoneButton.setImage(UIImage(named: imageName), for: UIControl.State.normal)
        //self.checkDoneButton.imageView?.image = UIImage(named: imageName)
    }
}
