//
//  TrackEntity.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 20/05/2021.
//

import Foundation
import SQLite3

class TrackEntity {
    
    static let shared = TrackEntity()
    
    private var database = Database.shared.getInstance()
    
    public func insertNewTrack(idRow: String, trackId: Int, playlistName: String) {
        let insertStatementString = "INSERT INTO trackOfPlaylistTable (idRow, trackId, playlistName) VALUES (?, ?, ?);"
        var insertStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(database, insertStatementString, -1, &insertStatement, nil) == SQLITE_OK {
            
            let idRow = idRow as NSString
            let trackId = Int32(trackId)
            let playlistName = playlistName as NSString
        
            sqlite3_bind_text(insertStatement, 1, idRow.utf8String, -1, nil)
            sqlite3_bind_int(insertStatement, 2, trackId)
            sqlite3_bind_text(insertStatement, 3, playlistName.utf8String, -1, nil)
            
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
    
    public func getAllTrackInPlaylist(playlistName: String) -> [Int]? {
        let playlistNameFormat = "\"\(playlistName)\""
        let queryStatementString = """
        SELECT trackId FROM trackOfPlaylistTable WHERE playlistName = \(playlistNameFormat);
        """
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
    
    public func updatePlaylistName(oldName: String, newName: String) {
        let oldNameFormat = "\"\(oldName)\""
        let newNameFormat = "\"\(newName)\""
        let updateStatementString = """
            UPDATE trackOfPlaylistTable SET playlistName = \(newNameFormat) WHERE playlistName = \(oldNameFormat);
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
        sqlite3_finalize(updateStatement)
    }
    
    public func deleteTrackById(idRow: String) {
        let idRowFormat = "\"\(idRow)\""
        let deleteStatementString = "DELETE FROM trackOfPlaylistTable WHERE idRow = \(idRowFormat);"
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
