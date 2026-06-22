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
    @State private var isSelecting = false
    @State private var lassoPoints: [CGPoint] = []
    @State private var lassoClosed = false
    @State private var aiAnswer = ""
    @State private var selectionRect: CGRect = .zero
    
    var body: some View {
        ZStack {
            CanvasView(canvasView: $canvasView)
                .ignoresSafeArea()
            
            if isSelecting {
                Color.clear
                    .contentShape(Rectangle())
                    .ignoresSafeArea()
                    .gesture(
                        DragGesture(minimumDistance: 0)
                            .onChanged { value in
                                lassoPoints.append(value.location)
                            }
                            .onEnded { _ in
                                lassoClosed = true
                                DispatchQueue.main.asyncAfter(deadline: .now() + 0.25) {
                                    isSelecting = false
                                    finishLasso()
                                }
                            }
                    )
                Path { path in
                    guard let firstPoint = lassoPoints.first else { return }
                    path.move(to: firstPoint)
                    for point in lassoPoints.dropFirst() {
                        path.addLine(to: point)
                    }
                    if lassoClosed {
                        path.closeSubpath()
                    }
                }
                .stroke(Color.blue, style: StrokeStyle(lineWidth: 3, dash: [8, 5]))
                .ignoresSafeArea()
            }
            VStack {
                HStack {
                    Text("Margin")
                        .font(.headline)
                        .padding(10)
                        .background(.ultraThinMaterial)
                        .clipShape(RoundedRectangle(cornerRadius: 10))
                    
                    Spacer()
                    
                    Button {
                        isSelecting.toggle()
                        lassoPoints.removeAll()
                        statusText = isSelecting ? "Circle a question" : "Ready"
                    } label: {
                        Text("AI")
                            .font(.headline)
                            .padding(10)
                            .background {
                                if isSelecting {
                                    Color.blue.opacity(0.3)
                                } else {
                                    Color.clear.background(.ultraThinMaterial)
                                }
                            }
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
        let fullImage = canvasView.drawing.image(
            from: canvasView.bounds,
            scale: UIScreen.main.scale
        )
        
        guard selectionRect.width > 0, selectionRect.height > 0 else {
            statusText = "No valid selection"
            return
        }
        
        let scale = UIScreen.main.scale
        
        let cropRect = CGRect (
            x: selectionRect.origin.x * scale,
            y: selectionRect.origin.y * scale,
            width: selectionRect.width * scale,
            height: selectionRect.height * scale
        )
        
        guard let cgImage = fullImage.cgImage?.cropping(to: cropRect) else {
            statusText = "Crop failed"
            return
        }
        
        let croppedImage = UIImage(cgImage: cgImage)
        
        if let data = croppedImage.pngData() {
            let url = FileManager.default.temporaryDirectory
                .appendingPathComponent("selected-region.png")
            
            do {
                try data.write(to: url)
                
                print("Saved selected region to: ")
                print(url)
                
                statusText = "Selected region saved"
                aiAnswer = "Selected region successfully cropped."
            } catch {
                print (error)
                statusText = "Saved failed"
            }
        }
    }
    
    func finishLasso() {
        guard !lassoPoints.isEmpty else {
            statusText = "No selection"
            return
        }
        
        let minX = lassoPoints.map {$0.x }.min() ?? 0
        let maxX = lassoPoints.map {$0.x }.min() ?? 0
        let minY = lassoPoints.map {$0.y }.max() ?? 0
        let maxY = lassoPoints.map {$0.y }.max() ?? 0
        
        let selectionRect = CGRect(
            x: minX,
            y: minY,
            width: maxX - minX,
            height: maxY - minY
        )
        
        statusText = "Selected: \(Int(selectionRect.width)) x \(Int(selectionRect.height))"
        
        askAi()
    }
}

#Preview {
    ContentView()
}
