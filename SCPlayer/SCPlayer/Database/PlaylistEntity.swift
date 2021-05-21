//
//  PlaylistEntity.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 20/05/2021.
//

import Foundation
import SQLite3

class PlaylistEntity {
    
    static let shared = PlaylistEntity()
    
    private var database = Database.shared.getInstance()
    
    public func insertNewPlaylist(playlistName: String) {
        let insertStatementString = "INSERT INTO playlistTable (playlistName) VALUES (?);"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(database, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            let playlistName: NSString = playlistName as NSString
            
            sqlite3_bind_text(insertStatement, 1, playlistName.utf8String, -1, nil)
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
    
    public func getAllPlaylist() -> [String]? {
        let queryStatementString = "SELECT * FROM playlistTable;"
        var queryStatement: OpaquePointer?
        var list = [String]()
        
        if sqlite3_prepare_v2(database, queryStatementString, -1, &queryStatement, nil) == SQLITE_OK {
            while sqlite3_step(queryStatement) == SQLITE_ROW {
                if let playlistName = sqlite3_column_text(queryStatement, 0) {
                    list.append(String(cString: playlistName))
                }
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
    
    public func updatePlaylistName(oldName: String, newName: String) {
        let oldNameFormat = "\"\(oldName)\""
        let newNameFormat = "\"\(newName)\""
        let updateStatementString = """
            UPDATE playlistTable SET playlistName = \(newNameFormat) WHERE playlistName = \(oldNameFormat);
            """
        var updateStatement: OpaquePointer?
        if sqlite3_prepare_v2(database, updateStatementString, -1, &updateStatement, nil) == SQLITE_OK {
            if sqlite3_step(updateStatement) == SQLITE_DONE {
                print("\nSuccessfully updated row.")
            } else {
                print("\nCould not update row.")
            }
        } else {
            print("\nUPDATE statement is not prepared")
        }
        TrackEntity.shared.updatePlaylistName(oldName: oldName, newName: newName)
        sqlite3_finalize(updateStatement)
    }
    
    public func deletePlaylist(playlistName: String) {
        let platlistNameFormat = "\"\(playlistName)\""
        let deleteStatementString = "DELETE FROM playlistTable WHERE playlistName = \(platlistNameFormat);"
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
        TrackEntity.shared.deleteTrackByPlaylistName(playlistName: playlistName)
        sqlite3_finalize(deleteStatement)
    }
}
