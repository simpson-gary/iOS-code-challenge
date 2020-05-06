//
//  Endpoint.swift
//  ios-code-challenge
//
//  Created by Gary Simpson on 5/5/20.
//  Copyright © 2020 Dustin Lange. All rights reserved.
//

import Foundation

struct Endpoint {
  var path: String
  var queryItems: [URLQueryItem] = []
}
  
extension Endpoint {
  var url: URL {
    var components = URLComponents()
    components.scheme = "https"
    components.host = "api.yelp.com"
    components.path = "/v3/businesses/" + path
    components.queryItems = queryItems
    
    guard let url = components.url else {
      preconditionFailure("Invalid URL components: \(components)")
    }
    
    return url
  }
}

extension URLSession {
    typealias Handler = (Data?, URLResponse?, Error?) -> Void
    
    @discardableResult
    func request(
        _ endpoint: Endpoint,
        then handler: @escaping Handler
    ) -> URLSessionDataTask {
        var req = URLRequest(url: endpoint.url)
        req.setValue("Bearer \(Strings.apiKey)", forHTTPHeaderField: "Authorization")
        req.httpMethod = "GET"
      
        let task = dataTask(
          with: req,
            completionHandler: handler
        )

        task.resume()
        return task
    }
}

extension Endpoint {
  /**This endpoint returns up to 1000 businesses based on the provided search criteria.
   It has some basic information about the business. To get detailed information and reviews,
   please use the Business ID returned here and refer to /businesses/{id} and /businesses/{id}/reviews endpoints.
   */
  static func search(for query: String) -> Self {
    Endpoint(path: "search/\(query)")
  }
  
  /**This endpoint returns detailed business content.
   Normally, you would get the Business ID from /businesses/search,
   /businesses/search/phone, /transactions/{transaction_type}/search or /autocomplete.
   To retrieve review excerpts for a business, please refer to our Reviews endpoint (/businesses/{id}/reviews)
   */
  static func details(withID id: String) -> Self {
    Endpoint(path: id)
  }
}

