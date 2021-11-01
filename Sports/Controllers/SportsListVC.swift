//
//  SportsListVC.swift
//  Sports
//
//  Created by Mostafa Nafie on 1/11/21.
//

import UIKit

class SportsListVC: UIViewController {

    // MARK: - Oulets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        title = "Sports"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }

    // MARK: - Private Methods
    @objc private func addTapped() {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sportsDetailsVC = storyboard.instantiateViewController(withIdentifier: String(describing: SportsDetailsVC.self))
        navigationController?.pushViewController(sportsDetailsVC, animated: true)
    }
}

