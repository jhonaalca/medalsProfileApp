//
//  ContentView.swift
//  MedalsProfileApp
//
//  Created by Jhona Alca on 16/10/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Environment(\.modelContext) private var modelContext

    var body: some View {
        ProfileView(
            viewModel: AppContainer.shared.makeProfileViewModel()
        )

    }

}

