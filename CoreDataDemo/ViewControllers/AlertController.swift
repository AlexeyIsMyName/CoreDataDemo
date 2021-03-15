//
//  AlertController.swift
//  CoreDataDemo
//
//  Created by ALEKSEY SUSLOV on 15.03.2021.
//

import UIKit

class AlertController: UIAlertController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
    }
    
    func action(task: Task?, completion: @escaping (String) -> Void) {
        let saveAction = UIAlertAction(title: "Save", style: .default) { _ in
            guard let newValue = self.textFields?.first?.text else { return }
            guard !newValue.isEmpty else { return }
            completion(newValue)
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .destructive)
        
        addAction(saveAction)
        addAction(cancelAction)
        addTextField { textField in
            textField.placeholder = "Task"
            textField.text = task?.name
        }
    }
}
