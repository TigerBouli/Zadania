//
//  ZadaniaViewController.swift
//  Zadania
//
//  Created by Wojciech Zakroczymski on 26/10/2019.
//  Copyright © 2019 Wojciech Zakroczymski. All rights reserved.
//

import CoreData
import UIKit

class ZadaniaViewController: UITableViewController {
    var zadania: [Zadanie] = []
    
    var wybranaKategoria: Kategoria? {
        didSet {
            zaladujDane()
        }
    }
    
    // var defaults = UserDefaults.standard
    
    let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
        
        if zadania[indexPath.row].zrobione {
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
        
        saveData()
        
        tableView.reloadData()
    }
    
    @IBAction func plusClicked(_ sender: Any) {
        var textField = UITextField()
        
        let alert = UIAlertController(title: "Dodaj nowe zadanie", message: "", preferredStyle: .alert)
        
        let action = UIAlertAction(title: "Dodaj", style: .default) { _ in
            
            let zadanie = Zadanie(context: self.context)
            
            zadanie.tytul = textField.text
            
            zadanie.zrobione = false
            
            zadanie.kategoria = self.wybranaKategoria
            
            self.zadania.append(zadanie)
            
            self.saveData()
            
            self.tableView.reloadData()
        }
        
        alert.addTextField { alertTextField in
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
    
    func zaladujDane(filtr: NSPredicate? = nil) {
        let request: NSFetchRequest<Zadanie> = Zadanie.fetchRequest()
        
        let filtrKatagorii = NSPredicate(format: "kategoria.tytul MATCHES %@", wybranaKategoria!.tytul!)
        
        if let dodatkowyFiltr = filtr {
            let polaczonyFiltr = NSCompoundPredicate(andPredicateWithSubpredicates: [filtrKatagorii, dodatkowyFiltr])
            request.predicate = polaczonyFiltr
        } else {
            request.predicate = filtrKatagorii
        }
        
        do {
            zadania = try context.fetch(request)
        } catch {
            print(error)
        }
    }
}

extension ZadaniaViewController: UISearchBarDelegate {
    func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
        if searchBar.text?.count == 0 {
            zaladujDane()
            tableView.reloadData()
            DispatchQueue.main.async {
                searchBar.resignFirstResponder()
            }
        } else {
            let zapytanie: NSFetchRequest<Zadanie> = Zadanie.fetchRequest()
            
            let filtr = NSPredicate(format: "tytul CONTAINS[cd] %@", searchBar.text!)
            
            zapytanie.predicate = filtr
            
            let sortowanie = NSSortDescriptor(key: "tytul", ascending: true)
            
            zapytanie.sortDescriptors = [sortowanie]
            
            zaladujDane(filtr: filtr)
            tableView.reloadData()
        }
    }
}
