//
//  ZadaniaViewController.swift
//  Zadania
//
//  Created by Wojciech Zakroczymski on 26/10/2019.
//  Copyright © 2019 Wojciech Zakroczymski. All rights reserved.
//

import UIKit
import CoreData


class ZadaniaViewController: UITableViewController {
    
    var zadania : [Zadanie] = []
    
    var defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    override func viewDidLoad() {
        super.viewDidLoad()
        zaladujDane()
       // print(FileManager.default.urls(for: .documentDirectory, in: .userDomainMask))
        
        /*
        if let czytaneZadania = defaults.array(forKey: "Zadania") as? [Zadanie] {
            zadania = czytaneZadania
        }*/

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
    }

    // MARK: - Table view data source

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return zadania.count
    }

    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell", for: indexPath)
        cell.textLabel?.text = zadania[indexPath.row].tytul
        
        if (zadania[indexPath.row].zrobione) {
            cell.accessoryType = .checkmark
        } else {
            cell.accessoryType = .none
        }
        
        // Configure the cell...

        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        print(indexPath.row)
        
        zadania[indexPath.row].zrobione = !zadania[indexPath.row].zrobione
        
        tableView.deselectRow(at: indexPath, animated: true)
        
        tableView.reloadData()
    }
    
    
    
    @IBAction func plusClicked(_ sender: Any) {
        
        var textField = UITextField()
       
        let alert = UIAlertController(title: "Dodaj nowe zadanie", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dodaj", style: .default) { (action) in
            
            
            
            let zadanie = Zadanie(context: self.context)
            
            zadanie.tytul = textField.text
            
            zadanie.zrobione = false
            
            self.zadania.append(zadanie)
            
            self.saveData()
        
            
            self.tableView.reloadData()
            
        }
        
        alert.addTextField { (alertTextField) in
            alertTextField.placeholder = "Wpisz zadanie"
            textField = alertTextField
        }
        
        alert.addAction(action)
        
        present(alert, animated: true, completion: nil)
        
        
        
    }
    
    func saveData() {
        
        do {
            try context.save()
        } catch {
            // Replace this implementation with code to handle the error appropriately.
            // fatalError() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            let nserror = error as NSError
            fatalError("Unresolved error \(nserror), \(nserror.userInfo)")
        }
        
        
    }
    
    func zaladujDane() {
        let request: NSFetchRequest<Zadanie> = Zadanie.fetchRequest()
        
        do {
            zadania = try context.fetch(request)
        } catch {
            print(error)
        }
    }
}
