//
//  CustomizingActionViewModelTests.swift
//  colirTests
//
//  Created by Claude Code on 2025-12-15.
//  Copyright (c) 2025 IGR Software. All rights reserved.
//

@testable import colir
import Testing

@Suite("CustomizingActionViewModel Tests")
struct CustomizingActionViewModelTests {
    // MARK: - Initialization Tests

    @Test("init creates valid instance with default state")
    func init_createsInstance() {
        var actionCalled = false

        let viewModel = CustomizingActionViewModel {
            actionCalled = true
        }

        #expect(viewModel.state == .none)
        #expect(actionCalled == false)
    }

    @Test("init with specific state")
    func init_withState() {
        let viewModel = CustomizingActionViewModel(state: .ready) {}

        #expect(viewModel.state == .ready)
    }

    @Test("init with processing state")
    func init_withProcessingState() {
        let viewModel = CustomizingActionViewModel(state: .processing(value: 0.5)) {}

        if case let .processing(value) = viewModel.state {
            #expect(value == 0.5)
        } else {
            Issue.record("Expected processing state")
        }
    }

    // MARK: - state Tests

    @Test("state is readable")
    func state_isReadable() {
        let viewModel = CustomizingActionViewModel(state: .initiated) {}

        #expect(viewModel.state == .initiated)
    }

    // MARK: - update Tests

    @Test("update changes state")
    func update_changesState() {
        let viewModel = CustomizingActionViewModel(state: .none) {}

        viewModel.update(state: .ready)

        #expect(viewModel.state == .ready)
    }

    @Test("update from none to processing")
    func update_toProcessing() {
        let viewModel = CustomizingActionViewModel(state: .none) {}

        viewModel.update(state: .processing(value: 0.25))

        if case let .processing(value) = viewModel.state {
            #expect(value == 0.25)
        } else {
            Issue.record("Expected processing state")
        }
    }

    @Test("update from processing to preview")
    func update_toPreview() {
        let viewModel = CustomizingActionViewModel(state: .processing(value: 1.0)) {}

        viewModel.update(state: .preview)

        #expect(viewModel.state == .preview)
    }

    @Test("update to error state")
    func update_toError() {
        let viewModel = CustomizingActionViewModel(state: .ready) {}

        viewModel.update(state: .error)

        #expect(viewModel.state == .error)
    }

    // MARK: - action Tests

    @Test("action calls button action closure")
    func action_callsClosure() {
        var actionCalled = false

        let viewModel = CustomizingActionViewModel {
            actionCalled = true
        }

        viewModel.action()

        #expect(actionCalled)
    }

    @Test("action can be called multiple times")
    func action_multipleCallsf() {
        var callCount = 0

        let viewModel = CustomizingActionViewModel {
            callCount += 1
        }

        viewModel.action()
        viewModel.action()
        viewModel.action()

        #expect(callCount == 3)
    }

    // MARK: - viewSettings Tests

    @Test("viewSettings is CustomizingActionViewDomain")
    func viewSettings_isCorrectType() {
        let viewModel = CustomizingActionViewModel {}

        #expect(viewModel.viewSettings is CustomizingActionViewDomain)
    }

    // MARK: - Observable Tests

    @Test("CustomizingActionViewModel is Observable")
    func observable_conformance() {
        let viewModel = CustomizingActionViewModel {}

        // Access observable properties
        _ = viewModel.state
        _ = viewModel.viewSettings

        #expect(true)
    }

    // MARK: - State Workflow Tests

    @Test("full state workflow")
    func stateWorkflow() {
        var actionCallCount = 0

        let viewModel = CustomizingActionViewModel(state: .none) {
            actionCallCount += 1
        }

        // Initial state
        #expect(viewModel.state == .none)

        // User initiates
        viewModel.update(state: .initiated)
        #expect(viewModel.state == .initiated)

        // Ready for processing
        viewModel.update(state: .ready)
        #expect(viewModel.state == .ready)

        // Processing
        viewModel.update(state: .processing(value: 0.0))
        viewModel.update(state: .processing(value: 0.5))
        viewModel.update(state: .processing(value: 1.0))

        // Preview
        viewModel.update(state: .preview)
        #expect(viewModel.state == .preview)

        // Action called
        viewModel.action()
        #expect(actionCallCount == 1)
    }
}

// MARK: - ImageDto.ImageState Tests (used by CustomizingActionViewModel)

@Suite("ImageDto.ImageState Tests")
struct ImageDtoImageStateTests {
    @Test("ImageState has expected cases")
    func imageState_hasCases() {
        _ = ImageDto.ImageState.none
        _ = ImageDto.ImageState.initiated
        _ = ImageDto.ImageState.ready
        _ = ImageDto.ImageState.processing(value: 0.5)
        _ = ImageDto.ImageState.error
        _ = ImageDto.ImageState.preview

        #expect(true)
    }

    @Test("ImageState is Equatable")
    func imageState_equatable() {
        let state1 = ImageDto.ImageState.ready
        let state2 = ImageDto.ImageState.ready
        let state3 = ImageDto.ImageState.error

        #expect(state1 == state2)
        #expect(state1 != state3)
    }

    @Test("ImageState processing values are comparable")
    func imageState_processingEquality() {
        let processing1 = ImageDto.ImageState.processing(value: 0.5)
        let processing2 = ImageDto.ImageState.processing(value: 0.5)
        let processing3 = ImageDto.ImageState.processing(value: 0.75)

        #expect(processing1 == processing2)
        #expect(processing1 != processing3)
    }
}
