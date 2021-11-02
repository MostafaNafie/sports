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
    private var sports = [Sport]()
    private var selectedSportIndex = 0

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        sports = CoreDataManager.loadSports() ?? [Sport]()
    }
}

// MARK: - UITableViewDataSource
extension SportsListVC: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        sports.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: String(describing: SportCell.self)) as! SportCell
        cell.delegate = self
        cell.configureCell(with: sports[indexPath.row])
        return cell
    }
}

// MARK: - UITableViewDelegate
extension SportsListVC: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let sport = sports[indexPath.row]
        goToPlayersListVC(with: sport)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        showInputDialog(title: "Edit Sport",
                        subtitle: "Edit already existing Sport",
                        inputText: sports[indexPath.row].name,
                        inputPlaceholder: "Sport",
                        actionHandler:
                            { [weak self] (sportName: String?) in
            self?.sports[indexPath.row].name = sportName
            CoreDataManager.saveContext()
            self?.tableView.reloadData()
        })
    }

    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            CoreDataManager.deleteSport(sports[indexPath.row])
            sports = CoreDataManager.loadSports() ?? [Sport]()
            tableView.reloadData()
        }
    }
}

// MARK: - SportCellDelegate
extension SportsListVC: SportCellDelegate {
    func sportCellViewDidTapAddImage(_ cell: SportCell) {
        selectedSportIndex = tableView.indexPath(for: cell)?.row ?? 0
        let picker = UIImagePickerController()
        picker.allowsEditing = true
        picker.delegate = self
        present(picker, animated: true)
    }
}

// MARK: - UIImagePickerControllerDelegate
extension SportsListVC: UIImagePickerControllerDelegate, UINavigationControllerDelegate {
    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [UIImagePickerController.InfoKey : Any]) {
        guard let image = info[.editedImage] as? UIImage else { return }

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            sports[selectedSportIndex].imageData = jpegData
            CoreDataManager.saveContext()
        }

        tableView.reloadData()
        dismiss(animated: true)
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
                        inputPlaceholder: "Sport",
                        actionHandler:
                            { [weak self] (sportName: String?) in
            CoreDataManager.saveSport(sportName)
            self?.sports = CoreDataManager.loadSports() ?? [Sport]()
            self?.tableView.reloadData()
        })
    }

    private func goToPlayersListVC(with sport: Sport) {
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let sportsDetailsVC = storyboard.instantiateViewController(withIdentifier: String(describing: PlayersListVC.self)) as! PlayersListVC
        sportsDetailsVC.sport = sport
        navigationController?.pushViewController(sportsDetailsVC, animated: true)
    }

    private func showInputDialog(title: String? = nil,
                         subtitle: String? = nil,
                         actionTitle: String? = "Save",
                         cancelTitle: String? = "Cancel",
                                 inputText: String? = nil,
                         inputPlaceholder: String? = nil,
                         inputKeyboardType: UIKeyboardType = UIKeyboardType.default,
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
