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
    
    var body: some View {
        ZStack{
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
                }
                
                Spacer()
            }
            .padding()
        }
    }
}

#Preview {
    ContentView()
}
