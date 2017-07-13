//
//  AddItemTableViewController.swift
//  ToDoList
//
//  Created by Placoderm on 7/12/17.
//  Copyright © 2017 Placoderm. All rights reserved.
//

import UIKit

class AddItemTableViewController: UITableViewController {

    @IBOutlet weak var titleTextField: UITextField!
    @IBOutlet weak var descriptionTextField: UITextField!
    @IBOutlet weak var datePicker: UIDatePicker!
    
    @IBAction func cancelButtonPressed(_ sender: UIBarButtonItem) {
        self.dismiss(animated:true, completion: nil)
    }
    //note: pressing "Add Item" button triggers unwind segue to ToDoListView

    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextField.placeholder = "Title"
        descriptionTextField.placeholder = "Add description here"
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
}
