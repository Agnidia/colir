//
//  ContentView.swift
//  colir
//
//  Created by Vitalii P on 23.07.2023.
//

import SwiftUI
import DSFDropFilesView

struct HomeView: View {
    
    @EnvironmentObject var model: HomeViewModel
    
    var body: some View {
        HStack(alignment: .top, spacing: 8) {
            VStack(alignment: .leading) {
                DSFDropFilesView.SwiftUI(isEnabled: true,
                                         allowsMultipleDrop: false,
                                         icon: model.folderImages.first,
                                         iconLabel: "Drop folder here",
                                         selectFilesLabel: "Choose",
                                         selectFilesButtonIsLink: true,
                                         validateFiles: { urls in
                    return model.urlsHasFolders(urls: urls) ? .copy : NSDragOperation()
                },
                                         dropFiles: { urls in
                    model.setupFolders(from: urls)
                    
                    return true
                },
                                         selectFiles: {
                    model.openFolder()
                })
                
                Spacer()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            //.background(.red)
            .frame(minWidth: 199, maxWidth: 199, maxHeight: .infinity)
            .padding(4)
            
            Divider()
            
            VStack(alignment: .leading) {
                model.toolsView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
            }
            //.background(.green)
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .padding(4)
        }
        .fixedSize(horizontal: false, vertical: false)
        .padding()
    }
}

#Preview("HomeView") {
    HomeView()
        .environmentObject(HomeViewModel.preview)
}
