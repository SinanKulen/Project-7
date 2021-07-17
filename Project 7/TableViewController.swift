//
//  TableViewController.swift
//  Project 7
//
//  Created by Sinan Kulen on 15.07.2021.
//

import UIKit

class TableViewController: UITableViewController {

    var petitions = [Petition]()
    var filtrePetition = [Petition]()
    var savePetition = [Petition]()
    
    override func viewDidLoad() {
        super.viewDidLoad()
     
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .organize, target: self, action: #selector(creditButton))
        navigationItem.leftBarButtonItem = UIBarButtonItem(barButtonSystemItem: .bookmarks, target: self, action: #selector(filterButton))
        title = "Are you initializer ?"
        
        let urlString : String
        
        if navigationController?.tabBarItem.tag == 0 {
        urlString = "https://www.hackingwithswift.com/samples/petitions-1.json"
        } else if navigationController?.tabBarItem.tag == 1 {
          urlString = "https://www.hackingwithswift.com/samples/petitions-2.json"
        } else {
            urlString = "https://www.hackingwithswift.com/samples/petitions-3.json"
        }
       
        if let url = URL(string: urlString){
            if let data = try? Data(contentsOf: url){
                parse(json: data)
            }
        }
        
        func parse(json:Data){
            let decoder = JSONDecoder()
            
            if let jsonPetitions = try? decoder.decode(Petitions.self, from: json){
                petitions = jsonPetitions.results
                tableView.reloadData()
                savePetition = petitions
            }
        }
    }

    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return petitions.count
    }

    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell", for: indexPath)
        let petition = petitions[indexPath.row]
        cell.textLabel?.text = petition.title
        cell.detailTextLabel?.text = petition.body
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let vc = DetailViewController()
        vc.detailItem = petitions[indexPath.row]
        navigationController?.pushViewController(vc, animated: true)
    }

    @objc func creditButton() {
        let ac = UIAlertController(title: "Credit", message: "The data comes from the We The People API of the Whitehouse", preferredStyle: .alert)
        ac.addAction(UIAlertAction(title: "Ok", style: .default, handler: nil))
        present(ac, animated: true, completion: nil)
    }
    
    @objc func filterButton() {
        let filterAlert = UIAlertController(title: "Please writing filter to textField", message: nil, preferredStyle: UIAlertController.Style.alert)
        filterAlert.addTextField()
        
        let filterAction = UIAlertAction(title: "Filter", style: .default) { _ in
            guard let filter = filterAlert.textFields?[0].text else { return }
            self.filtreAlert(filter)
        }
        
        let resetAction = UIAlertAction(title: "Reset", style: .destructive) { _ in
            self.resetButton()
        }
        filterAlert.addAction(resetAction)
        filterAlert.addAction(filterAction)
        present(filterAlert, animated: true)
    }
    
    func filtreAlert(_ word : String) {
        filtrePetition.removeAll()
        for petition in savePetition {
            if petition.body.lowercased().contains(word.lowercased()) {
                filtrePetition.append(petition)
            }
        }
        if filtrePetition.isEmpty { return }
        petitions = filtrePetition
        tableView.reloadData()
    }
    
    func resetButton(){
        petitions = savePetition
        tableView.reloadData()
    }
}
