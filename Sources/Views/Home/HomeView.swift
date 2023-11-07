//
//  ContentView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 23.07.2023.
//

import SwiftUI

struct HomeView: View {
    
    @EnvironmentObject var viewModel: HomeViewModel
    
    var body: some View {
        
#if DEBUG
        // Prints changes for debug purposes.
        let _ = Self._printChanges()
#endif
        
        HStack(alignment: .top, spacing: 0) {
            ZStack {
                VStack {}
                    .visualEffect(material: .sidebar)
                
                VStack(alignment: .leading) {
                    
                    viewModel.iconFolderView()
                    
                    viewModel.appliedStylesView()
                    
                    Spacer()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    
                    viewModel.customizeFolderView()
                    
                }
            }
            .frame(minWidth: 236, maxWidth: 236, maxHeight: .infinity)
            
            Divider()
                .padding(.vertical, 4)
            
            VStack(alignment: .leading) {
                viewModel.toolsView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            .frame(maxWidth: .infinity, maxHeight: .infinity)
        }
        .fixedSize(horizontal: false, vertical: false)
    }
}

#Preview("HomeView") {
    HomeView()
        .environmentObject(HomeViewModel.preview)
}
