//
//  Replicate.swift
//  drawing-app
//
//  Created by const on 20.06.2023.
//

import UIKit
import Replicate
import SwiftUI

var apiKey: String {
    guard let filePath = Bundle.main.path(forResource: "API", ofType: "plist") else {
        fatalError("Couldn't find file 'API.plist'.")
    }
    let plist = NSDictionary(contentsOfFile: filePath)
    guard let value = plist?.object(forKey: "REPLICATE_KEY") as? String else {
        fatalError("Couldn't find key 'REPLICATE_KEY' in 'API.plist'.")
    }
    return value
}

let client = Replicate.Client(token: apiKey)

enum StableDiffusion: Predictable {
    static var modelID = "jagilley/controlnet-scribble"
    static let versionID = "435061a1b5a4c1e26740464bf786efdfa9cb3a3ac488595a2de23e143fdb0117"

    struct Input: Codable {
        let image: String
        let prompt: String
    }

    typealias Output = [URL]
}
