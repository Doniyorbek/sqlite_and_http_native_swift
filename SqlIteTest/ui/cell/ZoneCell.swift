//
//  ZoneCell.swift
//  SqlIteTest
//
//  Created by Doniyorbek on 12/13/20.
//  Copyright © 2020 Bekmurod Turgunov. All rights reserved.
//

import Foundation
import UIKit

class ZoneCell: UITableViewCell {
    
    private let backgroundImage: UIImageView = {
        let iv = UIImageView()
        iv.translatesAutoresizingMaskIntoConstraints = false
        iv.contentMode = .scaleAspectFill
        iv.layer.cornerRadius = 6.0
        iv.clipsToBounds = true
        return iv
    }()
    
    private let nameLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.font = UIFont.boldSystemFont(ofSize: 15)
        l.numberOfLines = 1
        l.textColor = UIColor.black.withAlphaComponent(0.8)
        return l
    }()
    
    var curImage: UIImage? = nil
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        addSubview(backgroundImage)
        addSubview(nameLabel)
        
        let consts = [
            backgroundImage.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            backgroundImage.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
            backgroundImage.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            backgroundImage.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            backgroundImage.heightAnchor.constraint(equalToConstant: 150),
            nameLabel.centerYAnchor.constraint(equalTo: backgroundImage.centerYAnchor),
            nameLabel.centerXAnchor.constraint(equalTo: backgroundImage.centerXAnchor)
        ]
        NSLayoutConstraint.activate(consts)
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    public func setModel(data: DataItem) {
        nameLabel.text = data.name
        self.backgroundImage.image = nil
        getData(from: URL(string: data.files[0].url)!) { data, response, error in
            guard let data = data, error == nil else { return }
            DispatchQueue.main.async() { [weak self] in
                self?.curImage = UIImage(data: data)
                self?.backgroundImage.image = UIImage(data: data)
            }
        }
    }
    
    func getData(from url: URL, completion: @escaping (Data?, URLResponse?, Error?) -> ()) {
        URLSession.shared.dataTask(with: url, completionHandler: completion).resume()
    }
}
