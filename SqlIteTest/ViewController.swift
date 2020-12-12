//
//  ViewController.swift
//  SqlIteTest
//
//  Created by Doniyorbek on 12/11/20.
//  Copyright © 2020 Bekmurod Turgunov. All rights reserved.
//

import UIKit
import Foundation

class ViewController: UIViewController {
    
    lazy var label: UILabel = {
        let l = UILabel()
        l.text = "Splash screen"
        l.font = UIFont.systemFont(ofSize: 22)
        l.textColor = .black
        l.translatesAutoresizingMaskIntoConstraints = false
        return l
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(label)
        
        let const = [
            label.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            label.centerXAnchor.constraint(equalTo: view.centerXAnchor),
        ]
        NSLayoutConstraint.activate(const)
        DispatchQueue.main.asyncAfter(deadline: .now() + 5.0, execute: {
                let vc = MyNavVC()
                let nv = UINavigationController(rootViewController: vc)
                nv.modalPresentationStyle = .fullScreen
                self.present(nv, animated: true, completion: nil)
        })
    }
}

