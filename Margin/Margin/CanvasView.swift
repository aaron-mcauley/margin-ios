//
//  CanvasView.swift
//  Margin
//
//  Created by Triz on 6/16/26.
//

import SwiftUI
import PencilKit

struct CanvasView: UIViewRepresentable {
    @Binding var canvasView: PKCanvasView
    
    func makeUIView(context: Context) -> PKCanvasView {
        canvasView.drawingPolicy = .pencilOnly
        canvasView.backgroundColor = UIColor.systemBackground
        canvasView.isOpaque = false
        
        let tool = PKInkingTool(.pen, color: .red, width: 5)
        canvasView.tool = tool
        
        return canvasView
    }
    
    func updateUIView (_ uiView: PKCanvasView, context: Context) {
            }
}

