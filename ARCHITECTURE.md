# Colir Architecture

**System architecture for macOS icon customization application**

## Overview

Colir is a macOS application that enables users to customize app icons with colors, photos, emojis, and visual effects. The application uses a modern Swift architecture with SwiftUI, following MVVM patterns with strict concurrency compliance. It supports Mac OS Classic resource file parsing for legacy icon extraction.

## Technology Stack

- **Language**: Swift 6.2
- **UI Framework**: SwiftUI with NSView integration
- **Minimum Platform**: macOS 14.1+
- **Architecture**: MVVM (Model-View-ViewModel)
- **Concurrency**: Swift 6 strict concurrency
- **State Management**: @Published, Combine
- **Storage**: @AppStorage for user preferences
- **Third-Party**: Graphite (C++ library for resource parsing)
- **Localization**: English, Ukrainian

## Project Structure

```
colir/
├── Sources/                         # Main application source
│   ├── AppDelegate/                 # App entry point
│   │   ├── BaseApp.swift           # @main entry point
│   │   └── Application.swift       # App initialization
│   ├── Constants/                  # Constants and extensions
│   │   ├── AppCommons.swift
│   │   ├── CGFloat+Constants.swift
│   │   └── Double+Constants.swift
│   ├── Extensions/                 # Swift extensions (16 files)
│   │   ├── NSImage+*.swift        # Image manipulation
│   │   ├── NSColor+*.swift        # Color utilities
│   │   └── View+*.swift           # SwiftUI helpers
│   ├── Logger/                     # Logging infrastructure
│   │   ├── LogProtocol.swift
│   │   └── Logger.swift
│   ├── Managers/                   # Business logic layer
│   │   ├── PhotosApp/             # Photo library access
│   │   ├── PicturesFolder/        # File system management
│   │   ├── FileAccess/            # Permission handling
│   │   ├── IconManager/           # Icon processing
│   │   ├── ExportManager/         # Export functionality
│   │   └── Emojis/                # Emoji management
│   ├── Models/                     # Data structures
│   │   ├── AppSettings.swift
│   │   ├── CryptoModel.swift
│   │   └── EmojiSkinDto.swift
│   ├── Parsers/                    # File format parsers
│   │   └── RSRC/                  # Mac OS Classic resources
│   │       ├── RSRCFileParser.swift
│   │       └── RSRCResource.swift
│   ├── Services/                   # Service layer
│   │   └── AppStore/              # In-app purchases
│   └── Views/                      # SwiftUI interface (50+ files)
│       ├── Home/                  # Main interface
│       │   ├── HomeView.swift
│       │   ├── HomeViewModel.swift
│       │   ├── Tools/             # Tab-based tools
│       │   │   ├── Colors/
│       │   │   ├── Photos/
│       │   │   ├── Pictures/
│       │   │   ├── Emojis/
│       │   │   └── WebResources/
│       │   └── AppliedStyles/
│       ├── ColorWheel/            # Color picker component
│       ├── DropFolderView/        # Drag-drop zone (NSView)
│       ├── Toolbar/               # Top toolbar
│       ├── Styles/                # Custom view styles
│       ├── Modifiers/             # View modifiers
│       └── VisualEffect/          # Visual effects
│
├── 3rdparty/                       # Third-party dependencies
│   └── Graphite/                  # C++ resource parser
│
├── Tests/                          # Unit tests
│   └── colirTests.swift
├── UITests/                        # UI automation tests
│   ├── colirUITests.swift
│   └── colirUITestsLaunchTests.swift
├── Resources/                      # Assets and config
│   ├── Assets.xcassets
│   ├── Preview Content/
│   ├── colir-Info.plist
│   └── Credits.html
├── Localization/                   # Multi-language support
│   ├── InfoPlist.xcstrings
│   └── Localizable.xcstrings
├── Configurations/                 # Build configs
│   ├── base.xcconfig
│   ├── debug.xcconfig
│   ├── release.xcconfig
│   ├── entitlement.entitlements
│   ├── app/
│   └── tests/
└── colir.xcodeproj
```

## Architecture Diagram

```
┌─────────────────────────────────────────────────────────────────┐
│                        SwiftUI App                               │
│                      (BaseApp.swift)                             │
│                     @main BaseApp                                │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Application                                 │
│                  (Application.swift)                             │
│                                                                  │
│  - Application lifecycle management                              │
│  - Window configuration                                          │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                      HomeView                                    │
│                  (Main Interface)                                │
│                                                                  │
│  ┌─────────────────────┬───────────────────────────────────┐    │
│  │   Left Panel        │         Right Panel               │    │
│  │   (236pt fixed)     │         (Tab-based Tools)         │    │
│  │                     │                                    │    │
│  │   ├── Icon Browser  │   ├── Colors (ColorWheel)         │    │
│  │   ├── Applied Styles│   ├── Photos (PhotoLibrary)       │    │
│  │   └── Customization │   ├── Pictures (FileSystem)       │    │
│  │                     │   ├── Emojis                       │    │
│  │                     │   ├── Decals                       │    │
│  │                     │   └── Web Resources                │    │
│  └─────────────────────┴───────────────────────────────────┘    │
└────────────────────────┬────────────────────────────────────────┘
                         │
                         ▼
┌─────────────────────────────────────────────────────────────────┐
│                     HomeViewModel                                │
│              (@ObservableObject, @MainActor)                     │
│                                                                  │
│  Orchestrates:                                                   │
│  ├── Icon selection and preview                                  │
│  ├── Style application                                           │
│  ├── Tool state management                                       │
│  ├── Undo/Redo operations                                        │
│  └── Export coordination                                         │
└────────────────────────┬────────────────────────────────────────┘
                         │
          ┌──────────────┼──────────────┬──────────────┐
          ▼              ▼              ▼              ▼
┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐ ┌─────────────────┐
│ PicturesFolder  │ │ PhotoLibrary    │ │ FileAccess      │ │ Icon            │
│ Manager         │ │ AccessManager   │ │ Manager         │ │ Manager         │
│                 │ │                 │ │                 │ │                 │
│ ├── Browse      │ │ ├── Request     │ │ ├── Bookmark    │ │ ├── Process     │
│ ├── Filter      │ │ ├── Fetch       │ │ ├── Access      │ │ ├── Transform   │
│ └── Watch       │ │ └── Albums      │ │ └── Validate    │ │ └── Export      │
└─────────────────┘ └─────────────────┘ └─────────────────┘ └─────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────────┐
│                      Parser Layer                                │
├─────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ RSRCFileParser                                               │ │
│ │                                                              │ │
│ │ - Mac OS Classic resource file parsing                       │ │
│ │ - Uses Graphite C++ library                                  │ │
│ │ - Extracts icons from .rsrc files                           │ │
│ └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
          │
          ▼
┌─────────────────────────────────────────────────────────────────┐
│                     Service Layer                                │
├─────────────────────────────────────────────────────────────────┤
│ ┌─────────────────────────────────────────────────────────────┐ │
│ │ AppStore Service                                             │ │
│ │                                                              │ │
│ │ - In-app purchases via StoreKitPlus                         │ │
│ │ - Premium feature unlocking                                  │ │
│ │ - Purchase restoration                                       │ │
│ └─────────────────────────────────────────────────────────────┘ │
└─────────────────────────────────────────────────────────────────┘
```

## Core Architecture Layers

### Application Layer

The application entry point uses SwiftUI's `@main` attribute:

```swift
@main
struct BaseApp: App {
    var body: some Scene {
        WindowGroup {
            ContentView()
        }
    }
}
```

**Key Components**:
- **BaseApp.swift**: @main entry point with WindowGroup scene
- **Application.swift**: App initialization and configuration

### ViewModel Layer

**HomeViewModel** manages the main interface state:

- **@ObservableObject**: Publishes changes for SwiftUI
- **@MainActor**: Ensures UI operations on main thread
- **Protocol-based dependencies**: Enables testing
- **Undo/Redo**: Integration with native UndoManager

### Manager Layer

Business logic is encapsulated in manager classes:

| Manager | Responsibility |
|---------|----------------|
| **PicturesFolderManager** | File system folder browsing and watching |
| **PhotoLibraryAccessManager** | Photos app integration and album access |
| **FileAccessManager** | Security-scoped bookmark management |
| **IconManager** | Icon processing, transformation, effects |
| **ExportIconManager** | Multi-format export (.icns, .png, etc.) |
| **EmojisManager** | Emoji catalog and skin tone variants |

### View Layer

SwiftUI views organized by feature:

- **Home/**: Main interface with split layout and tab-based tools
- **ColorWheel/**: Interactive HSB color picker (NSView bridge)
- **DropFolderView/**: Drag-and-drop zone (NSView bridge)
- **Toolbar/**: Application toolbar with actions
- **Styles/**: Custom button and view styles
- **Modifiers/**: Reusable view modifiers

### Parser Layer

**RSRCFileParser** handles Mac OS Classic resource files:

- Parses `.rsrc` resource fork files
- Extracts icon resources (icns, ICON, ICN#)
- Uses Graphite C++ library via bridging header
- Supports legacy application icon extraction

### Extension Layer

16 Swift extensions for framework augmentation:

| Category | Extensions |
|----------|------------|
| **NSImage** | Tint, Data, Alpha, Resize, Effects |
| **NSColor** | Hex conversion, Color lists |
| **View** | Hide, Conditional modifiers |
| **CGFloat/Double** | UI constants |

## Data Flow

### Icon Customization Flow

```
User drops icon file
    ↓
DropFolderView (NSView) detects drop
    ↓
FileAccessManager validates access
    ↓
┌─────────────────────────────────────┐
│ If .rsrc file:                      │
│ RSRCFileParser.parse()              │
│ Extract icon resources              │
└─────────────────────────────────────┘
    ↓
IconManager.loadIcon()
    ↓
HomeViewModel updates state
    ↓
User applies customizations:
├── Color overlay (ColorWheel)
├── Photo background (PhotoLibrary)
├── Emoji decoration (EmojisManager)
└── Visual effects (Extensions)
    ↓
IconManager.applyTransformations()
    ↓
Preview updates in real-time
    ↓
ExportIconManager.export()
    ↓
Save to user-selected location
```

### Data Models

**AppSettings** - User preferences:
```swift
struct AppSettings {
    @AppStorage var selectedTool: ToolType
    @AppStorage var recentColors: [Color]
    @AppStorage var exportFormat: ExportFormat
    // ... additional settings
}
```

**ImageDto** - Icon data transfer:
```swift
struct ImageDto: Equatable, Sendable {
    let image: NSImage
    let name: String
    let path: URL?
    let metadata: ImageMetadata?
}
```

## Concurrency Model

### Swift Strict Concurrency

The app uses `SWIFT_STRICT_CONCURRENCY = complete`:

- **@MainActor**: All UI-related code (ViewModels, Views)
- **Sendable**: All data models
- **async/await**: Asynchronous operations
- **Combine**: Reactive state updates

### Actor Isolation

```swift
@MainActor
final class HomeViewModel: ObservableObject {
    @Published var selectedIcon: ImageDto?
    @Published var appliedStyles: [StyleDto]

    func applyColor(_ color: Color) async {
        // UI-safe color application
    }
}
```

## Build Configuration

### Configuration Files

```
Configurations/
├── base.xcconfig           # Shared settings
├── debug.xcconfig          # Debug optimizations
├── release.xcconfig        # Release optimizations
├── entitlement.entitlements
├── app/
│   ├── app.xcconfig
│   ├── app-debug.xcconfig
│   └── app-release.xcconfig
└── tests/
    ├── test.xcconfig
    └── uitest.xcconfig
```

### Key Build Settings

- **Product Name**: colir
- **Bundle ID**: com.igrsoft.colir
- **Development Team**: DMP42GVPJ3 (IGR Soft)
- **Deployment Target**: macOS 14.1
- **Code Signing**: Automatic with hardened runtime
- **App Sandbox**: Enabled

## Testing Strategy

### Unit Tests

Located in `Tests/`:
- ViewModel tests
- Manager tests
- Parser tests
- Extension tests

### UI Tests

Located in `UITests/`:
- Application launch tests
- User flow tests
- Drag-and-drop tests

## Security & Permissions

### Entitlements

```xml
<!-- Photo Library access -->
<key>com.apple.security.personal-information.photos-library</key>
<true/>

<!-- File system access -->
<key>com.apple.security.files.user-selected.read-write</key>
<true/>

<key>com.apple.security.files.pictures-folder.read-only</key>
<true/>

<!-- Network access for web resources -->
<key>com.apple.security.network.client</key>
<true/>
```

### Privacy

- **Local Processing**: All icon processing happens locally
- **No Telemetry**: No data sent to external services
- **User Consent**: Permissions requested with clear descriptions
- **Sandboxed**: App runs in macOS sandbox

## Info.plist Permissions

```xml
<!-- Photo Library access -->
<key>NSPhotoLibraryUsageDescription</key>
<string>Colir uses your photo library to apply images to icons.</string>
```

## Dependencies

### Swift Package Manager

| Package | Purpose |
|---------|---------|
| **SwiftCommons** | Common utilities |
| **SystemSettingsAccess** | System preferences integration |
| **DominantColor** | Color extraction from images |
| **Throttler** | Debouncing/throttling |
| **StoreKitPlus** | Enhanced StoreKit |
| **swift-algorithms** | Collection algorithms |

### Third-Party (Vendored)

| Library | Purpose |
|---------|---------|
| **Graphite** | Mac OS Classic resource parsing (C++) |

## Resources

### Project Documentation

- [README.md](README.md) - Project overview and setup
- [CLAUDE.md](CLAUDE.md) - AI agent configuration

### Apple Documentation

- [SwiftUI](https://developer.apple.com/xcode/swiftui/)
- [AppKit](https://developer.apple.com/documentation/appkit)
- [Photos Framework](https://developer.apple.com/documentation/photos)
- [Swift Concurrency](https://docs.swift.org/swift-book/LanguageGuide/Concurrency.html)

## Accessibility

Colir implements comprehensive accessibility support for WCAG 2.1 Level A compliance:

### VoiceOver Support

All interactive elements are accessible via VoiceOver with:
- **Descriptive labels**: Clear, meaningful labels for all controls
- **Contextual hints**: Instructions for available actions
- **State announcements**: Dynamic updates for state changes

### Keyboard Navigation

Full keyboard accessibility:
- **Tab navigation**: Standard focus traversal through interactive elements
- **Arrow keys**: ColorWheelNSView supports hue/saturation adjustment
- **Delete/Backspace**: Remove applied styles from StyleTagView
- **Escape**: Standard dismissal patterns

### Implementation Patterns

#### SwiftUI Accessibility

```swift
// Standard button accessibility
.accessibilityElement(children: .ignore)
.accessibilityLabel("Button description")
.accessibilityHint("Action result")
.accessibilityAddTraits([.isButton])

// Toggle/Disclosure accessibility
.accessibilityLabel("\(label), \(count) items, \(isExpanded ? "expanded" : "collapsed")")
.accessibilityHint(isExpanded ? "Double tap to collapse" : "Double tap to expand")

// Interactive zone accessibility
.accessibilityElement(children: .combine)
.accessibilityValue(hasContent ? "Content selected" : "Empty")
```

#### NSView Accessibility (AppKit)

For bridged NSViews like ColorWheelNSView:

```swift
extension ColorWheelNSView {
    override func accessibilityRole() -> NSAccessibility.Role? { .slider }
    override func accessibilityLabel() -> String? { "Color picker wheel" }
    override func accessibilityValue() -> Any? {
        "Hue \(hueDegrees) degrees, Saturation \(saturationPercent) percent"
    }
    override func accessibilityHelp() -> String? {
        "Use arrow keys to adjust color"
    }
}
```

### Reference Implementation

**SelectableGridCell** serves as the reference pattern for accessible grid items:
- Consistent label/hint pattern
- Keyboard focus support with `.focusable()`
- Selection state announcement

### Accessibility Extensions

`View+Accessibility.swift` provides reusable modifiers:
- `accessibleButton(label:hint:isSelected:)`
- `accessibleToggle(label:isExpanded:itemCount:)`
- `accessibleZone(label:hint:hasContent:)`
- `accessibleRemovableItem(label:removeHint:)`

### Accessibility Checklist

For new views, ensure:
- [ ] All interactive elements have `accessibilityLabel`
- [ ] Actions have `accessibilityHint`
- [ ] State changes update `accessibilityValue`
- [ ] Keyboard navigation works (Tab, arrows, Delete)
- [ ] VoiceOver announces all content correctly

## Architecture Principles

1. **MVVM** - Clear separation of views, view models, and models
2. **Protocol-Based Design** - Managers follow protocols for testability
3. **Manager Pattern** - Business logic in dedicated managers
4. **Strict Concurrency** - Swift 6 ready with complete checking
5. **Extension Pattern** - Framework augmentation via extensions
6. **Reactive State** - Combine publishers for state updates
7. **Sandboxed Security** - App sandbox with minimal permissions
8. **Accessible Design** - WCAG 2.1 compliant with VoiceOver support
