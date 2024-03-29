//
//  Response.swift
//  URLSessionPOSTSample
//
//  Created by cranoo on 2024/03/30.
//

import Foundation

// 受け取ったデータを格納するstructです
// 例として適当なプロパティを持たせています
struct Response: Codable {
    let userName: String
    let message: String
}
