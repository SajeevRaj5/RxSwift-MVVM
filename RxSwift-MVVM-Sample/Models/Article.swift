//
//  Article.swift
//  NYTimesArticle
//
//  Created by Sajeev Raj on  4/3/19
//  Copyright © 2019 Sajeev. All rights reserved.
//

import ObjectMapper
import Alamofire
import PromiseKit
import RxSwift
import RxCocoa

class Article : Object {
    var url : URL?
    var author : String?
    var title : String?
    var publishedDate : String?
    
    override func mapping(map: Map) {
        
        url <- (map["url"],URLTransform())
        author <- map["byline"]
        title <- map["title"]
        publishedDate <- map["published_date"]
    }
}

extension Article {
    enum Router: Requestable {
        case list
        
        var method: Alamofire.HTTPMethod {
            return .get
        }
        
        var path: String {
            switch self {
            case .list: return "svc/mostpopular/v2/viewed/7.json"
            }
        }
        
        var parameters: Parameters? {
            switch self {
            case .list: return ["api-key":"khv7rDY89ipce7GPtF3DGKL27Mi81c3h"]
            }
        }
    }
}

extension Article {
    class ListResponse: Object {
        
        var articles: [Article]?
        
        override func mapping(map: Map) {
            articles <- map["results"]
        }
    }
}

extension Article {
    
    static func getArticleList() -> Observable<[Article]> {
        return Observable.create{ (observer) -> Disposable in
            
            let _ = Router.list.request { (response: DataResponse<ListResponse>) in
                
                // error handling
                guard response.error == nil else {
                    observer.onError(response.error!)
                    return
                }
                
                // get articles
                guard let values = response.value?.articles else {
                    let error = NSError(domain: "JSONResponseError", code: 3841, userInfo: nil)
                    observer.onError(error)
                    return
                }
                
                // resolve to success
                observer.onNext(values)
            }
            return Disposables.create()
        }
    }
}
