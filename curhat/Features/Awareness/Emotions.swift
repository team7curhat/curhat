//
//  Emotions.swift
//  curhat
//
//  Created by Sakti Pardano on 08/05/25.
//

import Foundation

struct Emotions: Identifiable {
    var id = UUID()
    var name: String
    var label: String
    var imageString: String
}

let listEmotions: [Emotions] = [
    Emotions(name: "happy", label: "Senang Bingits", imageString: "awareness-happy"),
    Emotions(name: "sad", label: "Aku lagi sedih", imageString: "awareness-sad"),
    Emotions(name: "angry", label: "Marahh", imageString: "awareness-angry"),
    Emotions(name: "terrified", label: "Takut huhu", imageString: "awareness-terrified"),
    Emotions(name: "shook", label: "Weih Kaghed", imageString: "awareness-shook"),
    Emotions(name: "worry", label: "Khawatir", imageString: "awareness-worry"),
    Emotions(name: "unsure", label: "Ntah, hanya tuhan yang tahu", imageString: "awareness-unsure")
]
