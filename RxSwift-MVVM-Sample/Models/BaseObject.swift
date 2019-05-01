//
//  BaseObject.swift
//  NYTimesArticle
//
//  Created by Sajeev Raj on  4/3/19
//  Copyright © 2019 Sajeev. All rights reserved.
//

import ObjectMapper

class Object: Mappable {
    required init?(map: Map) {}
    func mapping(map: Map) {}
}
