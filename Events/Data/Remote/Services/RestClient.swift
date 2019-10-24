//
//  RestClient.swift
//  Events
//
//  Created by Darci Neto on 13/10/19.
//  Copyright © 2019 Darci Neto. All rights reserved.
//

import Foundation
import RxSwift
import RxCocoa


class RestClient {
    
    // MARK: - Properties
    
    var requestHttpHeaders : [String: String] = [:]
    
    var urlQueryParameters : [String: String] = [:]
    
    var httpBodyParameters : [String: String] = [:]
    
    var httpBody: Data?
    
    // MARK: - Public Methods
    func makeRequest(toURL url: URL, withHttpMethod httpMethod: HttpMethod)  -> Observable<Data> {
        let targetURL = self.addURLQueryParameters(toURL: url)
        return Observable.create { observer in
            let httpBody = self.getHttpBody()
            guard let request = self.prepareRequest(withURL: targetURL, httpBody: httpBody, httpMethod: httpMethod) else {
                observer.onError(ApiCustomErrors.failedToCreateRequest)
                return Disposables.create()
            }
            let session = URLSession(configuration: URLSessionConfiguration.default)
            let task = session.dataTask(with: request) { (data, response, error) in
                if let error = error {
                    observer.onError(ApiCustomErrors.Other(error))
                    observer.onCompleted()
                    return
                }
                let response  = Response(fromURLResponse: response)
                if response.response == nil {
                    observer.onError(ApiCustomErrors.failedToCreateRequest)
                    observer.onCompleted()
                    return
                }
                if  200 ..< 300 ~= response.httpStatusCode {
                    observer.onNext(data ?? Data() )
                    observer.onCompleted()
                    return
                }
                observer.onError(ApiCustomErrors.BadStatus(status:response.httpStatusCode))
                observer.onCompleted()
            }
            
            task.resume()
            
            return Disposables.create {
                task.cancel()
            }
        }
        
    }
    
    // MARK: - Private Methods
    private func addURLQueryParameters(toURL url: URL) -> URL {
        if urlQueryParameters.count > 0 {
            guard var urlComponents = URLComponents(url: url, resolvingAgainstBaseURL: false) else { return url }
            var queryItems = [URLQueryItem]()
            for (key, value) in urlQueryParameters {
                let item = URLQueryItem(name: key, value: value.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed))
                queryItems.append(item)
            }
            
            urlComponents.queryItems = queryItems
            
            guard let updatedURL = urlComponents.url else { return url }
            return updatedURL
        }
        
        return url
    }
    
    private func getHttpBody() -> Data? {
        guard let contentType = requestHttpHeaders["Content-Type"] else { return nil }
        
        if contentType.contains("application/json") {
            return try? JSONSerialization.data(withJSONObject: httpBodyParameters, options: [.prettyPrinted, .sortedKeys])
        } else if contentType.contains("application/x-www-form-urlencoded") {
            let bodyString = httpBodyParameters.map { "\($0)=\(String(describing: $1.addingPercentEncoding(withAllowedCharacters: .urlQueryAllowed)))" }.joined(separator: "&")
            return bodyString.data(using: .utf8)
        } else {
            return httpBody
        }
    }
    
    private func prepareRequest(withURL url: URL?, httpBody: Data?, httpMethod: HttpMethod) -> URLRequest? {
        guard let url = url else { return nil }
        var request = URLRequest(url: url)
        request.httpMethod = httpMethod.rawValue
        
        for (header, value) in requestHttpHeaders {
            request.setValue(value, forHTTPHeaderField: header)
        }
        
        request.httpBody = httpBody
        return request
    }
}


// MARK: - RestManager Custom Types
extension RestClient {
    struct Response {
        var response: URLResponse?
        var httpStatusCode: Int = 0
        var headers : [String: String] = [:]
        
        init(fromURLResponse response: URLResponse?) {
            guard let response = response else { return }
            self.response = response
            httpStatusCode = (response as? HTTPURLResponse)?.statusCode ?? 0
            
            if let headerFields = (response as? HTTPURLResponse)?.allHeaderFields {
                for (key, value) in headerFields {
                    headers["\(value)"] = "\(key)"
                }
            }
        }
    }
    
    struct Results {
        var data: Data?
        var response: Response?
        var error: Error?
        
        init(withData data: Data?, response: Response?, error: Error?) {
            self.data = data
            self.response = response
            self.error = error
        }
        
        init(withError error: Error) {
            self.error = error
        }
    }
    
}
