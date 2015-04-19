//
//  voiceData.swift
//  polyglott
//
//  Created by Fred Flügge on 19.04.15.
//  Copyright (c) 2015 Fred Flügge. All rights reserved.
//

import Foundation

class voiceData: NSObject {
    var name: String
    var gender: String
    var lang: String
    var id: Int
    var synthID: Int
    
    override init() {
        self.name = String()
        self.gender = String()
        self.lang = String()
        self.id = Int()
        self.synthID = Int()
    }
    
    init(name: String, gender: String, lang: String, id: Int, synthID: Int){
        self.name = name
        self.gender = gender
        self.lang = lang
        self.id = id
        self.synthID = synthID
    }

}
