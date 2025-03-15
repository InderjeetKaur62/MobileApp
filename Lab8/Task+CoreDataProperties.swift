//
//  Task+CoreDataProperties.swift
//  ToDoList
//
//  Created by Inderjeet Kaur on 2025-03-14.
//
//

import Foundation
import CoreData


extension Task {

    @nonobjc public class func fetchRequest() -> NSFetchRequest<Task> {
        return NSFetchRequest<Task>(entityName: "Task")
    }

    @NSManaged public var name: String?

}

extension Task : Identifiable {

}
