//
//  SportCell.swift
//  Sports
//
//  Created by Mostafa Nafie on 1/11/21.
//

import UIKit

protocol SportCellDelegate {
    func sportCellViewDidTapAddImage(_ cell: SportCell)
}

class SportCell: UITableViewCell {

    // MARK: - Outlets
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var addImageButton: UIButton!
    @IBOutlet weak var sportImageView: UIImageView!

    // MARK: - variables
    var delegate: SportCellDelegate?

    override func prepareForReuse() {
        sportImageView.image = nil
    }

    // MARK: - Public Methods
    func configureCell(with sport: Sport) {
        nameLabel.text = sport.name
        if let imageData = sport.imageData {
            sportImageView.image = UIImage(data: imageData)
            addImageButton.setTitle("", for: .normal)
        } else {
            addImageButton.setTitle("Add image", for: .normal)
        }
    }

    // MARK: - Actions
    @IBAction func addImageButtonTapped() {
        delegate?.sportCellViewDidTapAddImage(self)
    }
}
