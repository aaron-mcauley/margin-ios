//
//  ContentView.swift
//  Margin
//
//  Created by Triz on 6/15/26.
//

import SwiftUI

struct ContentView: View {
    var body: some View {
        VStack {
            Image(systemName: "globe")
                .imageScale(.large)
                .foregroundStyle(.tint)
                .font(.system(size: 100))
            Text("Hello, world!")
                .font(.system(size: 44))
        }
        .padding()
    }
}

#Preview {
    ContentView()
}
