//
//  RenderView.swift
//  drawing-app
//
//  Created by const on 19.06.2023.
//

import SwiftUI

struct RenderView: View {
    @State private var prompt = "table lamp"
    @State private var prediction: StableDiffusion.Prediction?
    let sketch: UIImage

    var body: some View {
        Form {
            Section {
                Image(uiImage: sketch)
                    .resizable()
                    .frame(width: 300, height: 300)
                TextField(text: $prompt,
                          prompt: Text("Product description"),
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
            }
        }

        Spacer()
    }
    private func generate() async throws {
        let data = sketch.jpegData(compressionQuality: 100)!.uriEncoded(mimeType: "image/jpeg")
        let str = "Hand drawing modern \(prompt) render"
        let input = StableDiffusion.Input(image: data, prompt: str)
        prediction = try await StableDiffusion.predict(with: client,
                                                       input: input)
        try await prediction?.wait(with: client)
    }

    private func cancel() async throws {
        try await prediction?.cancel(with: client)
    }
}

struct RenderView_Previews: PreviewProvider {
    static var previews: some View {
        RenderView(sketch: UIImage(named: "lamp")!)
    }
}
