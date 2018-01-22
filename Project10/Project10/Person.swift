//
//  Person.swift
//  Project10
//
//  Created by Jack Mustacato on 1/20/18.
//  Copyright © 2018 Jack Mustacato. All rights reserved.
//

import UIKit

class Person: NSObject {
    var name: String
    var image: String
    
    init(name: String, image: String) {
        self.name = name
        self.image = image
    }
}
