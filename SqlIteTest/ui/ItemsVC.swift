//
//  ItemsVC.swift
//  SqlIteTest
//
//  Created by Doniyorbek on 12/12/20.
//  Copyright © 2020 Bekmurod Turgunov. All rights reserved.
//

import UIKit
import Foundation

class ItemsVC: UIViewController, UITableViewDelegate, UITableViewDataSource {
    
    let cellReuseIdentifier = "cell"
    
    lazy var tableView: UITableView = {
        let tv = UITableView()
        tv.register(UITableViewCell.self, forCellReuseIdentifier: cellReuseIdentifier)
        tv.translatesAutoresizingMaskIntoConstraints = false
        return tv
    }()
    var db: SqlIteDB = SqlIteDB()
    var itemArray: [Item] = []
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
        
        if !(db.getItemsByPaging().count > 0) {
            for i in 1...100 {
                db.insertItem(name: "TestItem\(i)")
            }
        }
        itemArray = db.getItemsByPaging()
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return itemArray.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell:UITableViewCell = tableView.dequeueReusableCell(withIdentifier: cellReuseIdentifier)!
        let item = itemArray[indexPath.row]
        cell.textLabel?.numberOfLines = 3
        cell.textLabel?.text = "Id: " + String(item.id) + ", name: " + item.name
        if indexPath.row == itemArray.count - 1 && !paginationEndded {
            loadNextPage()
        }
        return cell
    }
    
    private func scrollToTop() {
        let topRow = IndexPath(row: 0, section: 0)
        self.tableView.scrollToRow(at: topRow, at: .top, animated: true)
    }
    
    func loadNextPage() {
        let cur = db.getItemsByPaging(page: currentPage)
        if cur.count < 10 {
            paginationEndded = true
        }
        currentPage += 1
        for element in cur {
            itemArray.append(element)
        }
        tableView.reloadData()
    }
    
    func setUpNavBar() {
        let navButton = UIBarButtonItem(title: "Add", style: .plain, target: self, action: #selector(navButtonTapped))
        self.navigationItem.rightBarButtonItem  = navButton
    }
    
    @objc func navButtonTapped() {
        let randomInt = Int.random(in: 1..<10000)
        db.insertItem(name: "TestItem\(randomInt)")
        let last10 = db.getItemsByPaging()
        itemArray.insert(last10[0], at: 0)
        tableView.reloadData()
        scrollToTop()
    }
    
}
