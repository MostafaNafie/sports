//
//  PlayersListVC.swift
//  Sports
//
//  Created by Mostafa Nafie on 1/11/21.
//

import UIKit

class PlayersListVC: UIViewController {

    // MARK: - Oulets
    @IBOutlet weak var tableView: UITableView!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.

        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }

    // MARK: - Private Methods
    @objc private func addTapped() {
    }
}

