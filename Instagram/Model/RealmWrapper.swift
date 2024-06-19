//
//  RealmWrapper.swift
//  Instagram
//
//  Created by Mario Ban on 07.06.2024..
//

import Foundation
import RealmSwift

protocol RealmRepository {
    func save<T: Object>(object: T) throws
    func fetch<T: Object>(_ objectType: T.Type) -> Results<T>?
    func delete<T: Object>(object: T) throws
    func exists<T: Object>(_ objectType: T.Type, id: String) -> Bool
    func deleteById<T: Object>(_ objectType: T.Type, id: String) throws
}

class RealmRepositoryImpl: RealmRepository {

    private let realm: Realm

    init() {
        do {
            self.realm = try Realm()
        } catch {
            fatalError("Failed to initialize Realm: \(error.localizedDescription)")
        }
    }

    func save<T: Object>(object: T) throws {
        do {
            try realm.write {
                realm.add(object, update: .all)
            }
        } catch {
            throw error
        }
    }

    func fetch<T: Object>(_ objectType: T.Type) -> Results<T>? {
        return realm.objects(objectType)
    }

    func delete<T: Object>(object: T) throws {
        do {
            try realm.write {
                realm.delete(object)
            }
        } catch {
            throw error
        }
    }

    func exists<T: Object>(_ objectType: T.Type, id: String) -> Bool {
        let objects = realm.objects(objectType)
        return objects.filter("id == %@", id).count != 0
    }

    func deleteById<T: Object>(_ objectType: T.Type, id: String) throws {
        do {
            if let objectToDelete = realm.object(ofType: objectType, forPrimaryKey: id) {
                try realm.write {
                    realm.delete(objectToDelete)
                }
            }
        } catch {
            throw error
        }
    }
}


/*
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
*/
