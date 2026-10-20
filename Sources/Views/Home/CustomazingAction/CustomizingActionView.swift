//
//  CustomizingActionView.swift
//
//  Created on 05.11.2023.
//  Copyright © 2026 Agnidia. All rights reserved.
//

import SwiftUI

/// A view that displays actions and progress related to customization.
///
/// The `CustomizingActionView` shows a progress view and an action button based on the state of
/// `CustomizingActionViewModel`. The layout consists of a vertical stack with the progress view
/// on top and the action button below.
///
/// - EnvironmentObject:
///   - `viewModel`: The view model providing the state and actions for the view.
///
/// - Example Usage:
///   ```swift
///   CustomizingActionView()
///       .environmentObject(CustomizingActionViewModel(state: .none, actionClosure: {}))
///   ```
struct CustomizingActionView: View {
    @Environment(CustomizingActionViewModel.self) var viewModel

    @State private var isPopupVisible: Bool = false

    var body: some View {
        ZStack {
            VStack(spacing: .spacingHeight) {
                actionButton
                    .overlay { progressView }
                    .background {
                        PopupContentView()
                            .offset(y: isPopupVisible ? -.paddingHeight : .zero)
                            .opacity(isPopupVisible ? .opacity100 : .opacity0)
                            .animation(.default, value: isPopupVisible)
                            .zIndex(1) // Ensure popup is above other content
                            .task(hidePopupTask)
                            .onChange(of: isPopupVisible) { _, needDisplay in
                                if needDisplay {
                                    hidePopupTask()
                                }
                            }
                    }
                    .padding(.trailing, .paddingDefault)
            }
        }
        .onChange(of: viewModel.state) { _, state in
            switch state {
            case .processing: isPopupVisible = false
            default: break
            }
        }
        .animation(.easeInOut, value: isPopupVisible) // Animate visibility change
    }

    @State private var hidePopoverTask: Task<Void, Never>? = nil

    private func hidePopupTask() {
        hidePopoverTask?.cancel()
        hidePopoverTask = Task {
            try? await Task.sleep(for: .seconds(2))
            guard Task.isCancelled == false else { return }

            isPopupVisible = false
        }
    }

    /// A view showing a progress indicator if the state is `.processing`.
    ///
    /// Displays a `ProgressView` with the progress value and total of 100 if the state is
    /// `.processing`. Otherwise, it displays an empty view.
    @ViewBuilder
    var progressView: some View {
        switch viewModel.state {
        case .processing(let progress):
            ProgressView("", value: progress, total: 100)
                .progressViewStyle(.primary)
                .clipShape(UnevenRoundedRectangle(cornerRadii: .init(topTrailing: ButtonStyleConstants.cornerRadius)))
        default:
            EmptyView()
        }
    }

    /// A button that triggers the `buttonAction` when pressed.
    ///
    /// The button is only enabled if the state is `.ready`. The button's label is set
    /// based on the localization provided by `DomainViewConstantType.Localization.customize`.
    @ViewBuilder
    var actionButton: some View {
        Button(action: {
            viewModel.action()
            isPopupVisible = true
        }, label: {
            Text(CustomizingActionViewDomain.Localization.customize)
                .font(ButtonStyleConstants.font)
                .padding(ButtonStyleConstants.padding)
                .padding(.vertical, .paddingSmall)
                .frame(maxWidth: .infinity)
        })
        .buttonStyle(.primary)
        .disabled(viewModel.state != .ready)
        .shadow(radius: 8)
    }
}

struct PopupContentView: View {
    var body: some View {
        VStack {
            Text("txt.done")
                .font(.headline)
                .padding(.paddingCompact)
        }
        .padding(.bottom, .paddingCompact)
        .frame(maxWidth: .infinity)
        .background(ButtonStyleConstants.backgroundColor.opacity(0.9))
        .foregroundColor(.white)
        .cornerRadius(12)
        .padding(.paddingSmall)
    }
}

// MARK: - Previews

/// Preview for `CustomizingActionView` showing different states.
///
/// This preview displays `CustomizingActionView` in various states:
/// - `.none`
/// - `.ready`
/// - `.preview`
/// - `.processing(value: 30)`
/// - `.error`
///
/// - Returns: A `VStack` containing multiple instances of `CustomizingActionView`
///   with different states for testing and design purposes.
#Preview("CustomizingActionView") {
    VStack {
        CustomizingActionView()
            .environment(CustomizingActionViewModel(state: .none, actionClosure: {}))

        Divider()

        CustomizingActionView()
            .environment(CustomizingActionViewModel(state: .ready, actionClosure: {}))

        Divider()

        CustomizingActionView()
            .environment(CustomizingActionViewModel(state: .preview, actionClosure: {}))

        Divider()

        CustomizingActionView()
            .environment(CustomizingActionViewModel(state: .processing(value: 30), actionClosure: {}))

        Divider()

        CustomizingActionView()
            .environment(CustomizingActionViewModel(state: .error, actionClosure: {}))

        Divider()
        Spacer()
    }
    .frame(width: 236, height: 450)
}
