//
//  PPUMPPAI++Bundle.swift
//  PPUMPPAI
//
//  Created by 유정현 on 2022/10/05.
//

import Foundation

extension Bundle {
    private var apiKey: String {
        get {
            // 1
            guard let filePath = Bundle.main.path(forResource: "apikeys", ofType: "plist") else {
                fatalError("Couldn't find file 'apikeys.plist'.")
            }
            // 2
            let plist = NSDictionary(contentsOfFile: filePath)
            guard let value = plist?.object(forKey: "NMFClientId") as? String else {
                fatalError("Couldn't find key 'NMFClientId' in 'apikeys.plist'.")
            }
            // 3
            if (value.starts(with: "_")) {
                fatalError("Register for a TMDB developer account and get an API key at https://developers.themoviedb.org/3/getting-started/introduction.")
            }
            return value
        }
    }
}
