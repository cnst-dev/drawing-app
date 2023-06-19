//
//  RenderView.swift
//  drawing-app
//
//  Created by const on 19.06.2023.
//

import SwiftUI

struct RenderView: View {
    @State private var prompt = ""
    @State var renderedImage = Image(systemName: "photo")

    var body: some View {
        VStack {
            TextField("Prompt", text: $prompt)
            Button("Render") {
                print("Render")
            }
            renderedImage
                .resizable()
                .frame(width: 300, height: 300)
            Spacer()
        }
        .padding()
    }
}

struct RenderView_Previews: PreviewProvider {
    static var previews: some View {
        RenderView()
    }
}
