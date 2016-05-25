//
//  JsonParser.swift
//  FoodTracker
//
//  Created by Michael Riegelhaupt on 5/24/16.
//  Copyright © 2016 Riegelhaupt. All rights reserved.
//

import Foundation
import SwiftyJSON

class JsonParser {
    
    static func feelingLuckyURL(data: NSData) -> String? {
        let json = JSON(data)
        return json["items"][0]["image"]["contextLink"].string
    }
    
}