//
//  CustomizingActionViewModel.swift
//  colir
//
//  Created by Vitalii P on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

class CustomizingActionViewModel: ObservableObject, DomainViewConstantProtocol {
    
    //MARK: - DomainViewConstantProtocol
    typealias DomainViewConstantType = PermissionsOverlayDomain
    
    var viewSettings: DomainViewConstantType = .init()
    
    //MARK: - Variables
    
    init() {
    }
    
    //MARK: - Views
    
    @ViewBuilder
    var backgroundView: some View {
        RoundedRectangle(cornerRadius: viewSettings.cornerRadius!)
            .fill(viewSettings.background)
    }
    
    @ViewBuilder
    var titleText: some View {
        EmptyView()
        //Text(title)
        //    .font(.title)
    }
    
    @ViewBuilder
    var descriptionText: some View {
        EmptyView()
        //Text(description)
        //    .font(.body)
    }
    
    @ViewBuilder
    var actionButton: some View {
        Button(action: action, label: {
            Text(DomainViewConstantType.Localization.openSettings)
                .font(ButtonStyleConstants.font)
                .padding(ButtonStyleConstants.padding)
        })
        .tint(ButtonStyleConstants.backgroundAccentColor)
        .buttonStyle(.accent)
    }
    
    //MARK: - Private
    
    private func action() {
        //NSWorkspace.shared.open(url)
    }
}
