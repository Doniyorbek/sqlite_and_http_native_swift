//
//  RemoteVC.swift
//  SqlIteTest
//
//  Created by Doniyorbek on 12/12/20.
//  Copyright © 2020 Bekmurod Turgunov. All rights reserved.
//

import Foundation
import UIKit

class RemoteVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let id = "cell"
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(ZoneCell.self, forCellReuseIdentifier: id)
        tv.translatesAutoresizingMaskIntoConstraints = false
        tv.isHidden = true
        return tv
    }()
    
    lazy var reloadButton: UIButton = {
        let b = UIButton(type: .system)
        b.setTitle("Reload", for: .normal)
        b.translatesAutoresizingMaskIntoConstraints = false
        b.isHidden = true
        return b
    }()
    
    lazy var errorLabel: UILabel = {
        let l = UILabel()
        l.translatesAutoresizingMaskIntoConstraints = false
        l.isHidden = true
        return l
    }()
    
    var myArray: [DataItem] = []
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.addSubview(errorLabel)
        view.addSubview(reloadButton)
        view.addSubview(tableView)
        
        reloadButton.addTarget(self, action: #selector(reloadButtonTapped), for: .touchUpInside)
        tableView.delegate = self
        tableView.dataSource = self
        
        
        let consts = [
            errorLabel.centerYAnchor.constraint(equalTo: view.centerYAnchor),
            errorLabel.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reloadButton.centerXAnchor.constraint(equalTo: view.centerXAnchor),
            reloadButton.topAnchor.constraint(equalTo: errorLabel.bottomAnchor, constant: 10),
            
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(consts)
        
        fetchData()
    }
    
    func fetchData() {
        var request = URLRequest(url: URL(string: "https://adsrv.sab-lab.com/api/show/app/60?uuid=fghy123sdasdasdasdasafgdfgdfa&secret=bqgqkbxgOaU3pPEt")!, timeoutInterval: 10)
        request.httpMethod = "GET"

        let task = URLSession.shared.dataTask(with: request) { data, response, error in
          guard let data = data else {
            print(String(describing: error?.localizedDescription))
            DispatchQueue.main.async {
                self.reloadButton.isHidden = false
                self.errorLabel.isHidden = false
                self.errorLabel.text = error?.localizedDescription
            }
            return
          }
            print(String(data: data, encoding: .utf8)!)
            do {
                let jsonResult = try JSONDecoder().decode(MyData.self, from: data)
                for element in jsonResult.zone {
                    self.myArray.append(element)
                }
                self.showResultUI()
            } catch {
                print(error)
            }
        }
        task.resume()
    }
        
    func showResultUI() {
        DispatchQueue.main.async {
            self.tableView.isHidden = false
            self.tableView.reloadData()
        }
    }
    
    @objc func reloadButtonTapped() {
        tableView.isHidden = true
        reloadButton.isHidden = true
        errorLabel.isHidden = true
        fetchData()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return myArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: id)! as? ZoneCell
        let data = myArray[indexPath.row]
        cell?.setModel(data: data)
        return cell!
    }
    
    
}
