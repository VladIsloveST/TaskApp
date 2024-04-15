//
//  NewsViewPresenter.swift
//  TestTask
//
//  Created by Mac on 17.03.2024.
//

import Foundation

protocol SourceViewInPut: AnyObject {
    func success(_ reloaded: [ArticleData])
    func failer(error: NetworkError)
}

protocol SourceViewOutPut: AnyObject {
    init(networkManager: NetworkProtocol)
    func fetchArticles(page: Int, isRefreshed: Bool)
}

class SourceViewPresenter: SourceViewOutPut {
    // MARK: - Properties
    private var articles: [ArticleData] = []
    weak var view: SourceViewInPut?
    private var networkManager: NetworkProtocol
    private let group: DispatchGroup
    
    
    // MARK: - Initialization
    required init(networkManager: NetworkProtocol) {
        self.networkManager = networkManager
        self.group = DispatchGroup()
    }
    
    // MARK: - Methods
    func setup(view: SourceViewInPut) {
        self.view = view
    }
    
    func fetchArticles(page: Int, isRefreshed: Bool) {
        if isRefreshed { articles.removeAll() }
        
        let compositeEndpoint = "/v2/everything?q=apple&sortBy=popularity&pageSize=15&page=\(page)"
        group.enter()
        self.networkManager.fetchData(endpoint: compositeEndpoint, method: .get) { result in
            switch result {
            case .success(let fetchedArticles):
                let filteredArticles = fetchedArticles.articles.filter { $0.title != "[Removed]" }
                self.articles.append(contentsOf: filteredArticles)
            case .failure(let networkError):
                let processedNetworkError = (networkError as? NetworkError) ?? .internetConnectionError
                OperationQueue.main.addOperation {
                    self.view?.failer(error: processedNetworkError)
                }
            }
            self.group.leave()
        }
        
        group.notify(queue: DispatchQueue.main) {
            self.view?.success(self.articles)
        }
    }
}
