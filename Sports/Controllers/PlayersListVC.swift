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

    // MARK: - Variables
    var sport: Sport!

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
}

// MARK: - UITableViewDataSource
extension PlayersListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sport.players?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        let player = sport.players?[indexPath.row] as? Player
        cell.textLabel?.text = "\(player?.name ?? "") - Age: \(player?.age ?? ""), Height: \(player?.height ?? "")"
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PlayersListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        let player = sport.players?[indexPath.row] as? Player
        showInputDialog(title: "Edit Player",
                        subtitle: "Edit already existing Player",
                        name: player?.name,
                        age: player?.age,
                        height: player?.height,
                        actionHandler:
                            { [weak self] name, age, height in
            let player = self?.sport?.players?[indexPath.row] as? Player
            player?.name = name
            player?.age = age
            player?.height = height
            CoreDataManager.saveContext()
            self?.tableView.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.deletePlayer(sport.players?[indexPath.row] as! Player, sport)
            tableView.reloadData()
        }
    }
}

// MARK: - Private Methods
extension PlayersListVC {
    private func setupUI() {
        title = sport.name
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
    }

    @objc private func addTapped() {
        showInputDialog(title: "New Player",
                        subtitle: "Add a new Player",
                        actionHandler:
                            { [weak self] name, age, height in
            CoreDataManager.savePlayer(name, age, height, (self?.sport)!)
            self?.tableView.reloadData()
        })
    }

    private func showInputDialog(title: String? = nil,
                                 subtitle: String? = nil,
                                 actionTitle: String? = "Save",
                                 cancelTitle: String? = "Cancel",
                                 name: String? = nil,
                                 age: String? = nil,
                                 height: String? = nil,
                                 inputPlaceholder: String? = nil,
                                 cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                                 actionHandler: ((_ text: String?, _ text: String?, _ text: String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.text = name
            textField.placeholder = "Enter Name"
        }
        alert.addTextField { (textField:UITextField) in
            textField.text = age
            textField.placeholder = "Enter Age"
        }
        alert.addTextField { (textField:UITextField) in
            textField.text = height
            textField.placeholder = "Enter Height"
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let nameTextField = alert.textFields?[0],
                  let ageTextField = alert.textFields?[1],
                  let heightTextField = alert.textFields?[2]
            else {
                actionHandler?(nil, nil, nil)
                return
            }
            actionHandler?(nameTextField.text, ageTextField.text, heightTextField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))

        self.present(alert, animated: true, completion: nil)
    }
}
