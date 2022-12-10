//
//  NewDataModel.swift
//  Presenter
//
//  Created by Brian Holderness on 11/30/22.
//

import Foundation

class DataModel: ObservableObject, Identifiable, Hashable {
    let id = UUID()
    @Published var presentations: [Presentation]
    static private var lastOrder = 0
    
    init() {
        self.presentations = [
            .init(title: "CFM: January 2", customOrder: DataModel.getNewCustomOrder()),
            .init(title: "CFM: January 9", customOrder: DataModel.getNewCustomOrder()),
            .init(title: "CFM: January 16", customOrder: DataModel.getNewCustomOrder()),
            .init(title: "CFM: January 23", customOrder: DataModel.getNewCustomOrder()),
            .init(title: "CFM: January 30", customOrder: DataModel.getNewCustomOrder()),
        ]
    }
    
    static func == (lhs: DataModel, rhs: DataModel) -> Bool {
        return lhs.id == rhs.id
    }
    
    static func getNewCustomOrder() -> Int {
        DataModel.lastOrder += 1
        return DataModel.lastOrder
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
    
    func reset() {
        DataModel.lastOrder = 0
        self.presentations = [
            .init(title: "CFM: January 2", customOrder: DataModel.getNewCustomOrder()),
            .init(title: "CFM: January 9", customOrder: DataModel.getNewCustomOrder()),
            .init(title: "CFM: January 16", customOrder: DataModel.getNewCustomOrder()),
            .init(title: "CFM: January 23", customOrder: DataModel.getNewCustomOrder()),
            .init(title: "CFM: January 30", customOrder: DataModel.getNewCustomOrder()),
        ]
    }
}

class Presentation: ObservableObject, Identifiable, Hashable {
    let id = UUID()
    @Published var title: String
    @Published var slides: [Slide]
    let customOrder: Int
    
    init(title: String, customOrder: Int, slides: [Slide]) {
        self.title = title
        self.customOrder = customOrder
        self.slides = []
    }
    
    init(title: String, customOrder: Int) {
        self.title = title
        self.customOrder = customOrder
        self.slides = [
            .init(title: "Under the direction of Heavenly Father, Jesus Christ created the earth.", content: "Elder D. Todd Christofferson said, “Whatever the details of the creation process, we know that it was not accidental but that it was directed by God the Father and implemented by Jesus Christ”"),
            .init(title: "Genesis 1:27–28", content: "27 So God created man in his own image, in the image of God created he him; male and female created he them.\n\n28 And God blessed them, and God said unto them, Be fruitful, and multiply, and replenish the earth, and subdue it: and have dominion over the fish of the sea, and over the fowl of the air, and over every living thing that moveth upon the earth."),
            .init(title: "Genesis 2:2–3", content: "2 And on the seventh day God ended his work which he had made; and he rested on the seventh day from all his work which he had made.\n\n3 And God blessed the seventh day, and sanctified it: because that in it he had rested from all his work which God created and made."),
            .init(title: "The Sabbath is God’s time", content: "Elder David A. Bednar taught, “The Sabbath is God’s time, a sacred time specifically set apart for worshipping Him and for receiving and remembering His great and precious promises”"),
            .init(title: "Abraham 4:28", content: "28 And the Gods said: We will bless them. And the Gods said: We will cause them to be fruitful and multiply, and replenish the earth, and subdue it, and to have dominion over the fish of the sea, and over the fowl of the air, and over every living thing that moveth upon the earth."),
        ]
    }
    
    static func == (lhs: Presentation, rhs: Presentation) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}

class Slide: ObservableObject, Identifiable, Hashable {
    let id = UUID()
    @Published var title = "Untitled"
    @Published var content = ""
    
    init(title: String, content: String) {
        self.title = title
        self.content = content
    }
    
    static func == (lhs: Slide, rhs: Slide) -> Bool {
        return lhs.id == rhs.id
    }
    
    func hash(into hasher: inout Hasher) {
        hasher.combine(ObjectIdentifier(self))
    }
}
