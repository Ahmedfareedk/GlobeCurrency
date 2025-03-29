//
//  SearchBarView.swift
//  GlobeCurrency
//
//  Created by Ahmed Fareed on 28/03/2025.
//

import SwiftUI

struct SearchBarView: View {
    @State private var searchText: String = ""
    var placeholder: String
    var onTapSearch: ((String) -> Void)

    init(placeholder: String, onTapSearch: @escaping (String) -> Void) {
        self.placeholder = placeholder
        self.onTapSearch = onTapSearch
    }
    
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
    }
    
    private var searchButton: some View {
        Button(action: {
            onTapSearch(searchText)
        }) {
            Image(systemName: "magnifyingglass") // Search icon
                .padding()
                .background(Color.blue)
                .foregroundColor(.white)
                .clipShape(RoundedRectangle(cornerRadius: 8))
        }
    }

    func performSearch() {
        print("Searching for: \(searchText)")
    }
}

//struct SearchBarView_Previews: PreviewProvider {
//    static var previews: some View {
//        SearchBarView(
//    }
//}
//
//#Preview {
//    SearchBarView()
//}
