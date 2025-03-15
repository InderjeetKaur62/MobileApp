import UIKit
import CoreData

class TaskInputViewController: UIViewController {
    @IBOutlet weak var taskTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    @IBAction func saveTask(_ sender: UIButton) {
        guard let taskName = taskTextField.text, !taskName.isEmpty else { return }
        saveTaskToCoreData(name: taskName)
        taskTextField.text = ""
    }
    
    func saveTaskToCoreData(name: String) {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let context = appDelegate.persistentContainer.viewContext
        let task = Task(context: context)
        task.name = name
        
        do {
            try context.save()
        } catch {
            print("Failed to save task: \(error)")
        }
    }
}
//  TaskInputViewController.swift
//  ToDoList
//
//  Created by Inderjeet Kaur on 2025-03-14.
//

