//
//  ArticleListViewController.swift
//  RxSwift-MVVM-Sample
//
//  Created by sajeev Raj on 4/21/19.
//  Copyright © 2019 Sajeev. All rights reserved.
//

import UIKit
import RxSwift
import RxCocoa

class ArticleListViewController: UIViewController {
    
    var articleViewModel = ArticleViewModel()
    
    var disposeBag = DisposeBag()
    
    var activityIndicator = UIActivityIndicatorView()

    @IBOutlet weak var articlesTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = "Articles"
        
        registerCell()
        configureActivityIndicator()
        getArticles()
    }
    
    private func registerCell() {
        articlesTableView.register(UINib(nibName: "ArticleTableViewCell", bundle: nil), forCellReuseIdentifier: "ArticleTableViewCell")
    }
    
    private func configureTableView(items: Observable<[Article]>) {
        
        items.bind(to: articlesTableView.rx.items(cellIdentifier: "ArticleTableViewCell")) {index, model, cell in
            guard let articleCell = cell as? ArticleTableViewCell else { return }
            articleCell.article = model
            }.disposed(by: disposeBag)
        
        articlesTableView.rx.modelSelected(Article.self).subscribe(onNext: { [weak self] item in
            self?.showDetailView(article: item)
        }).disposed(by: disposeBag)
    }
    
    private func configureActivityIndicator() {
        activityIndicator           = UIActivityIndicatorView(style: UIActivityIndicatorView.Style.gray)
        activityIndicator.frame     = CGRect(x: 0, y: 0, width: 50, height: 50)
        activityIndicator.center    = view.center
        activityIndicator.bringSubviewToFront(articlesTableView)
        view.addSubview(activityIndicator)
    }
    
    private func showDetailView(article: Article) {
        guard let articleDetailViewController = UIStoryboard(name: "Main", bundle: nil).instantiateViewController(withIdentifier: "ArticleDetailViewController") as? ArticleDetailViewController else { return }
        articleDetailViewController.url = article.url
        navigationController?.pushViewController(articleDetailViewController, animated: true)
    }
    
    private func getArticles() {
        activityIndicator.startAnimating()
        articleViewModel.getArticles { [weak self] (list, error) in
            self?.activityIndicator.stopAnimating()
            guard error == nil, let result = list else {
                print("Error occurred")
                return
            }
            self?.configureTableView(items: result)
        }
    }
}
