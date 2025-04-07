//
//  SearchBarView.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import SwiftUI

struct SearchBarView: View {
    @State var searchText: String = ""
    @State var isSearchButtonDisabled: Bool
    @FocusState private var isTextFieldFocused: Bool
    var placeholder: String
    var onTapSearch: (String) -> Void
    
    
    var body: some View {
        HStack {
            searchTextField
            searchButton
        }
        .background(Color(.systemGray6))
        .clipShape(RoundedRectangle(cornerRadius: 12))
    }
    
    private var searchTextField: some View {
        TextField(placeholder, text: $searchText)
            .textFieldStyle(RoundedBorderTextFieldStyle())
            .padding(.horizontal, 8)
            .focused($isTextFieldFocused)
            .keyboardType(.asciiCapable)
    }
    
    private var searchButton: some View {
        Button(action: {
            onTapSearch(searchText)
            isTextFieldFocused = false
        }) {
            Image(systemName: "magnifyingglass")
                .padding()
                .background(isSearchButtonDisabled ? .gray : .blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .opacity(isSearchButtonDisabled ? 0.9 : 1.0)
        }
        .disabled(isSearchButtonDisabled)
    }

    func performSearch() {
        print("Searching for: \(searchText)")
    }
}

struct SearchBarView_Previews: PreviewProvider {
    static var previews: some View {
        SearchBarView(searchText: "", isSearchButtonDisabled: false, placeholder: "") { _ in }
    }
}

#Preview {
    SearchBarView(searchText: "", isSearchButtonDisabled: false, placeholder: "") { _ in }
}
