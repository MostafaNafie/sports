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
    var players = [Player]()

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
        players.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Cell")! as UITableViewCell
        let player = players[indexPath.row]
        cell.textLabel?.text = "\(player.name ?? "") - Age: \(player.age ?? ""), Height: \(player.height ?? "")"
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PlayersListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        showInputDialog(title: "Edit Player",
                        subtitle: "Edit already existing Player",
                        name: players[indexPath.row].name,
                        age: players[indexPath.row].age,
                        height: players[indexPath.row].height,
                        actionHandler:
                            { [weak self] name, age, height in
            self?.players[indexPath.row].name = name
            self?.players[indexPath.row].age = age
            self?.players[indexPath.row].height = height
            self?.tableView.reloadData()
        })
    }
}

// MARK: - Private Methods
extension PlayersListVC {
    private func setupUI() {
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
            self?.players.append(.init(name: name, age: age, height: height))
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
