# Planning: App Freezes When Applying Large Picture

## Problem Statement

The application freezes (becomes unresponsive) when the user attempts to apply a large picture. This is a critical UX issue that makes the app unusable for images above a certain size threshold.

## Investigation Results ✅

- [x] Identify where image processing occurs (main thread vs background)
- [x] Find the code path for "applying" a picture
- [x] Determine if there's async/await usage or blocking operations
- [x] Check for any size limits or throttling mechanisms
- [x] Review memory management during image operations

### Root Cause Identified

**Location:** `HomeViewModel.swift:161-185` - `apply(image:asset:item:)` method

**Problem:** Synchronous, blocking image processing operations execute on the main thread BEFORE the async Task is created:

1. `realImage.scaled(to: .init(width: 1024, height: 1024))` - Heavy scaling operation (200-500ms)
2. `picture.cutImage(by: .folderCenterFrame)` - Image clipping operation (100-300ms)

**Total UI freeze time:** 300-800ms for large images (4000×3000 px)

### Affected Files

| File | Line | Issue |
|------|------|-------|
| `HomeViewModel.swift` | 170-171 | Main thread blocking before Task |
| `NSImage+Scale.swift` | 43-60 | lockFocus/unlockFocus blocking |
| `NSImage+CutPath.swift` | 17-40 | lockFocus/unlockFocus blocking |

## Requirements

### Functional
- App must remain responsive when processing large images
- User should see progress indication for long operations
- Operations should be cancellable if taking too long

### Non-Functional
- UI thread must never block for more than 100ms
- Image processing should happen on background threads
- Memory usage should be bounded for large images

## Acceptance Criteria

- [ ] App remains responsive with images up to 50MB
- [ ] Progress indicator shown for operations > 500ms
- [ ] No UI freeze or "beach ball" cursor
- [ ] Proper Swift 6 concurrency patterns used

## Success Metrics

- Zero UI freezes during image operations
- Smooth user experience regardless of image size

## Constraints

- Must use Swift 6 concurrency (async/await, actors)
- Must not break existing functionality
- Must work within macOS sandbox constraints
