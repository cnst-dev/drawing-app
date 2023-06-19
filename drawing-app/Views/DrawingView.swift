//
//  DrawingView.swift
//  drawing-app
//
//  Created by const on 19.06.2023.
//

import SwiftUI

struct DrawingView: View {
    private let colors = [Color.green, .orange, .blue, .red, .pink, .black, .purple]

    var screenShot: Image?

    @State private var lines = [Line]()
    @State private var selectedColor = Color.orange
    @State private var isRendering = false

    var body: some View {
        VStack {
            HStack {
                ForEach(colors, id: \.self) { colorButton(color: $0) }
                magicButton()
                clearButton()
            }
            image(from: lines)
                .gesture(
                    DragGesture(minimumDistance: 0, coordinateSpace: .local)
                        .onChanged { value in
                            let position = value.location
                            if value.translation == .zero {
                                lines.append(Line(points: [position], color: selectedColor))
                            } else {
                                guard let lastIdx = lines.indices.last else {
                                    return
                                }
                                lines[lastIdx].points.append(position)
                            }
                        }
                )
        }.sheet(isPresented: $isRendering) {
            RenderView(renderedImage: image(from: lines))

        }
    }

    private func image(from lines: [Line]) -> Image {
        Image(size: CGSize(width: 300, height: 300)) { context in
            for line in lines {
                var path = Path()
                path.addLines(line.points)
                context
                    .stroke(path,
                            with: .color(line.color),
                            style: StrokeStyle(lineWidth: 5,
                                               lineCap: .round,
                                               lineJoin: .round))
            }
        }
    }

    private func colorButton(color: Color) -> some View {
        Button {
            selectedColor = color
        } label: {
            Image(systemName: "circle.fill")
                .font(.title)
                .foregroundColor(color)
                .mask {
                    Image(systemName: "pencil.tip")
                        .font(.largeTitle)
                }
        }
    }

    private func clearButton() -> some View {
        Button {
            lines = []
        } label: {
            Image(systemName: "pencil.tip.crop.circle.badge.minus")
                .font(.title)
                .foregroundColor(.gray)
        }
    }

    @ViewBuilder
    func magicButton() -> some View {
        Button {
            isRendering = true
        } label: {
            Image(systemName: "lasso.and.sparkles")
                .font(.title)
                .foregroundColor(.cyan)
        }
    }
}

struct DrawingView_Previews: PreviewProvider {
    static var previews: some View {
        DrawingView()
    }
}
