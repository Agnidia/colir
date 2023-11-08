//
//  AppliedStylesViewModel.swift
//  colir
//
//  Created by Vitalii P on 07.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

class AppliedStylesViewModel: ObservableObject, DomainViewConstantProtocol {
    
    //MARK: - DomainViewConstantProtocol
    typealias DomainViewConstantType = AppliedStylesViewDomain
    
    var viewSettings: DomainViewConstantType = .init()
    
    @Published var state: ImageDto.ImageState
    
    //MARK: - Variables
    
    init(state: ImageDto.ImageState = .none) {
        self.state = state
    }
    
    func update(state: ImageDto.ImageState) {
        self.state = state
    }
    
    //MARK: - Views
    
    @ViewBuilder
    var progressView: some View {
        switch state {
        case .processing(let progress):
            ProgressView("", value: progress, total: 100)
                .frame(height: 8)
                .progressViewStyle(.primary)
        default:
            EmptyView()
        }
    }
    
    @ViewBuilder
    var actionButton: some View {
        Button(action: action, label: {
            Text(DomainViewConstantType.Localization.customize)
                .font(ButtonStyleConstants.font)
                .padding(ButtonStyleConstants.padding)
        })
        .buttonStyle(.primary)
        .padding()
        .disabled(state != .ready)
    }
    
    //MARK: - Private
    
    private func action() {
        //NSWorkspace.shared.open(url)
    }
}
