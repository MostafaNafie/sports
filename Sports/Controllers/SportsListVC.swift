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

    // MARK: - Variables
    private var sports: [Sport]?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
    }
}

// MARK: - UITableViewDataSource
extension SportsListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sports?.count ?? 0
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SportCell.self)) as! SportCell
        cell.textLabel?.text = sports?[indexPath.row].name
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SportsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let title = sports?[indexPath.row].name
        goToSportDetailsVC(with: title)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        showInputDialog(title: "Edit Sport",
                        subtitle: "Edit already existing Sport",
                        actionTitle: "Save",
                        cancelTitle: "Cancel",
                        inputText: sports?[indexPath.row].name,
                        inputPlaceholder: "Sport",
                        inputKeyboardType: .alphabet, actionHandler:
                            { [weak self] (sportName: String?) in
            self?.sports?[indexPath.row].name = sportName
            self?.tableView.reloadData()
        })
    }
}

// MARK: - Private Methods
extension SportsListVC {
    private func setupUI() {
        title = "Sports"
        navigationItem.rightBarButtonItem = UIBarButtonItem(barButtonSystemItem: .add, target: self, action: #selector(addTapped))
    }

    private func setupTableView() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: String(describing: SportCell.self), bundle: nil)
        tableView.register(nib, forCellReuseIdentifier: String(describing: SportCell.self))
    }

    @objc private func addTapped() {
        showInputDialog(title: "New Sport",
                        subtitle: "Add a new Sport",
                        actionTitle: "Save",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "Sport",
                        inputKeyboardType: .alphabet, actionHandler:
                            { [weak self] (sportName: String?) in
            self?.sports?.append(.init(name: sportName, image: nil))
            self?.tableView.reloadData()
        })
    }

    private func goToSportDetailsVC(with title: String?) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sportsDetailsVC = storyboard.instantiateViewController(withIdentifier: String(describing: PlayersListVC.self))
        sportsDetailsVC.title = title
        navigationController?.pushViewController(sportsDetailsVC, animated: true)
    }

    private func showInputDialog(title:String? = nil,
                         subtitle:String? = nil,
                         actionTitle:String? = "Add",
                         cancelTitle:String? = "Cancel",
                                 inputText:String? = nil,
                         inputPlaceholder:String? = nil,
                         inputKeyboardType:UIKeyboardType = UIKeyboardType.default,
                         cancelHandler: ((UIAlertAction) -> Swift.Void)? = nil,
                         actionHandler: ((_ text: String?) -> Void)? = nil) {

        let alert = UIAlertController(title: title, message: subtitle, preferredStyle: .alert)
        alert.addTextField { (textField:UITextField) in
            textField.text = inputText
            textField.placeholder = inputPlaceholder
            textField.keyboardType = inputKeyboardType
        }
        alert.addAction(UIAlertAction(title: actionTitle, style: .default, handler: { (action:UIAlertAction) in
            guard let textField =  alert.textFields?.first else {
                actionHandler?(nil)
                return
            }
            actionHandler?(textField.text)
        }))
        alert.addAction(UIAlertAction(title: cancelTitle, style: .cancel, handler: cancelHandler))

        self.present(alert, animated: true, completion: nil)
    }
}

