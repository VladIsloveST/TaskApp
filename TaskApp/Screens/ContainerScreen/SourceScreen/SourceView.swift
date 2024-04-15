//
//  NewsView.swift
//  TestTask
//
//  Created by Mac on 17.03.2024.
//

import Foundation
import UIKit

class SourceView: UIViewController {
    
    // MARK: - Private Properties
    private var sourcePresenter: SourceViewOutPut!
    private var articleTableView = UITableView()
    private var refreshControl: UIRefreshControl!
    private var activityIndicator: UIActivityIndicatorView!
    private var articles: [ArticleData] = []
    private var page = 1
    
    // MARK: - Initialization
    init(sourcePresenter: SourceViewOutPut) {
        self.sourcePresenter = sourcePresenter
        super.init(nibName: nil, bundle: nil)
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        setupArticleTableView()
        setupActivityIndicator()
        setupRefreshControl()
        activityIndicator.startAnimating()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        sourcePresenter.fetchArticles(page: 1, isRefreshed: false)
    }
    
    // MARK: - Private Methods
    private func setupArticleTableView(){
        articleTableView.dataSource = self
        articleTableView.delegate = self
        articleTableView.prefetchDataSource = self
        articleTableView.separatorInset.right = 20
        articleTableView.register(ArticleCell.self, forCellReuseIdentifier: ArticleCell.identifier)
        view.addSubview(articleTableView)
        articleTableView.snp.makeConstraints { make in
            make.leading.trailing.bottom.top.equalToSuperview()
        }
    }
    
    private func setupActivityIndicator() {
        activityIndicator =  UIActivityIndicatorView(style: .large)
        view.addSubview(activityIndicator)
        activityIndicator.center = view.center
    }
    
    private func setupRefreshControl() {
        refreshControl = UIRefreshControl()
        refreshControl.addTarget(self, action: #selector(refresh), for: .valueChanged)
        refreshControl.backgroundColor = .clear
        refreshControl.tintColor = .black
        refreshControl.attributedTitle = NSAttributedString(
            string: "Fetching more articles...",
            attributes: [NSAttributedString.Key.strokeColor : UIColor.black])
        articleTableView.refreshControl = refreshControl
    }
    
    @objc
    private func refresh(sender: UIRefreshControl) {
        sourcePresenter.fetchArticles(page: page, isRefreshed: true)
        sender.endRefreshing()
    }
    
    
}

// MARK: - Table View Data Source
extension SourceView: UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        articles.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = UITableViewCell()
        guard let articleCell = tableView.dequeueReusableCell(
            withIdentifier: ArticleCell.identifier, for: indexPath) as? ArticleCell else { return cell }
        let article = articles[indexPath.row]
        articleCell.assignCellData(from: article)
        return articleCell
    }
}

// MARK: - Table View Delegate
extension SourceView: UITableViewDelegate {
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: true)
    }
}

// MARK: - Collection View Data Source Prefetching
extension SourceView: UITableViewDataSourcePrefetching {
    func tableView(_ tableView: UITableView, prefetchRowsAt indexPaths: [IndexPath]) {
        let filtered = indexPaths.filter({ $0.row >= articles.count - 5 })
        if filtered.count > 0 {
            page += 1
            sourcePresenter.fetchArticles(page: page, isRefreshed: false)
        }
    }
}

// MARK: - Conform ViewInPut
extension SourceView: SourceViewInPut {
    func success(_ reloadedArticles: [ArticleData]) {
        articles = reloadedArticles
        activityIndicator.stopAnimating()
        articleTableView.reloadData()
    }
    
    func failer(error: NetworkError) {
        activityIndicator.stopAnimating()
        showAlertWith(message: error.rawValue)
    }
}

