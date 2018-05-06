//
//  ViewController.swift
//  stronk_bot
//
//  Created by Oliver Johansson on 2018-05-03.
//  Copyright © 2018 Oliver Johansson. All rights reserved.
//

import UIKit
import CoreData

class ViewController: UIViewController {
 
    @IBOutlet weak var completedLabel: UILabel!
    @IBOutlet weak var currentDayLabel: UILabel!
    @IBOutlet weak var flexBtn: UIButton!
    
    @IBAction func flexBtnAction(_ sender: Any) {
        print("clicked")
        completeDay()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        checkExists()
        checkToday()
    }
    
    func checkToday() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Day", in: managedContext)!
        
        let fetchDay = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        let days = try! managedContext.fetch(fetchDay)
        fetchDay.fetchLimit = 1
        let currentDay = try! managedContext.fetch(fetchDay)
        
        let today: Day = currentDay.first as! Day
        print("Date: \(today.date!)")
        print("Completed: \(today.completed)")
        
        completedLabel.text = today.completed ? "Completed day \(days.count)!" : "Not completed day \(days.count)."
        currentDayLabel.text = String(days.count)
        
        if (Calendar.current.isDate(today.date!, inSameDayAs: Date())) {
            print("Today already saved!")
        } else {
            // If user skipped a pushup, user failed challenge
            print(days.count)
            if(days.count > 0){
                // YOU LOST
                self.performSegue(withIdentifier: "lost", sender: nil)
            } else {
                insertCurrentDay(entity: entity, managedContext: managedContext)
            }
        }
    }
    
    func completeDay(){
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        
        let fetchDay = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        fetchDay.fetchLimit = 1
        
        checkExists()
        
        let currentDay = try! managedContext.fetch(fetchDay)
        let today: Day = currentDay.first as! Day
        today.setValue(true, forKey: "Completed")
        
        do {
            try managedContext.save()
            print("Updated day! Completed = true")
            checkToday()
        } catch let error as NSError  {
            print("Could not save \(error)")
        }
    }
    
    func checkExists() {
        guard let appDelegate = UIApplication.shared.delegate as? AppDelegate else { return }
        let managedContext = appDelegate.persistentContainer.viewContext
        let entity = NSEntityDescription.entity(forEntityName: "Day", in: managedContext)!
        
        let fetchDay = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        let days = try! managedContext.fetch(fetchDay)
        fetchDay.fetchLimit = 1
        
        if(days.count == 0) {
            insertCurrentDay(entity: entity, managedContext: managedContext)
        } else {
            print("exists")
        }
    }
    
    func insertCurrentDay(entity: NSEntityDescription, managedContext: NSManagedObjectContext) {
        let newDay = NSManagedObject(entity: entity, insertInto: managedContext)
        newDay.setValue(false, forKeyPath: "completed")
        newDay.setValue(Date(), forKey: "date")
        
        do {
            try managedContext.save()
            print("saved day")
        } catch let error as NSError {
            print("Could not save. \(error), \(error.userInfo)")
        }
    }
    
    

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

