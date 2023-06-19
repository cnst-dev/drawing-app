//
//  ContentView.swift
//  drawing-app
//
//  Created by const on 19.06.2023.
//

import SwiftUI

struct Line {
    var points: [CGPoint]
    var color: Color
}

struct ContentView: View {
    var body: some View {
        DrawingView()
    }
}

struct ContentView_Previews: PreviewProvider {
    static var previews: some View {
        ContentView()
    }
}
