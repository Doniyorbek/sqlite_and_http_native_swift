//
//  MyNavVC.swift
//  SqlIteTest
//
//  Created by Doniyorbek on 12/12/20.
//  Copyright © 2020 Bekmurod Turgunov. All rights reserved.
//

import UIKit

class MyNavVC: UIViewController {
    
    lazy var firstButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("First page", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.tag = 1
        return b
    }()
    
    lazy var secondButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Second page", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.tag = 2
        return b
    }()
    
    lazy var thirdButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Third page", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.tag = 3
        return b
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.setUpNavBar()
        self.view.addSubview(firstButton)
        self.view.addSubview(secondButton)
        self.view.addSubview(thirdButton)
        
        firstButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        secondButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)
        thirdButton.addTarget(self, action: #selector(buttonTapped(_:)), for: .touchUpInside)

        let constraints = [
            firstButton.bottomAnchor.constraint(equalTo: self.secondButton.topAnchor, constant: -20),
            firstButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            secondButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
            secondButton.centerYAnchor.constraint(equalTo: self.view.centerYAnchor),
            thirdButton.topAnchor.constraint(equalTo: self.secondButton.bottomAnchor, constant: 20),
            thirdButton.centerXAnchor.constraint(equalTo: self.view.centerXAnchor),
        ]
        NSLayoutConstraint.activate(constraints)
            
    }
    
    @objc func buttonTapped(_ sender: UIButton) {
        var vc: UIViewController!
        switch sender.tag {
        case 1:
            vc = UserVC()
            break
        case 2:
            vc = RemoteVC()
            break
        case 3:
            vc = ItemsVC()
            break
        default:
            vc = nil
        }
        if let checkedVC = vc {
            self.navigationController?.pushViewController(checkedVC, animated: true)
        }
    }
    
    func setUpNavBar() {
        self.navigationController?.view.backgroundColor = UIColor.white
        self.navigationController?.view.tintColor = UIColor.orange
        self.navigationItem.title = "Main"
    }
}
