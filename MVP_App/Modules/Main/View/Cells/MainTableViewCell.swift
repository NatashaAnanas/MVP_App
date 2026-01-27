//
//  MainTableViewCell.swift
//  MVP_App
//
//  Created by Наталья Коновалова on 26.01.2026.
//

import UIKit

final class MainTableViewCell: UITableViewCell {
    
    private let mainImageView: UIImageView = {
        let imageView = UIImageView()
        imageView.contentMode = .scaleAspectFill
        imageView.clipsToBounds = true
        imageView.translatesAutoresizingMaskIntoConstraints = false
        return imageView
    }()
    
    private let mainLabel: UILabel = {
        let label = UILabel()
        label.numberOfLines = 0
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        setupUI()
        setupConstraints()
    }
    
    override func prepareForReuse() {
        super.prepareForReuse()
        mainImageView.image = nil
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    func configure(title: String) {
        mainLabel.text = title
    }
    
    private func setupUI() {
        contentView.addSubview(mainLabel)
        contentView.addSubview(mainImageView)
    }

    func setImage(_ image: UIImage?) {
        mainImageView.image = image
    }
    
    private func setupConstraints() {
        NSLayoutConstraint.activate([
            mainImageView.widthAnchor.constraint(equalToConstant: 100),
            mainImageView.heightAnchor.constraint(equalToConstant: 100),
            mainImageView.topAnchor.constraint(equalTo: contentView.topAnchor),
            mainImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            mainImageView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor),
            
            mainLabel.leadingAnchor.constraint(equalTo: mainImageView.trailingAnchor, constant: 8),
            mainLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            mainLabel.centerYAnchor.constraint(equalTo: mainImageView.centerYAnchor),
        ])
    }
}
