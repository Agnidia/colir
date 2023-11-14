//
//  AppStoreViewModel.swift
//  colir
//
//  Created by Vitalii P on 13.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI
import SwiftCommons

final class AppStoreViewModel: ObservableObject, DomainViewConstantProtocol {
    
    //MARK: - DomainViewConstantProtocol
    typealias DomainViewConstantType = AppStoreViewDomain
    
    var viewSettings: DomainViewConstantType = .init()
    
    private var appStoreService: AppStoreProtocol
    
    init(appStoreService: AppStoreProtocol) {
        self.appStoreService = appStoreService
    }
    
    @ViewBuilder
    var titleSubscription: some View {
        Text(DomainViewConstantType.Localization.titleSubscription)
            .font(.title)
            .padding(.top, 32)
    }
    
    private static var buttonSize: CGFloat = 150
    
    private let rows = [
        GridItem(.adaptive(minimum: buttonSize, maximum: buttonSize))
    ]
    
    @ViewBuilder
    var subscriptionsList: some View {
        ListView(for: AppProduct.subscriptions)
    }
    
    @ViewBuilder
    var titleInAppPurchase: some View {
        Text(DomainViewConstantType.Localization.titleInAppPurchase)
            .font(.title)
            .padding(.top, 16)
    }
    
    @ViewBuilder
    var inAppPurchasesList: some View {
        ListView(for: AppProduct.inAppPurchases)
    }
    
    @ViewBuilder
    private func ListView(for products: [AppProduct]) -> some View {
        LazyHGrid(rows: rows, alignment: .center) {
            ForEach(products, id: \.self) { item in
                Button {
                    Task {
                        do {
                            let result = try await self.appStoreService.purchase(item)
                            print(result)
                        } catch {
                            print(error.localizedDescription)
                        }
                    }
                } label: {
                    let info = try? self.appStoreService.info(for: item)
                    VStack {
                        Text(info?.name ?? "")
                            .font(.title2)
                            .multilineTextAlignment(.center)
                        Text(info?.description ?? "")
                            .font(.body)
                            .multilineTextAlignment(.center)
                            .padding(4)
                        Spacer()
                        Text(info?.price ?? "")
                            .font(.body)
                    }
                    .padding()
                    .frame(width: AppStoreViewModel.buttonSize, height: AppStoreViewModel.buttonSize)
                }
                .buttonStyle(.accent)
            }
        }
        .frame(height: AppStoreViewModel.buttonSize)
    }
    
    @ViewBuilder
    var closeButton: some View {
        Button {
            
        } label: {
            Text("Done")
                .padding(.init(top: 8, leading: 16, bottom: 8, trailing: 16))
        }
        .buttonStyle(.primary)
        .padding(.init(top: 16, leading: 0, bottom: 32, trailing: 0))
    }
}
