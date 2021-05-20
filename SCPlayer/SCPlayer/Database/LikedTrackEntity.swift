//
//  LikedTrackEntity.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 20/05/2021.
//

import Foundation
import SQLite3

class LikedTrackEntity {
    
    static let shared = LikedTrackEntity()
    
    private let database = Database.shared.getInstance()
    
    public func insertNewLikedTrack(trackId: Int) {
        let insertStatementString = "INSERT INTO likedTrackTable (trackId) VALUES (?);"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(database, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            sqlite3_bind_int(insertStatement, 1, Int32(trackId))
            if sqlite3_step(insertStatement) == SQLITE_DONE {
                print("\nSuccessfully inserted row.")
            } else {
                print("\nCould not insert row.")
            }
        } else {
            print("\nInsert statement is not prepared.")
          }
        sqlite3_finalize(insertStatement)
    }
    
    func getAllIdLikedTrack() -> [Int]? {
        let queryStatementString = "SELECT * FROM likedTrackTable;"
        var queryStatement: OpaquePointer?
        var list = [Int]()
        
        if sqlite3_prepare_v2(database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                let trackId = sqlite3_column_int(queryStatement, 0)
                list.append(Int(trackId))
            }
            sqlite3_finalize(queryStatement)
            return list
        } else {
            let errorMessage = String(cString: sqlite3_errmsg(database))
            print("\nQuery is not prepared \(errorMessage)")
            sqlite3_finalize(queryStatement)
            return nil
        }
    }
    
    public func deleteLikedTrack(trackId: Int) {
        let deleteStatementString = "DELETE FROM likedTrackTable WHERE trackId = \(Int32(trackId));"
        var deleteStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, deleteStatementString, -1, &deleteStatement, nil) == SQLITE_OK {
          if sqlite3_step(deleteStatement) == SQLITE_DONE {
            print("\nSuccessfully deleted row.")
          } else {
            print("\nCould not delete row.")
          }
        } else {
          print("\nDelete statement could not be prepared")
        }
        sqlite3_finalize(deleteStatement)
    }
}
