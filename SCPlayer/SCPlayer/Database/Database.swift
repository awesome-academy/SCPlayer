//
//  Database.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 18/05/2021.
//

import Foundation
import SQLite

class Database {
    
    static let shared = Database()
    
    public let connection: Connection?
    
    public let databaseFilename = "likeTrack.sqlite3"
    
    private init() {
        do {
            if let databasePath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true).first {
                connection = try Connection("\(databasePath)/\(databaseFilename)")
            } else {
                print("Can not get databasePath")
                connection = nil
            }
        } catch {
            print("Can not connect database with error: \(error)")
            connection = nil
        }
    }
}
