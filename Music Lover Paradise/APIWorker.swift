//
//  APIWorker.swift
//  Music Lover Paradise
//
//  Created by Andres Wang on 25/03/2018.
//  Copyright © 2018 Andres Wang. All rights reserved.
//

import Foundation

protocol APIWorkerDelegate {
    func urlSessionDataTask(url: URL, prehandler: (() -> Void)?, dataHandler: @escaping (Data) -> Void, errorHandler: @escaping () -> Void) -> URLSessionDataTask
}

struct DiscogsAPIWorker: APIWorkerDelegate {
    func urlSessionDataTask(url: URL, prehandler: (() -> Void)?, dataHandler: @escaping (Data) -> Void, errorHandler: @escaping () -> Void) -> URLSessionDataTask {
        let session = URLSession.shared
        let dataTask = session.dataTask(with: url) { data, response, error in
            // Preparation (ie: stop activity indicator)
            DispatchQueue.main.async {prehandler?()}
            
            // Handle response
            if let error = error as NSError?, error.code == -999 {
                return // Task was cancelled
            } else if let httpResponse = response as? HTTPURLResponse, httpResponse.statusCode == 200 {
                if let data = data {dataHandler(data) ; return /* Exit the closure */ }
            } else {
                print("URLSession Failure! \(String(describing: response))")
            }
            
            // Handle errors
            DispatchQueue.main.async {errorHandler()}
        }
        dataTask.resume()
        return dataTask
    }
}
