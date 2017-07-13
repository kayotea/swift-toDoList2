//
//  ViewController.swift
//  ToDoList
//
//  Created by Placoderm on 7/12/17.
//  Copyright © 2017 Placoderm. All rights reserved.
//

import UIKit
import CoreData

class ToDoListViewController: UITableViewController {
    
    var items = [ToDoListItem]()
    let managedObjectContext = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    @IBOutlet weak var toDoTitle: UILabel!
    @IBOutlet weak var toDoDescription: UILabel!
    @IBOutlet weak var toDoDate: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        fetchAllItems()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    //num of rows
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return items.count
    }
    //cells
    override func tableView(_ table: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "ListItemCell", for: indexPath) as! ListItemCell
        
        cell.toDoTitle.text = items[indexPath.row].todo_title
        cell.toDoDescription.text = items[indexPath.row].todo_description
        cell.toDoDate.text = items[indexPath.row].todo_date
        
        if items[indexPath.row].todo_done {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        return cell
    }
    //when user clicks on row again, remove checkmark
    //override func tableView(tableView: UITableView, didDeselectRowAtIndexPath indexPath: NSIndexPath) {
    //    if let cell = tableView.cellForRowAtIndexPath(indexPath as IndexPath) as! ListItemCell {
    //        cell.accessoryType = .None
    //    }
    //}
    
    //retreive items form CoreData
    func fetchAllItems() {
        
        let request = NSFetchRequest<NSFetchRequestResult>(entityName: "ToDoListItem")
        
        do {
            let result = try managedObjectContext.fetch(request)
            items = result as! [ToDoListItem]
        } catch {
            print("\(error)")
        }
    }
    //delete
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCellEditingStyle, forRowAt indexPath: IndexPath) {
        
        let item = items[indexPath.row]
        //database removal
        managedObjectContext.delete(item)
        do {
            try managedObjectContext.save()
        } catch {
            print ("\(error)")
        }
        
        items.remove(at: indexPath.row)
        tableView.reloadData()
    }
    
    //prepare segue
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
    }
    
    //listen for user to click on row
    //show checkmark
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print("Selected")
        //    //perform segue given sender
        //    performSegue(withIdentifier: "EditItemSegue", sender: indexPath)
        
        if let cell = tableView.cellForRow(at: indexPath as IndexPath) {
            
            print ("here")
            
            var item = items[indexPath.row]
            item.todo_done = true
            
            do {
                try managedObjectContext.save()
            } catch {
                print ("\(error)")
            }
            
            cell.accessoryType = .checkmark
            tableView.reloadData()
        }
    }
    
    //unwind segue
    @IBAction func unwindToToDoListView(sender: UIStoryboardSegue)
    {
        let new_todo = NSEntityDescription.insertNewObject(forEntityName: "ToDoListItem", into: managedObjectContext) as! ToDoListItem
        
        let sourceViewController = sender.source as! AddItemTableViewController
        print(sourceViewController)
        
        if let t = sourceViewController.titleTextField.text {
            new_todo.todo_title = t
        }
        if let dp = sourceViewController.descriptionTextField.text {
            new_todo.todo_description = dp
        }
        if let dt = sourceViewController.datePicker {
            let dateFormatter = DateFormatter()
            dateFormatter.dateFormat = "MM/dd/yyyy"
            let datestring = dateFormatter.string(from: dt.date)

            new_todo.todo_date = datestring
        }
        
        new_todo.todo_done = false
        
        do {
            try managedObjectContext.save()
        } catch {
           print ("\(error)")
        }
        
        items.append(new_todo)
        tableView.reloadData()
        
    }
}
