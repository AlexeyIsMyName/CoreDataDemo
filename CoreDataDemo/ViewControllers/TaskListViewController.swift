//
//  TaskListViewController.swift
//  CoreDataDemo
//
//  Created by ALEKSEY SUSLOV on 11.03.2021.
//

import UIKit

class TaskListViewController: UITableViewController {
    private let cellID = "cell"
    private var taskList = StorageManager.shared.fetchData()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        tableView.register(UITableViewCell.self, forCellReuseIdentifier: cellID)
        setupNavigationBar()
    }

    private func setupNavigationBar() {
        title = "Task List"
        navigationController?.navigationBar.prefersLargeTitles = true
        
        // Navigation Bar Appearence
        let navBarAppearance = UINavigationBarAppearance()
        navBarAppearance.configureWithOpaqueBackground()
        
        navBarAppearance.titleTextAttributes = [.foregroundColor: UIColor.white]
        navBarAppearance.largeTitleTextAttributes = [.foregroundColor: UIColor.white]
        
        navBarAppearance.backgroundColor = UIColor(
            red: 21/255,
            green: 101/255,
            blue: 192/255,
            alpha: 194/255
        )
        
        navigationController?.navigationBar.standardAppearance = navBarAppearance
        navigationController?.navigationBar.scrollEdgeAppearance = navBarAppearance
        
        // Add button to navigation bar
        navigationItem.rightBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: .add,
            target: self,
            action: #selector(addNewTask)
        )
        
        navigationController?.navigationBar.tintColor = .white
    }
    
    @objc private func addNewTask() {
        showAlert()
    }
}

// MARK: - Table View Data Source
extension TaskListViewController {
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        taskList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: cellID, for: indexPath)
        var content = cell.defaultContentConfiguration()
        let task = taskList[indexPath.row]
        content.text = task.name
        cell.contentConfiguration = content
        return cell
    }
    
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        guard editingStyle == .delete else { return }
        StorageManager.shared.deleteData(taskList[indexPath.row])
        self.taskList.remove(at: indexPath.row)
        tableView.deleteRows(at: [indexPath], with: .automatic)
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
        showAlert(task: taskList[indexPath.row]) {
            tableView.reloadRows(at: [indexPath], with: .automatic)
        }
    }
}

// MARK: - Alerts and reletad methods
extension TaskListViewController {
    
    private func showAlert(task: Task? = nil, completion: (() -> Void)? = nil) {
        
        let title = task != nil ? "Update Task" : "New Task"
        
        let alert = AlertController(
            title: title,
            message: "What do you want to do?",
            preferredStyle: .alert
        )
        
        alert.action(task: task) { taskName in
            if let task = task, let completion = completion {
                StorageManager.shared.editData(task, newName: taskName)
                completion()
            } else {
                self.save(taskName)
            }
        }
        
        present(alert, animated: true)
    }
    
    private func save(_ taskName: String) {
        guard let task = StorageManager.shared.saveData(taskName) else { return }
        taskList.append(task)
        let cellIndex = IndexPath(row: taskList.count - 1, section: 0)
        tableView.insertRows(at: [cellIndex], with: .automatic)
    }
    
    private func edit(_ taskName: String, _ indexPath: IndexPath) {
        StorageManager.shared.editData(taskList[indexPath.row], newName: taskName)
        taskList[indexPath.row].name = taskName
        tableView.reloadRows(at: [indexPath], with: .automatic)
    }
}
