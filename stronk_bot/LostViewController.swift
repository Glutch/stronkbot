//
//  LostViewController.swift
//  stronk_bot
//
//  Created by Oliver Johansson on 2018-05-06.
//  Copyright © 2018 Oliver Johansson. All rights reserved.
//

import UIKit
import CoreData

class LostViewController: UIViewController {
    
    @IBAction func restartBtn(_ sender: Any) {
        resetProgress()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    func resetProgress() {
        let fetchRequest = NSFetchRequest<NSFetchRequestResult>(entityName: "Day")
        let deleteRequest = NSBatchDeleteRequest(fetchRequest: fetchRequest)
        
        let persistentContainer = (UIApplication.shared.delegate as! AppDelegate).persistentContainer
        
        do {
            try persistentContainer.viewContext.execute(deleteRequest)
            print("progress reset")
        } catch let error as NSError {
            print(error)
            print("failed to reset")
        }
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }

}
