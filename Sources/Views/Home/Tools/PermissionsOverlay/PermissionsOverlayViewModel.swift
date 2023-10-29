//
//  PermissionsOverlayViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 15.10.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

class PermissionsOverlayViewModel: ObservableObject, DomainViewConstantProtocol {
    
    //MARK: - DomainViewConstantProtocol
    typealias DomainViewConstantType = PermissionsOverlayDomain
    
    var viewSettings: DomainViewConstantType = .init()
    
    //MARK: - Variables
    
    private var title: String
    
    private var description: String
    
    private var url: URL
    
    init(title: String, description: String = "", url: URL) {
        self.title = title
        self.description = description
        self.url = url
    }
    
    //MARK: - Views
    
    @ViewBuilder
    var backgroundView: some View {
        RoundedRectangle(cornerRadius: viewSettings.cornerRadius!)
            .fill(viewSettings.background)
    }
    
    @ViewBuilder
    var titleText: some View {
        Text(title)
            .font(.title)
    }
    
    @ViewBuilder
    var descriptionText: some View {
        Text(description)
            .font(.body)
    }
    
    @ViewBuilder
    var actionButton: some View {
        Button(action: action, label: {
            Text(DomainViewConstantType.Localization.openSettings)
                .font(.body)
                .padding()
        })
        .buttonStyle(.primary)
    }
    
    //MARK: - Private
    
    private func action() {
        let workspace = NSWorkspace.shared
        workspace.open(url)
        workspace.activateFileViewerSelecting([Bundle.main.bundleURL])
    }
}
