//
//  Database.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 18/05/2021.
//

import Foundation
import SQLite3

class Database {
    
    static let shared = Database()
    
    private var database: OpaquePointer?
   
    private let createLikedTrackTableQueryString =
        """
        CREATE TABLE IF NOT EXISTS likedTrackTable ( trackId INT PRIMARY KEY NOT NULL );
        """
    private let createPlaylistTableQueryString =
        """
        CREATE TABLE IF NOT EXISTS playlistTable ( playlistName CHAR(255) PRIMARY KEY NOT NULL );
        """
    private let createTrackTableQueryString =
        """
        CREATE TABLE IF NOT EXISTS trackOfPlaylistTable (
        idRow CHAR(255) PRIMARY KEY NOT NULL,
        trackId INT NOT NULl,
        playlistName CHAR(255) NOT NULL,
        FOREIGN KEY (playlistName) REFERENCES playlistTable (playlistName) ON DELETE CASCADE);
        """
    
    private init() {
        database = getInstance()
        createTable(createTableString: createLikedTrackTableQueryString)
        createTable(createTableString: createPlaylistTableQueryString)
        createTable(createTableString: createTrackTableQueryString)
    }
    
    public func getInstance() -> OpaquePointer? {
        let path = "track.sqlite3"
        var database: OpaquePointer?
        
        do {
            let databasePath = try FileManager.default.url(for: .documentDirectory,
                                                           in: .userDomainMask,
                                                           appropriateFor: nil,
                                                           create: false).appendingPathExtension(path)
            if sqlite3_open(databasePath.path, &database) == SQLITE_OK {
                print("Successfully opened connection to database at \(databasePath)")
                return database
            } else {
                print("Unable to open database.")
                return nil
            }
        } catch {
            print("Unable to open database.")
            return nil
        }
    }
    
    public func createTable(createTableString: String) {
        var createTableStatement: OpaquePointer?
        
        if sqlite3_prepare_v2(database, createTableString, -1, &createTableStatement, nil) == SQLITE_OK {
            if sqlite3_step(createTableStatement) == SQLITE_DONE {
                print("\nTable created.")
            } else {
                print("\nTable is not created.")
            }
        } else {
            print("\nTable statement is not prepared.")
        }
        sqlite3_finalize(createTableStatement)
    }
    
    public func connectDatabase() {
        print("\nDatabase Connected")
    }
}
