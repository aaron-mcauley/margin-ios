//
//  ContentView.swift
//  Margin
//
//  Created by Triz on 6/15/26.
//

import SwiftUI
import PencilKit

struct ContentView: View {
    @State private var canvasView = PKCanvasView()
    @State private var statusText = "Ready"
    @State private var aiAnswer = ""
    
    var body: some View {
        ZStack {
            CanvasView(canvasView: $canvasView)
                .ignoresSafeArea()
            
            VStack {
                HStack {
                    Text("Margin")
                        .font(.headline)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                    
                    Button {
                        askAi()
                    } label: {
                        Text("Ask AI")
                            .font(.headline)
                            .padding(10)
                            .background(.ultraThinMaterial)
                            .clipShape(RoundedRectangle(cornerRadius: 10))
                    }
                }
                
                Spacer()
                
                if !aiAnswer.isEmpty {
                    Text(aiAnswer)
                        .font(.system(size: 16))
                        .padding(12)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                }
                
                Text(statusText)
                    .font(.caption)
                    .padding(8)
                    .background(.ultraThinMaterial)
                    .clipShape(RoundedRectangle(cornerRadius: 8))
            }
            .padding()
        }
    }
    
    func askAi() {
        let image = canvasView.drawing.image(
            from: canvasView.bounds,
            scale: UIScreen.main.scale
        )
        
        if let data = image.pngData() {
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("canvas.png")
            
            do {
                try data.write(to: url)
                
                print("Saved image to: ")
                print(url)
                
                statusText = "Image saved"
                aiAnswer = "Canvas successfully converted to PNG."
            } catch {
                print (error)
                statusText = "Saved failed"
            }
        }
    }
}

#Preview {
    ContentView()
}
