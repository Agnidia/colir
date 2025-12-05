//
//  AppStoreView.swift
//  colir
//
//  Created by Vitalii Parovishnyk on 13.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import SwiftUI

/// A SwiftUI view that presents the app store interface for subscriptions and in-app purchases.
struct AppStoreView: View {

    private enum ButtonsFocusable: Hashable {
        case subscribe
        case tips1
        case tips2
        case restore
        case close
    }

    @FocusState private var elementFocus: ButtonsFocusable?

    @Environment(AppStoreViewModel.self) var viewModel

    @State private var selectedProduct: AppProduct?

    /// Published property indicating whether an overlay (e.g., progress indicator) should be displayed.
    @State private(set) var displayOverlay = false

    /// Hover state for cards
    @State private var hoveredProduct: AppProduct?

    var body: some View {
        VStack(spacing: .spacingDefault) {
            // Header with close and restore buttons
            headerView

            // Main content
            VStack(spacing: .spacingHeight) {
                // Subscription section
                subscriptionSection

                // Divider with "or" text
                dividerWithText

                // One-time purchases section
                oneTimePurchaseSection
            }
        }
        .onAppear(perform: {
            Task(operation: setup)
        })
        .padding(.paddingBig)
        .overlay {
            if displayOverlay {
                ZStack {
                    Rectangle()
                        .fill(.background.opacity(0.8))
                    ProgressView()
                        .progressViewStyle(.circular)
                }
                .edgesIgnoringSafeArea(.all)
            }
        }
    }

    private func setup() {
        elementFocus = .subscribe
    }

    // MARK: - Header

    @ViewBuilder
    private var headerView: some View {
        HStack {
            closeButton
            Spacer()
            restoreButton
        }
    }

    // MARK: - Subscription Section

    @ViewBuilder
    private var subscriptionSection: some View {
        VStack(spacing: .spacingDefault) {
            // Section title with icon
            HStack(spacing: .spacingDefault) {
                Image(systemName: "heart.fill")
                    .font(.system(size: 20))
                    .foregroundStyle(Color.selectedView)

                Text(AppStoreViewDomain.Localization.titleSubscription)
                    .font(Typography.headlineLarge)
                    .foregroundStyle(Color.primaryText)
            }

            // Subscription card
            ForEach(AppProduct.subscriptions, id: \.self) { product in
                subscriptionCard(for: product)
            }
        }
    }

    @ViewBuilder
    private func subscriptionCard(for product: AppProduct) -> some View {
        let info = try? viewModel.appStoreService.info(for: product)
        let isHovered = hoveredProduct == product

        Button { purchase(item: product) } label: {
            HStack(spacing: .spacingDefault) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.selectedView.opacity(0.2))
                        .frame(width: 48, height: 48)

                    Image(systemName: "cup.and.saucer.fill")
                        .font(.system(size: 20))
                        .foregroundStyle(Color.selectedView)
                }

                // Text content
                VStack(alignment: .leading, spacing: .spacingSmall) {
                    Text(info?.name ?? "Monthly Tips")
                        .font(Typography.headlineMedium)
                        .foregroundStyle(Color.primaryText)

                    Text(info?.description ?? "Support development")
                        .font(Typography.bodyMedium)
                        .foregroundStyle(Color.secondaryText)
                        .lineLimit(2)
                }

                Spacer()

                // Price badge
                VStack(spacing: .spacingSmall) {
                    Text(info?.price ?? "")
                        .font(Typography.headlineSmall)
                        .foregroundStyle(Color.primaryText)

                    Text("/ month")
                        .font(Typography.labelSmall)
                        .foregroundStyle(Color.secondaryText)
                }
                .padding(.horizontal, .paddingSmall)
                .padding(.vertical, .paddingThin)
                .background(Color.selectedView.opacity(0.15))
                .clipShape(RoundedRectangle(cornerRadius: .radiusThin))
            }
            .padding(.paddingDefault)
            .background(
                RoundedRectangle(cornerRadius: .radiusDefault)
                    .fill(Color.secondaryBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: .radiusDefault)
                    .strokeBorder(
                        isHovered ? Color.selectedView : Color.selectedView.opacity(0.5),
                        lineWidth: isHovered ? 2 : 1.5
                    )
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        }
        .buttonStyle(.plain)
        .focused($elementFocus, equals: .subscribe)
        .focusEffectDisabled()
        .onHover { hovering in
            hoveredProduct = hovering ? product : nil
        }
        .help(AppStoreViewDomain.Localization.helpInAppPurchase)
    }

    // MARK: - Divider

    @ViewBuilder
    private var dividerWithText: some View {
        HStack(spacing: .spacingDefault) {
            Rectangle()
                .fill(Color.secondaryText.opacity(0.3))
                .frame(height: 1)

            Text(AppStoreViewDomain.Localization.titleInAppPurchase)
                .font(Typography.labelMedium)
                .foregroundStyle(Color.secondaryText)

            Rectangle()
                .fill(Color.secondaryText.opacity(0.3))
                .frame(height: 1)
        }
        .padding(.vertical, .paddingSmall)
    }

    // MARK: - One-Time Purchases Section

    @ViewBuilder
    private var oneTimePurchaseSection: some View {
        HStack(spacing: .spacingDefault) {
            ForEach(Array(zip(AppProduct.inAppPurchases, [ButtonsFocusable.tips1, .tips2])), id: \.0) { product, focusId in
                oneTimePurchaseCard(for: product, focusId: focusId)
            }
        }
    }

    @ViewBuilder
    private func oneTimePurchaseCard(for product: AppProduct, focusId: ButtonsFocusable) -> some View {
        let info = try? viewModel.appStoreService.info(for: product)
        let isHovered = hoveredProduct == product
        let icon = product == .middleTips ? "cup.and.saucer" : "takeoutbag.and.cup.and.straw"

        Button { purchase(item: product) } label: {
            VStack(spacing: .spacingDefault) {
                // Icon
                ZStack {
                    Circle()
                        .fill(Color.secondaryBackground)
                        .frame(width: 56, height: 56)

                    Image(systemName: icon)
                        .font(.system(size: 24))
                        .foregroundStyle(Color.primaryText)
                }

                // Title
                Text(info?.name ?? "Tips")
                    .font(Typography.headlineSmall)
                    .foregroundStyle(Color.primaryText)

                // Description
                Text(info?.description ?? "Support once")
                    .font(Typography.bodySmall)
                    .foregroundStyle(Color.secondaryText)
                    .multilineTextAlignment(.center)
                    .lineLimit(2)
                    .frame(minHeight: 36)

                Spacer(minLength: 0)

                // Price
                Text(info?.price ?? "")
                    .font(Typography.headlineMedium)
                    .foregroundStyle(Color.primaryText)
            }
            .padding(.paddingDefault)
            .frame(maxWidth: .infinity, minHeight: 180)
            .background(
                RoundedRectangle(cornerRadius: .radiusDefault)
                    .fill(Color.secondaryBackground)
            )
            .overlay(
                RoundedRectangle(cornerRadius: .radiusDefault)
                    .strokeBorder(
                        isHovered ? Color.primaryText.opacity(0.5) : Color.primaryText.opacity(0.2),
                        lineWidth: isHovered ? 1.5 : 1
                    )
            )
            .scaleEffect(isHovered ? 1.02 : 1.0)
            .animation(.spring(response: 0.3, dampingFraction: 0.7), value: isHovered)
        }
        .buttonStyle(.plain)
        .focused($elementFocus, equals: focusId)
        .focusEffectDisabled()
        .onHover { hovering in
            hoveredProduct = hovering ? product : nil
        }
        .help(AppStoreViewDomain.Localization.helpInAppPurchase)
    }

    // MARK: - Actions

    private func purchase(item: AppProduct) {
        selectedProduct = item
        displayOverlay = true
        Task(operation: purchaseSelectedProduct)
    }

    private func purchaseSelectedProduct() async {
        guard let selectedProduct else { return }

        do {
            let result = try await viewModel.appStoreService.purchase(selectedProduct)
            viewModel.process(purchase: result)
        } catch {
            print(error.localizedDescription)
        }

        Task(operation: dismissOverlay)
    }

    private func dismissOverlay() {
        displayOverlay = false
    }

    // MARK: - Header Buttons

    @ViewBuilder
    var restoreButton: some View {
        Button {
            Task { [viewModel] in
                do {
                    try await viewModel.appStoreService.syncStoreData()
                } catch {
                    print("Sync error: \(error.localizedDescription)")
                }
            }
        } label: {
            Image(systemName: "arrow.counterclockwise")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.secondaryText)
                .frame(width: 36, height: 36)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .focused($elementFocus, equals: .restore)
        .focusEffectDisabled()
        .help(AppStoreViewDomain.Localization.helpRestore)
    }

    @ViewBuilder
    var closeButton: some View {
        Button(action: viewModel.completionHandler) {
            Image(systemName: "xmark.circle.fill")
                .font(.system(size: 20, weight: .medium))
                .foregroundStyle(Color.secondaryText)
                .frame(width: 36, height: 36)
                .contentShape(Rectangle())
        }
        .buttonStyle(.plain)
        .focused($elementFocus, equals: .close)
        .focusEffectDisabled()
        .help(AppStoreViewDomain.Localization.helpClose)
    }
}

#Preview("AppStoreView") {
    VStack {
        AppStoreView()
            .environment(AppStoreViewModel(
                appStoreService: AppStorePreview(),
                appSettings: AppSettings.preview,
                completion: {}
            ))
            .padding()
    }
}
