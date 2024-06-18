//
//  RealmWrapper.swift
//  Instagram
//
//  Created by Mario Ban on 07.06.2024..
//

import Foundation
import RealmSwift

class RealmWrapper {
    
    static var realm: Realm {
        do {
            return try Realm()
        } catch {
            fatalError("Realm initialization error: \(error)")
        }
    }
    
    func saveObjects<T: Object>(objects: T) {
        do {
            try RealmWrapper.realm.write {
                RealmWrapper.realm.add(objects, update: .all)
            }
        } catch {
            print("Failed to save object: \(error.localizedDescription)")
        }
    }
    
    func getObjects<T: Object>(objects: T.Type) -> Results<T>? {
        return RealmWrapper.realm.objects(objects)
    }

    func deleteObjects<T: Object>(objects: T) {
        do{
            try RealmWrapper.realm.write{
                RealmWrapper.realm.delete(objects)
            }
        } catch{
            debugPrint(error)
        }
    }
    
    func doesExist(id: String) -> Bool {
        let posts = RealmWrapper.realm.objects(SavedPost.self)
        
        let query = posts.where {
            $0.id == id
        }
        
        return query.count != 0
    }
    
    func deletePost(withId id: String) async throws {
        let realm = try await Realm()
        guard let postToDelete = realm.object(ofType: SavedPost.self, forPrimaryKey: id) else {
            print("No post found with ID \(id) to delete.")
            return
        }
        try realm.write {
            realm.delete(postToDelete)
            print("Successfully deleted post with ID \(id).")
        }
    }
    
}


extension RealmWrapper {
    func saveObjects<T: Object>(objects: T) async throws {
        do {
            try RealmWrapper.realm.write {
                RealmWrapper.realm.add(objects, update: .all)
            }
        } catch {
            throw error
        }
    }
}
