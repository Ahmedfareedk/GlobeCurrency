//
//  ImageLoaderView.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 30/03/2025.
//

import SwiftUI
import SDWebImageSwiftUI

struct ImageLoaderView: View {
    var imageURL: String
    var resizingMode: ContentMode = .fill
    
    var body: some View {
        Rectangle()
            .opacity(0.001)
            .overlay {
                WebImage(url: URL(string: imageURL), options: [.refreshCached])
                    .resizable()
                    .indicator(.activity)
                    .aspectRatio(contentMode: resizingMode)
                    .allowsHitTesting(false)
            }
            .clipped()
    }
}

#Preview {
    ImageLoaderView(imageURL: "")
        .cornerRadius(22)
        .padding(40)
        .padding(.vertical, 60)
}
