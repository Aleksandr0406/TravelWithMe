//
//  UserAgreementView.swift
//  Travel-Schedule
//
//  Created by 1111 on 20.05.2025.
//

import SwiftUI
import WebKit

struct UserAgreementView: View {
    let viewModel: UserAgreementViewModel = UserAgreementViewModel()
    
    var body: some View {
        Group {
            if let url = URL(string: viewModel.userAgreementURL) {
                WebView(url: url)
            }
        }
        .navigationTitle("Пользовательское соглашение")
    }
}

private struct WebView: UIViewRepresentable {
    let url: URL
    
    func makeUIView(context: Context) -> WKWebView {
        return WKWebView()
    }
    func updateUIView(_ webView: WKWebView, context: Context) {
        let request = URLRequest(url: url)
        webView.load(request)
    }
}
