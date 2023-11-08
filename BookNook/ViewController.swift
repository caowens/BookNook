//
//  ViewController.swift
//  BookNook
//
//  Created by Alex Owens on 11/7/23.
//

import UIKit

class ViewController: UIViewController, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 50
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        
        cell.textLabel?.text = "Row \(indexPath.row)"
        
        return cell
    }
    

    @IBOutlet weak var homeTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        homeTableView.dataSource = self
    }


}

