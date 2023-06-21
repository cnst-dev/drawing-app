//
//  Replicate.swift
//  drawing-app
//
//  Created by const on 20.06.2023.
//

import UIKit
import Replicate
import SwiftUI

let client = Replicate.Client(token: "r8_SrtzKNJqBfBvHuWzh1apVLM1qjCkDKr2KmcTX")

enum StableDiffusion: Predictable {
    static var modelID = "jagilley/controlnet-scribble"
    static let versionID = "435061a1b5a4c1e26740464bf786efdfa9cb3a3ac488595a2de23e143fdb0117"

    struct Input: Codable {
        let image: String
        let prompt: String
    }

    typealias Output = [URL]
}

extension View {
// This function changes our View to UIView, then calls another function
// to convert the newly-made UIView to a UIImage.
    public func asUIImage() -> UIImage {
        let controller = UIHostingController(rootView: self)

 // Set the background to be transparent incase the image is a PNG, WebP or (Static) GIF
        controller.view.backgroundColor = .clear

        controller.view.frame = CGRect(x: 0, y: CGFloat(Int.max), width: 1, height: 1)
        UIApplication.shared.windows.first!.rootViewController?.view.addSubview(controller.view)

        let size = controller.sizeThatFits(in: UIScreen.main.bounds.size)
        controller.view.bounds = CGRect(origin: .zero, size: size)
        controller.view.sizeToFit()

// here is the call to the function that converts UIView to UIImage: `.asUIImage()`
        let image = controller.view.asUIImage()
        controller.view.removeFromSuperview()
        return image
    }
}

extension UIView {
// This is the function to convert UIView to UIImage
    public func asUIImage() -> UIImage {
        let renderer = UIGraphicsImageRenderer(bounds: bounds)
        return renderer.image { rendererContext in
            layer.render(in: rendererContext.cgContext)
        }
    }
}
