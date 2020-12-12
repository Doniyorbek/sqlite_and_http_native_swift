//
//  UserVC.swift
//  SqlIteTest
//
//  Created by Doniyorbek on 12/11/20.
//  Copyright © 2020 Bekmurod Turgunov. All rights reserved.
//

import UIKit
import Foundation

class UserVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let id = "cell"
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: id)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    var db: SqlIteDB = SqlIteDB()
    var userArray: [User] = []
    var currentPage = 1
    var paginationEndded = false
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setUpNavBar()
        
        tableView.delegate = self
        tableView.dataSource = self
        
        self.view.addSubview(tableView)
        let consts = [
            tableView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            tableView.trailingAnchor.constraint(equalTo: view.trailingAnchor),
            tableView.topAnchor.constraint(equalTo: view.topAnchor),
            tableView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
        ]
        NSLayoutConstraint.activate(consts)
        
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dateString = dateFormat.string(from: date)
        if !(db.getUsersByPaging().count > 0) {
            for i in 1...100 {
                db.insertUser(name: "TestUser", createdTime: dateString, userName: "UserName\(i)")
            }
        }
        userArray = db.getUsersByPaging()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return userArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: id)!
        let user = userArray[indexPath.row]
        print("created time => \(user.createdTime)")
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = "Id: " + String(user.id) + ", name: " + user.name + ", user name: " + user.userName + ", created time: " + user.createdTime
        if indexPath.row == userArray.count - 1 && !paginationEndded {
            loadNextPage()
        }
        return cell
    }
    
    private func scrollToTop() {
        let topRow = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
    
    func loadNextPage() {
        let cur = db.getUsersByPaging(page: currentPage)
        if cur.count < 10 {
            paginationEndded = true
        }
        currentPage += 1
        for element in cur {
            userArray.append(element)
        }
        tableView.reloadData()
    }
    
    func setUpNavBar() {
        let navButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(navButtonTapped))
        self.navigationItem.rightBarButtonItem  = navButton
    }
    
    @objc func navButtonTapped() {
        let date = Date()
        let dateFormat = DateFormatter()
        dateFormat.dateFormat = "YYYY-MM-dd HH:mm:ss"
        let dateString = dateFormat.string(from: date)
        db.insertUser(name: "TestUser", createdTime: dateString, userName: "UserName\(10)")
        let last10 = db.getUsersByPaging()
        userArray.insert(last10[0], at: 0)
        tableView.reloadData()
        scrollToTop()
    }
    
}
