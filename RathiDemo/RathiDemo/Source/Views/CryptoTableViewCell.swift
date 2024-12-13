//
//  CryptoTableViewCell.swift
//  RathiDemo
//
//  Created by Rathi Shetty on 12/12/24.
//

import UIKit

class CryptoTableViewCell: UITableViewCell {
    private let nameLabel = UILabel()
    private let symbolLabel = UILabel()
    private let statusImageView = UIImageView()
    private let newTagImageView = UIImageView()

    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        let stackView = UIStackView(arrangedSubviews: [nameLabel, symbolLabel])
        stackView.axis = .vertical
        stackView.spacing = 4
        stackView.alignment = .leading
        
        contentView.addSubview(stackView)
        contentView.addSubview(statusImageView)
        contentView.addSubview(newTagImageView)
        
        stackView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.translatesAutoresizingMaskIntoConstraints = false
        statusImageView.contentMode = .scaleAspectFill
        newTagImageView.translatesAutoresizingMaskIntoConstraints = false
        contentView.bringSubviewToFront(statusImageView)

        
        NSLayoutConstraint.activate([
            stackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            stackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 8),
            stackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -8),
            statusImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            statusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 40),
            statusImageView.heightAnchor.constraint(equalToConstant: 40),
            newTagImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            newTagImageView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor),
            newTagImageView.widthAnchor.constraint(equalToConstant: 24),
            newTagImageView.heightAnchor.constraint(equalToConstant: 24)
        ])
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(with crypto: Crypto) {
        nameLabel.text = crypto.name
        symbolLabel.text = crypto.symbol
        if !crypto.isActive {
            statusImageView.image = UIImage(named: "Inactive")
        } else if crypto.type == "token" {
            statusImageView.image = UIImage(named: "token_icon")
        } else {
            statusImageView.image = UIImage(named: "coin_icon")
        }
        if crypto.isNew {
            newTagImageView.image = UIImage(named: "new_tag")
        }
    }
}
