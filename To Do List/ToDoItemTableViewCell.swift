//
//  ToDoItemTableViewCell.swift
//  To Do List
//
//  Created by Shobhit Bakliwal on 26/10/17.
//  Copyright © 2017 Shobhit Bakliwal. All rights reserved.
//

import UIKit

class ToDoItemTableViewCell: UITableViewCell {
    @IBOutlet weak var taskNameLabel: UILabel!
    @IBOutlet weak var deadlineLabel: UILabel!
    @IBOutlet weak var taskCompleteSwitch: UISwitch!
    
    var task: ToDoListItem?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    func setTask(task: ToDoListItem) {
        self.task = task
        taskCompleteSwitch.isOn = task.completed
        updateLabel()
        
        taskCompleteSwitch.addTarget(self, action: #selector(ToDoItemTableViewCell.taskCompleted(completeSwitch:)), for: .valueChanged)
    }
    
    func updateLabel() {
        let attributeString: NSMutableAttributedString =  NSMutableAttributedString(string: task!.name)
        let deadline = daysRemaining(deadline: task!.deadline)
        let attributeString2: NSMutableAttributedString =  NSMutableAttributedString(string: deadline)
        
        if task!.completed {
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            attributeString2.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString2.length))
        }
        
        if isItToday(deadline: task!.deadline) {
            attributeString.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(0, attributeString.length))
            attributeString2.addAttribute(NSAttributedString.Key.foregroundColor, value: UIColor.red, range: NSMakeRange(0, attributeString2.length))
        }
        
        taskNameLabel.attributedText = attributeString
        deadlineLabel.attributedText = attributeString2
    }
    
    func daysRemaining(deadline: String) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let deadlineDate = dateFormatter.date(from:deadline)!
        let today = Date()
        let days = Calendar.current.dateComponents([Calendar.Component.day], from: today, to: deadlineDate).day ?? 0
        return "\(days) days remaining"
    }
    
    func isItToday(deadline: String) -> Bool {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yyyy"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX") // set locale to reliable US_POSIX
        let deadlineDate = dateFormatter.date(from:deadline)!
        if Calendar.current.isDateInToday(deadlineDate) {
            return true
        } else {
            return false
        }
    }

    
    @objc func taskCompleted(completeSwitch: UISwitch) {
        let isCompelete = completeSwitch.isOn
        // Do something
        task?.updateCompleted(completed: isCompelete)
        updateLabel()
    }

}
