//
//  ViewController.swift
//  Milestone3
//
//  Created by Jack Mustacato on 1/11/18.
//  Copyright © 2018 Jack Mustacato. All rights reserved.
//

import UIKit

class ViewController: UITableViewController {
    var shoppingList = [String]()

    override func viewDidLoad() {
        super.viewDidLoad()
        
        navigationItem.rightBarButtonItem =
        UIBarButtonItem(barButtonSystemItem: .add, target: self,
                        action: #selector(addItem))
    }
    
    @objc func addItem() {
        let ac = UIAlertController(title: "Enter Item", message: nil,
                                   preferredStyle: .alert)
        ac.addTextField()
        
        let submitAction = UIAlertAction(title: "Add", style: .default) {
            [unowned self, ac] _ in
                let item = ac.textFields![0]
                self.add(item: item.text!)
        }
        
        ac.addAction(submitAction)
        present(ac, animated: true)
    }
    
    func add(item: String) {
        if shoppingList.contains(item) {
            let errorTitle = "Item already added"
            let errorMessage = "You can't add duplicate items to the list"
            showErrorMessage(errorTitle, errorMessage)
        } else {
            shoppingList.insert(item, at: 0)
            let indexPath = IndexPath(row: 0, section: 0)
            tableView.insertRows(at: [indexPath], with: .automatic)
        }
    }
    
    func showErrorMessage(_ errorTitle: String, _ errorMessage: String) {
        let ac = UIAlertController(title: errorTitle, message: errorMessage,
                                   preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "OK", style: .default))
        present(ac, animated: true)
    }
    
    override func tableView(_ tableView: UITableView,
                            numberOfRowsInSection section: Int) -> Int {
        return shoppingList.count
    }
    
    override func tableView(_ tableView: UITableView,
                            cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Item",
                                                 for: indexPath)
        cell.textLabel?.text = shoppingList[indexPath.row]
        return cell
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }


}

