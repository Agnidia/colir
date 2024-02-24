//
//  CustomizingActionViewModel.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

class CustomizingActionViewModel: ObservableObject, DomainViewConstantProtocol {
    
    //MARK: - DomainViewConstantProtocol
    typealias DomainViewConstantType = CustomizingActionViewDomain
    
    var viewSettings: DomainViewConstantType = .init()
    
    typealias ButtonAction = Commons.EmptyClosure
    
    private let buttonAction: ButtonAction
    
    @Published private var state: ImageDto.ImageState
    
    //MARK: - Variables
    
    init(state: ImageDto.ImageState = .none, actionClosure: @escaping ButtonAction) {
        self.state = state
        self.buttonAction = actionClosure
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
        .padding(.paddingDefault)
        .disabled(state != .ready)
    }
    
    //MARK: - Private
    
    private func action() {
        buttonAction()
    }
}
