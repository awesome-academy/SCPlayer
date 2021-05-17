//
//  TrackEntity.swift
//  SCPlayer
//
//  Created by Thuận Nguyễn Văn on 18/05/2021.
//

import Foundation
import SQLite

class TrackEntity {
    
    static let shared = TrackEntity()
    
    private let tableTrack = Table("tableTrack")
    
    private let trackID = Expression<Int>("trackID")
    
    private init() {
        do {
            if let connection = Database.shared.connection {
                try connection.run(tableTrack.create(temporary: false, ifNotExists: true, withoutRowid: false, block: { [unowned self] table in
                    table.column(self.trackID, primaryKey: true)
                }))
                print("Create table tableTrack Sucessfully")
            } else {
                print("Create table tableTrack Failed")
            }
        } catch {
            print("Create table tableTrack Failed: \(error)")
        }
    }
    
    func insert(trackID: Int) {
        do {
            let insert = tableTrack.insert(self.trackID <- trackID)
            try Database.shared.connection?.run(insert)
            print("Inserted Successfully !!!")
        } catch {
            print("Failed to insert: \(error)")
        }
    }
    
    func queryALl() -> AnySequence<Row>? {
        do {
            return try Database.shared.connection?.prepare(self.tableTrack)
        } catch {
            print("Failed to query all: \(error)")
            return nil
        }
    }
}
