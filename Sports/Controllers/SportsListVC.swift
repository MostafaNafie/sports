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
        let title = sports[indexPath.row].name
        goToSportDetailsVC(with: title)
    }

    func tableView(_ tableView: UITableView, accessoryButtonTappedForRowWith indexPath: IndexPath) {
        showInputDialog(title: "Edit Sport",
                        subtitle: "Edit already existing Sport",
                        actionTitle: "Save",
                        cancelTitle: "Cancel",
                        inputText: sports[indexPath.row].name,
                        inputPlaceholder: "Sport",
                        inputKeyboardType: .alphabet, actionHandler:
                            { [weak self] (sportName: String?) in
            self?.sports[indexPath.row].name = sportName
            self?.tableView.reloadData()
        })
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

        let imageName = UUID().uuidString
        let imagePath = getDocumentsDirectory().appendingPathComponent(imageName)

        if let jpegData = image.jpegData(compressionQuality: 0.8) {
            try? jpegData.write(to: imagePath)
            sports[selectedSportIndex].imagePath = imagePath.path
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
                        actionTitle: "Save",
                        cancelTitle: "Cancel",
                        inputPlaceholder: "Sport",
                        inputKeyboardType: .alphabet, actionHandler:
                            { [weak self] (sportName: String?) in
            self?.sports.append(.init(name: sportName, imagePath: nil))
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

    private func getDocumentsDirectory() -> URL {
        let paths = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        return paths[0]
    }
}

