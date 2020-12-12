//
//  SqlIteDB.swift
//  SqlIteTest
//
//  Created by Doniyorbek on 12/11/20.
//  Copyright © 2020 Bekmurod Turgunov. All rights reserved.
//

import SQLite3
import Foundation

class SqlIteDB {
    
    init() {
        db = openDatabase()
        createUserTable()
        createItemTable()
    }

    let dbPath: String = "my.db"
    var db:OpaquePointer?

    func openDatabase() -> OpaquePointer? {
        let fileURL = try! FileManager.default.url(for: .documentDirectory, in: .userDomainMask, appropriateFor: nil, create: false)
            .appendingPathComponent(dbPath)
        var db: OpaquePointer? = nil
        if sqlite3_open(fileURL.path, &db) != SQLITE_OK {
            return nil
        }
        else {
            return db
        }
    }
    
    func createUserTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS user(Id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT,user_name TEXT, created_time TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("user table created.")
            } else {
                print("user table create error")
            }
        } else {
            print("create table error")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func createItemTable() {
        let createTableString = "CREATE TABLE IF NOT EXISTS item(Id INTEGER PRIMARY KEY AUTOINCREMENT,name TEXT);"
        var createTableStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("item table created.")
            } else {
                print("item created error")
            }
        } else {
            print("create table error")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    func insertUser(name: String, createdTime: String, userName: String = "") {
        let insertStatementString = "INSERT INTO user (Id, name, user_name, created_time) VALUES (?, ?, ?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 3, (userName as NSString).utf8String, -1, nil)
            sqlite3_bind_text(insertStatement, 4, (createdTime as NSString).utf8String, -1, nil)
            
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print(" inserted")
            } else {
                print("error")
            }
        } else {
            print("error")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func insertItem(name: String) {
        let insertStatementString = "INSERT INTO item (Id, name) VALUES (?, ?);"
        var insertStatement: OpaquePointer? = nil
        if sqlite3_prepare_v2(db, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_text(insertStatement, 2, (name as NSString).utf8String, -1, nil)
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("inserted")
            } else {
                print("error")
            }
        } else {
            print("error ")
        }
        sqlite3_finalize(insertStatement)
    }
    
    func getUsersByPaging(page: Int = 1) -> [User] {
        let offset = (page - 1) * 10
        let queryStatementString = "SELECT * FROM user ORDER BY Id DESC LIMIT 10 OFFSET \(offset);"
        var queryStatement: OpaquePointer? = nil
        var userArray : [User] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                let userName = String(describing: String(cString: sqlite3_column_text(queryStatement, 2)))
                let createdTime = String(describing: String(cString: sqlite3_column_text(queryStatement, 3)))
                userArray.append(User(id: Int(id), name: name, userName: userName, createdTime: createdTime))
                print("\(id) | \(name) | \(userName) | \(createdTime)")
            }
        } else {
            print("error")
        }
        sqlite3_finalize(queryStatement)
        return userArray
    }
    
    func getItemsByPaging(page: Int = 1) -> [Item] {
        let offset = (page - 1) * 10
        let queryStatementString = "SELECT * FROM item ORDER BY Id DESC LIMIT 10 OFFSET \(offset);"
        var queryStatement: OpaquePointer? = nil
        var itemArray : [Item] = []
        if sqlite3_prepare_v2(db, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let id = sqlite3_column_int(queryStatement, 0)
                let name = String(describing: String(cString: sqlite3_column_text(queryStatement, 1)))
                itemArray.append(Item(id: Int(id), name: name))
                print("\(id) | \(name)")
            }
        } else {
            print("error")
        }
        sqlite3_finalize(queryStatement)
        return itemArray
    }
}
