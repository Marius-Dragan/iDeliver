//
//  Helper.swift
//  iDeliver
//
//  Created by Marius Dragan on 17/02/2018.
//  Copyright © 2018 Marius Dragan. All rights reserved.
//

import UIKit
import CoreData

class Helper {
    
   static func getLocationCount () -> Int {
        let managedContext = appDelegate?.persistentContainer.viewContext
        let fetchRequest = NSFetchRequest<DropOffLocation>(entityName: "DropOffLocation")
        
        do {
            let count = try managedContext?.count(for:fetchRequest)
            return count!
        } catch let error as NSError {
            print("Error: \(error.localizedDescription)")
            return 0
        }
    }
    
}
