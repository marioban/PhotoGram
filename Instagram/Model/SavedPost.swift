//
//  SavedPost.swift
//  Instagram
//
//  Created by Mario Ban on 05.06.2024..
//

import Foundation
import RealmSwift

class SavedPost: Object {
    @Persisted(primaryKey: true) var id: String
    @Persisted var ownerUid: String
    @Persisted var caption: String?
    @Persisted var likes: Int
    @Persisted var imageUrl: String
    @Persisted var timeStamp: Date
    @Persisted var isSaved: Bool = false

    convenience init(firebasePost: Post) {
        self.init()
        self.id = firebasePost.id
        self.ownerUid = firebasePost.ownerUid
        self.caption = firebasePost.caption
        self.likes = firebasePost.likes
        self.imageUrl = firebasePost.imageUrl
        self.timeStamp = firebasePost.timeStamp.dateValue()
        self.isSaved = firebasePost.isSaved ?? false
    }
}


