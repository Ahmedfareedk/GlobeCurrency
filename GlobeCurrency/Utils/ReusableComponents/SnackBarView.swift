//
//  SnackBarView.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 30/03/2025.
//

import SwiftUI

struct SnackBarView: View {
    let message: String
    var dismissible: Bool = true
    @Binding var isVisible: Bool
    
    var body: some View {
        if isVisible {
            VStack {
                Spacer()
                HStack {
                    Text(message)
                        .font(.body)
                        .foregroundColor(.white)
                        .padding()
                    Spacer()
                }
                .frame(maxWidth: .infinity)
                .background(.blue)
                .cornerRadius(10)
                .padding(.horizontal, 16)
                .edgesIgnoringSafeArea(.bottom)
            }
            .onAppear {
                if dismissible {
                    DispatchQueue.main.asyncAfter(deadline: .now() + 1) {
                        withAnimation {
                            isVisible = false
                        }
                    }
                }
            }
        }
    }
}
