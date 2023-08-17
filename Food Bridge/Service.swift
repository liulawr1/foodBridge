//
//  Service.swift
//  Food Bridge
//
//  Created by Lawrence Liu on 8/17/23.
//

import Foundation

class Service {
    static let shared = Service()
    
    func download_listing_info(url_string: String) {
        guard let url = URL(string: url_string) else { return }
//        URLSession.shared.downloadTask(with: url) { <#URL?#>, <#URLResponse?#>, <#Error?#> in
//            <#code#>
//        }
    }
}
