//
//  AddItemViewController.swift
//  To Do List
//
//  Created by Shobhit Bakliwal on 26/10/17.
//  Copyright © 2017 Shobhit Bakliwal. All rights reserved.
//

import UIKit
import os.log

class AddItemViewController: UIViewController, UITextFieldDelegate {
    @IBOutlet weak var taskNameField: UITextField!
    //@IBOutlet weak var deadlineField: UIDatePicker!
    @IBOutlet weak var saveButton: UIBarButtonItem!
    
    var task: ToDoListItem?
    var deadline: String = "20/03/2019"
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
        taskNameField.delegate = self
        
        //removed self bit to make it work for datefield
        let datePicker: UIDatePicker = UIDatePicker()
        datePicker.frame = CGRect(x: 20, y: 200, width: self.view.frame.width, height: 200)
        
        // Set some of UIDatePicker properties
        datePicker.timeZone = NSTimeZone.local
        datePicker.datePickerMode = .date
        datePicker.backgroundColor = UIColor.white
        
        datePicker.addTarget(self, action: #selector(AddItemViewController.datePickerValueChanged(_:)), for: .valueChanged)
        self.view.addSubview(datePicker)
        updateSaveButton()
    }
    
    @objc func datePickerValueChanged(_ sender: UIDatePicker) {
        
        // Create date formatter
        let dateFormatter: DateFormatter = DateFormatter()
        
        // Set date format
        dateFormatter.dateFormat = "dd/MM/yyyy"
        
        // Apply date format
        let selectedDate: String = dateFormatter.string(from: sender.date)
        deadline = selectedDate
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    @IBAction func cancel(_ sender: UIBarButtonItem) {
        dismiss(animated: true, completion: nil)
    }
    
    // MARK: UITextFieldDelegate methods
    
    func textFieldDidEndEditing(_ textField: UITextField) {
        updateSaveButton()
    }
    
    public func textFieldShouldReturn(_ textField: UITextField) -> Bool {
        // Hide the keyboard.
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - Navigation

    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        super.prepare(for: segue, sender: sender)
        
        os_log("In the Prepare function", log: OSLog.default, type: .debug)
        
        // Configure the destination view controller only when the save button is pressed.
        guard let button = sender as? UIBarButtonItem, button === saveButton else {
            os_log("The save button was not pressed, cancelling", log: OSLog.default, type: .debug)
            return
        }
        
        task = ToDoListItem()
        task?.name = taskNameField.text!
        task?.deadline = deadline
        task?.completed = false
        task?.save()
    }
    
    // MARK: Private methods
    
    func updateSaveButton() {
        let text = taskNameField.text ?? ""
        saveButton.isEnabled = !text.isEmpty
    }

}
