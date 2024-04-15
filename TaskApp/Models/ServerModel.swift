//
//  ServerModel.swift
//  TestTask
//
//  Created by Mac on 18.03.2024.
//

import Foundation

struct Articles: Codable {
    let articles: [ArticleData]
}

struct ArticleData: Codable {
    var title: String
    let author: String?
}
