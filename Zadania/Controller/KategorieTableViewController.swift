//
//  KategorieTableViewController.swift
//  Zadania
//
//  Created by Jakub Zakroczymski on 23/11/2019.
//  Copyright © 2019 Wojciech Zakroczymski. All rights reserved.
//

import UIKit
import CoreData


class KategorieTableViewController: UITableViewController {
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext

    var kategorie : [Kategoria] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
         let request: NSFetchRequest<Kategoria> = Kategoria.fetchRequest()
        zaladujDane(with: request )

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
    }

    // MARK: - Table view data source


    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        // #warning Incomplete implementation, return the number of rows
        return kategorie.count    }
    
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "cell1", for: indexPath)
        cell.textLabel?.text = kategorie[indexPath.row].tytul
        
        
        
        // Configure the cell...

        return cell
    }

   
    @IBAction func dodajKategorie(_ sender: Any) {
        var textField = UITextField()
        
         let alert = UIAlertController(title: "Dodaj nową kategorię", message: "", preferredStyle: .alert)
         
         let action = UIAlertAction(title: "Dodaj", style: .default) { (action) in
             
             
             
             let kategoria = Kategoria(context: self.context)
             
             kategoria.tytul = textField.text
             
             
             self.kategorie.append(kategoria)
             
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
    func zaladujDane(with request: NSFetchRequest<Kategoria>) {
       
        
        do {
            kategorie = try context.fetch(request)
        } catch {
            print(error)
        }
    }
}
