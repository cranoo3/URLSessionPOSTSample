//
//  ContentView.swift
//  URLSessionPOSTSample
//
//  Created by cranoo on 2024/03/30.
//

import SwiftUI

// 受け取った情報を表示するViewの例
struct ContentView: View {
    @State var viewModel = ContentViewModel()
    
    var body: some View {
        VStack {
            Button("FetchData") {
                viewModel.fetchData()
            }
            
            Text(viewModel.responseData.message)
        }
        .padding()
        .alert(viewModel.errorMessage, isPresented: $viewModel.isShowAlert) {
            // アラートの処理は適切なものにしましょう
            // "残念!"だけは絶対にないです
            Button("残念!") {}
        }
    }
}

#Preview {
    ContentView()
}
