//
//  Service.swift
//  ReportAProblem
//
//  Created by Mohammad Arafat Hossain on 10/30/18.
//  Copyright © 2018 Mohammad Arafat Hossain. All rights reserved.
//

import Foundation
import SafariServices

enum Response<T: Codable>{
    case failure(status: Int, reason: String?)
    case success(data: T?)
}

class Service<T: Codable> {
    static func loadJSON(_ fileName: String, result: ((Response<T>) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            if let url = Bundle.main.url(forResource: fileName, withExtension: "json") {
                do {
                    let data = try Data(contentsOf: url)
                    let decoder = JSONDecoder()
                    if let jsonData = try? decoder.decode(T.self, from: data), let success = result {
                        success(Response.success(data: jsonData))
                    }
                } catch {
                    if let failure = result {
                        failure(Response.failure(status: 404, reason: error.localizedDescription))
                    }
                }
            }
        }
    }
    
    static func submitCompose(_ message: String, result: ((Response<T>) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let data = "🙃".data(using: .ascii)
            let decoder = JSONDecoder()
            if let jsonData = try? decoder.decode(T.self, from: data ?? Data()), let success = result {
                success(Response.success(data: jsonData))
            } else {
                result?(Response.failure(status: 404, reason: "failed"))
            }
        }
    }
    
    static func submitSelected(_ problems: [String], result: ((Response<T>) -> Void)?) {
        DispatchQueue.main.asyncAfter(deadline: .now() + 5) {
            let data = "🙃".data(using: .ascii)
            let decoder = JSONDecoder()
            if let jsonData = try? decoder.decode(T.self, from: data ?? Data()), let success = result {
                success(Response.success(data: jsonData))
            } else {
                result?(Response.failure(status: 404, reason: "failed"))
            }
        }
    }
}


