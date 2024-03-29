//
//  APIClient.swift
//  URLSessionPOSTSample
//
//  Created by cranoo on 2024/03/30.
//

import Foundation

struct APIClient {
    // FIXME: URLと取得したAPI Keyを入力してください
    private let urlString: String = ""
    private let apiKey: String = ""
    
    /// データを取得するメソッドです
    ///
    /// ## Return
    /// - `Response`: APIからのレスポンスを格納するStructです。
    /// - `Error`: 通信に失敗した場合などに返すエラーです
    func fetch() async -> Result<Response, Error> {
        do {
            // MARK: - 1.URLを作成する
            // String型で入力されたurlStringをURL型へ変換しています
            guard let url = URL(string: self.urlString) else {
                return .failure(CommunicationErrors.badURL)
            }
            
            // MARK: - 2.URLリクエストを作成する
            func createURLRequest() -> URLRequest {
                var urlRequest = URLRequest(url: url)
                // メソッドの指定(今回はPOSTメソッドを使用)
                urlRequest.httpMethod = "POST"
                
                // FIXME: `["key": "value"]`の部分を使用するサービスが求めているものにしましょう
                // HTTPHeaderに記入する内容はリファレンスに書いてあるはずです
                urlRequest.allHTTPHeaderFields = ["key": "value"]
                
                // HTTPBodyも同様にサービスが求めているものを記入しましょう
                // このコードではStructをJSONへエンコードし、httpBodyへ記入しています
                var httpBody: Data? {
                    // FIXME: `HTTPBody()`の部分を変更してください
                    // HTTPBodyに記入する内容はリファレンスに書いてあるはずです
                    // `HTTPBody()`は作成したStructの名前です
                    let encodeValue = HTTPBody()
                    return try? JSONEncoder().encode(encodeValue)
                }
                urlRequest.httpBody = httpBody
                
                return urlRequest
            }
            
            // MARK: - 3.通信を行う
            guard let (data, urlRequest) = try? await URLSession.shared.data(for: createURLRequest()) else {
                return .failure(CommunicationErrors.couldNotCreateRequest)
            }
            
            // MARK: - 4.レスポンスを受け取る
            guard let response = urlRequest as? HTTPURLResponse else {
                return .failure(CommunicationErrors.responseNotReturned)
            }
            // ステータスコードを確認し正常に通信が行われたか確認する
            // ステータスコードが200番台ではなかった場合
            guard 200..<300 ~= response.statusCode else {
                return .failure(CommunicationErrors.badStatusCode(response.statusCode))
            }
            
            // MARK: - 5.JSONをStructへ変換する
            let decodeData = try JSONDecoder().decode(Response.self, from: data)
            return .success(decodeData)
        } catch {
            return .failure(error)
        }
    }
}

// MARK: - データ取得時に発生するエラーを分ける
enum CommunicationErrors: Error {
    case badURL
    case couldNotCreateRequest
    case responseNotReturned
    case badStatusCode(Int)
}
extension CommunicationErrors: LocalizedError {
    // エラーの説明文
    var errorDescription: String? {
        switch self {
        case .badURL:
            return "URLが不正です"
        case .couldNotCreateRequest:
            return "リクエストの作成に失敗しました"
        case .responseNotReturned:
            return "レスポンスがありませんでした"
        case .badStatusCode(let statusCode):
            return "通信ができませんでした statusCode: \(statusCode)"
        }
    }
}
