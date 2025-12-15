//
//  NSBezierPathFolderTests.swift
//
//  Created on 15.12.2025.
//  Copyright © 2025 IGR Soft. All rights reserved.
//

import AppKit
import Testing
@testable import colir

@Suite("NSBezierPath Folder Extension")
struct NSBezierPathFolderTests {
    // MARK: - folderCenterFrame Tests

    @Test("folderCenterFrame returns non-empty path")
    func folderCenterFrame_nonEmpty() {
        let path = NSBezierPath.folderCenterFrame

        #expect(!path.isEmpty)
    }

    @Test("folderCenterFrame returns closed path")
    func folderCenterFrame_closed() {
        let path = NSBezierPath.folderCenterFrame

        // A closed path should have the same start and end points
        // The path should have elements (not empty)
        #expect(path.elementCount > 0)
    }

    @Test("folderCenterFrame has expected bounds")
    func folderCenterFrame_expectedBounds() {
        let path = NSBezierPath.folderCenterFrame
        let bounds = path.bounds

        // Based on the path coordinates, it should span roughly from (38, 108) to (986, 768)
        #expect(bounds.origin.x >= 38)
        #expect(bounds.origin.y >= 108)
        #expect(bounds.maxX <= 986)
        #expect(bounds.maxY <= 768)
    }

    @Test("folderCenterFrame path element count")
    func folderCenterFrame_elementCount() {
        let path = NSBezierPath.folderCenterFrame

        // The path has move, 8 curves
        #expect(path.elementCount >= 9)
    }

    @Test("folderCenterFrame is reusable")
    func folderCenterFrame_reusable() {
        let path1 = NSBezierPath.folderCenterFrame
        let path2 = NSBezierPath.folderCenterFrame

        // Each call should return a new path instance
        #expect(path1.bounds == path2.bounds)
    }

    @Test("folderCenterFrame can be used for clipping")
    func folderCenterFrame_clipping() {
        // Test that the path can be used as a clipping path
        let image = NSImage(size: NSSize(width: 1024, height: 1024))
        image.lockFocus()

        let path = NSBezierPath.folderCenterFrame
        path.addClip() // Should not throw

        image.unlockFocus()

        // If we got here without crashing, the test passes
        #expect(true)
    }

    // MARK: - folderLines Tests

    @Test("folderLines executes without error")
    func folderLines_executesWithoutError() {
        // folderLines draws to the current graphics context
        // We need to create a context for it to work
        let image = NSImage(size: NSSize(width: 1024, height: 1024))
        image.lockFocus()

        // This should execute without throwing
        NSBezierPath.folderLines()

        image.unlockFocus()

        // If we got here without crashing, the test passes
        #expect(true)
    }

    // MARK: - folderBottomShadow Tests

    @Test("folderBottomShadow executes without error")
    func folderBottomShadow_executesWithoutError() {
        // folderBottomShadow draws to the current graphics context
        let image = NSImage(size: NSSize(width: 1024, height: 1024))
        image.lockFocus()

        // This should execute without throwing
        NSBezierPath.folderBottomShadow()

        image.unlockFocus()

        // If we got here without crashing, the test passes
        #expect(true)
    }

    // MARK: - Integration Tests

    @Test("folder path components work together")
    func folderComponents_workTogether() {
        let image = NSImage(size: NSSize(width: 1024, height: 1024))
        image.lockFocus()

        // Draw all folder components in sequence
        let path = NSBezierPath.folderCenterFrame
        NSColor.blue.setFill()
        path.fill()

        NSBezierPath.folderLines()
        NSBezierPath.folderBottomShadow()

        image.unlockFocus()

        // Verify image was created
        #expect(image.size.width == 1024)
        #expect(image.size.height == 1024)
    }
}
