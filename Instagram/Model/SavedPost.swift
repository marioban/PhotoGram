//
//  SavedPost.swift
//  Instagram
//
//  Created by Mario Ban on 06.06.2024..
//

import Foundation
import RealmSwift

class SavedPost: Object {
    @Persisted(primaryKey: true) var _id: ObjectId
    @Persisted var name: String
    @Persisted var ownerUid: String
    @Persisted var caption: String?
    @Persisted var likes: Int
    @Persisted var imageUrl: String
    @Persisted var timeStamp: Date
}
