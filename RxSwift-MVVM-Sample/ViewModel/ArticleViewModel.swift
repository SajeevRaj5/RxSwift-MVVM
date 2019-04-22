//
//  ArticleViewModel.swift
//  RxSwift-MVVM-Sample
//
//  Created by sajeev Raj on 4/22/19.
//  Copyright © 2019 Sajeev. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa

class ArticleViewModel {
    
    var disposeBag = DisposeBag()
    
    var articleList: Observable<[Article]>?

    func getArticles( completion: @escaping (_ result: Observable<[Article]>?,_ error: Error?) -> Void) {
        Article
            .getArticleList()
            .subscribe(
                onNext: { [weak self] articles in
                    
                    // Store value
                    print("Success::\(articles)")
                    self?.articleList = Observable<[Article]>.just(articles)
                    completion(self?.articleList, nil)
                },
                onError: { error in
                    completion(nil, error)
                    
                    // Present error
                    print("Error occurred")
                }
            )
            .disposed(by: disposeBag)
    }
}
