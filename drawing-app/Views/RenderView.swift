//
//  RenderView.swift
//  drawing-app
//
//  Created by const on 19.06.2023.
//

import SwiftUI

struct RenderView: View {
    @State private var prompt = "Hand drawing modern table lamp render"
    @State private var prediction: StableDiffusion.Prediction?
    var sketch = UIImage(named: "lamp.jpg")!

    var body: some View {
        Form {
            Section {
                TextField(text: $prompt,
                          prompt: Text("Enter a prompt to render an image"),
                          axis: .vertical,
                          label: {})
                Button("Render") {
                    Task {
                        try? await generate()
                    }
                }
                .disabled(prediction?.status.terminated == false)
            }

            if let prediction {
                ZStack {
                    Color.clear
                        .aspectRatio(1.0, contentMode: .fit)

                    switch prediction.status {
                    case .starting, .processing:
                        VStack {
                            ProgressView("Rendering...")
                                .padding(32)

                            Button("Cancel") {
                                Task { try await cancel() }
                            }
                        }
                    case .failed:
                        Text(prediction.error?.localizedDescription ?? "Unknown error")
                            .foregroundColor(.red)
                    case .succeeded:
                        if let url = prediction.output?.last {
                            VStack {
                                AsyncImage(url: url, scale: 2.0, content: { phase in
                                    phase.image?
                                        .resizable()
                                        .aspectRatio(contentMode: .fit)
                                        .cornerRadius(32)
                                })

                                ShareLink("Export", item: url)
                                    .padding(32)

                            }
                        }
                    case .canceled:
                        Text("The prediction was canceled")
                            .foregroundColor(.secondary)
                    }
                }
                .frame(maxWidth: .infinity, maxHeight: .infinity, alignment: .center)
                .padding()
                .listRowBackground(Color.clear)
                .listRowInsets(.init())
            } else {
                Image(uiImage: sketch)
            }
        }

        Spacer()
    }
    func generate() async throws {
        prediction = try await StableDiffusion.predict(with: client,
                                                       input: .init(image: sketch.jpegData(compressionQuality: 100)!.uriEncoded(mimeType: "image/jpeg"), prompt: prompt))
        try await prediction?.wait(with: client)
    }

    func cancel() async throws {
        try await prediction?.cancel(with: client)
    }
}

struct RenderView_Previews: PreviewProvider {
    static var previews: some View {
        RenderView()
    }
}
