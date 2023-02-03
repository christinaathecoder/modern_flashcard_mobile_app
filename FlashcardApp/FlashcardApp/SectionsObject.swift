//
//  SectionsObject.swift
//  Flashcard App
//
//  Created by christinaathecoder on 7/5/22.
//

import UIKit

class SectionsObject: NSObject, Codable {
    var subject: String = ""
    var deck: String = ""
    var flashcards: [[String:String]] = [[:]]
}
