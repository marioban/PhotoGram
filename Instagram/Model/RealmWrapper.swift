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
         do{
             try RealmWrapper.realm.write{
                 RealmWrapper.realm.add(objects)
             }
         } catch{
             debugPrint(error)
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
    
    func deletePost(withId id: String) {
        let posts = RealmWrapper.realm.objects(SavedPost.self)
        
        do {
            try RealmWrapper.realm.write {
                let query = posts.where {
                    $0.id == id
                }
                RealmWrapper.realm.delete(query)
            }
        } catch {
            debugPrint("Failed to delete post with id \(id): \(error)")
        }

    }
}
