//
//  ContentViewModel.swift
//  URLSessionPOSTSample
//
//  Created by cranoo on 2024/03/30.
//

import Foundation

@Observable
final class ContentViewModel {
    @ObservationIgnored
    private let apiClient = APIClient()
    
    // レスポンスデータを格納する
    // userNameとmessageは適当につけたサンプルです
    var responseData = Response(userName: "", message: "")
    
    // エラー表示を行う
    var isShowAlert = false
    var errorMessage = ""
    
    // UIの更新がメインスレッド上で安全に行われるようMainActoreをつける
    @MainActor
    func fetchData() {
        Task {
            // データ取得
            let result = await apiClient.fetch()
            
            // resultの結果に応じて処理を変更
            switch result {
            case .success(let response):
                responseData = response
            case .failure(let error):
                isShowAlert = true
                errorMessage = error.localizedDescription
            }
        }
    }
}
