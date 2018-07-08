//
//  RequestScheme.swift
//  Request-Scheme
//
//  Created by kawaharadai on 2018/07/07.
//  Copyright © 2018年 kawaharadai. All rights reserved.
//

import UIKit
import WebKit

// 外部アプリを呼び出す（呼び出したいアプリはinfo.plistでも定義すること！）
enum RequestScheme: String {
    case safari = "safari"
    case tel = "tel"
    case youtube = "youtube"
    case maps = "maps"
    case mail = "mailto"
    case none = "success"
    /// 外部アプリをURLスキームで起動し、失敗した場合はそのスキーム名を返す（今回はこの段階で外部起動が確定していることとする）
    ///
    /// - Parameters:
    ///   - url: リクエストするURL
    ///   - scheme: 開くアプリのスキーム
    /// - Returns: 起動に失敗したRequestScheme
    func open(url: URL, scheme: String) -> RequestScheme {
        
        guard let requestScheme = RequestScheme(rawValue: scheme), requestScheme != .safari else {
            if UIApplication.shared.canOpenURL(url) {
                UIApplication.shared.open(url)
                return .none
            } else {
                return .safari
            }
        }
        
        let appScheme = "\(requestScheme.rawValue)://"
        
        guard let requestAppUrl = URL(string: appScheme) else {
            return requestScheme
        }
        
        // 起動可能確認
        guard UIApplication.shared.canOpenURL(requestAppUrl) else {
            return requestScheme
        }
        // ここで値が漏れるとパラメータが漏れる
        var urlComponents = URLComponents()
        urlComponents.scheme = requestScheme.rawValue
        urlComponents.host = url.host
        urlComponents.path = url.path
        
        if
            let query = url.query,
            !query.isEmpty {
            urlComponents.query = query
        }
        
        guard let requestUrl = urlComponents.url else {
            return requestScheme
        }
        
        UIApplication.shared.open(requestUrl)
        
        return .none
    }
}

