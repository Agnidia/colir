//
//  DropFolderView.swift
//  colir
//
//  Created by Vitalii P on 04.11.2023.
//  Copyright © 2023 IGR Soft. All rights reserved.
//

import AppKit

extension Notification.Name {
    static let SystemAppearanceDidChange = Notification.Name(rawValue: "AppleInterfaceThemeChangedNotification")
}

/// A view that support dropping files
@IBDesignable
@objc public class DropFolderView: NSView {
    // MARK: - Public accessors

    /// Enable or disable the control
    @IBInspectable public dynamic var isEnabled: Bool = true {
        didSet {
            selectButton.isEnabled = isEnabled

            // Force the cursor to update to reflect the new state
            window?.invalidateCursorRects(for: selectButton)
        }
    }

    /// The drop delegate.
    @IBOutlet public var dropDelegate: DropFolderViewProtocol? {
        didSet {
            syncTitle()
        }
    }

    /// Do we support dropping multiple files at once?
    @IBInspectable var allowsMultipleDrop: Bool = true {
        didSet {
            syncTitle()
        }
    }

    /// The label for the 'select files...' button.  If empty, the button is not displayed.
    @IBInspectable var selectFilesButtonLabel: String = "" {
        didSet {
            syncTitle()
        }
    }

    /// If the select files button is shown, do we display it as a hyperlink or a regular button?
    @IBInspectable var selectFilesButtonIsLink: Bool = true {
        didSet {
            syncTitle()
        }
    }

    /// Should the drop target display an icon.
    @IBInspectable var showIcon: Bool = true {
        didSet {
            syncTitle()
        }
    }

    /// The image to be displayed.
    @IBInspectable var icon: NSImage? = DropFolderViewConstants.icon {
        didSet {
            imageView.image = icon
            syncImage()
        }
    }

    /// Display a informational label. If empty, the label is hidden.
    @IBInspectable var label: String = "" {
        didSet {
            syncTitle()
        }
    }

    /// Display a border around the drop target
    @IBInspectable var isBordered: Bool = true {
        didSet {
            outerBoundary.isHidden = !isBordered
            syncTitle()
        }
    }

    /// Width of the border line around the control
    @IBInspectable var lineWidth: CGFloat = 2 {
        didSet {
            outerBoundary.lineWidth = lineWidth
        }
    }

    /// The corner radius for the border
    @IBInspectable var cornerRadius: CGFloat = 4
    var borderInset: CGFloat {
        return cornerRadius / 2.0
    }

    /// Should we animate the border when we can drop?
    @IBInspectable var isAnimated: Bool = true

    private var isDarkAppearance: Bool = false
    
    // MARK: - Initialization

    override init(frame frameRect: NSRect) {
        super.init(frame: frameRect)
        configureControl()
        addObservers()
    }

    required init?(coder: NSCoder) {
        super.init(coder: coder)
        configureControl()
        addObservers()
    }

    deinit {
        removeObservers()
    }

    func setLabelFont(_ font: NSFont) {
        imageLabel.font = font
    }

    // MARK: - Private definitions

    private let outerBoundary = CAShapeLayer()

    private lazy var containerStack: NSStackView = {
        let s = NSStackView()
        s.translatesAutoresizingMaskIntoConstraints = false
        s.wantsLayer = true
        s.edgeInsets = NSEdgeInsets(top: 4, left: 0, bottom: 4, right: 0)

        s.orientation = .vertical
        s.spacing = 0
        s.alignment = .centerX
        s.setContentHuggingPriority(NSLayoutConstraint.Priority(50), for: .horizontal)
        s.setContentHuggingPriority(NSLayoutConstraint.Priority(50), for: .vertical)

        s.setHuggingPriority(NSLayoutConstraint.Priority(50), for: .horizontal)
        s.setHuggingPriority(NSLayoutConstraint.Priority(50), for: .vertical)

        s.setContentCompressionResistancePriority(.required, for: .horizontal)
        s.setContentCompressionResistancePriority(.required, for: .vertical)

        s.addArrangedSubview(imageView)
        s.addArrangedSubview(imageLabel)
        s.addArrangedSubview(selectButton)

        return s
    }()

    private lazy var imageView: NSImageView = {
        let i = NSImageView()
        i.translatesAutoresizingMaskIntoConstraints = false
        i.wantsLayer = true
        i.imageScaling = .scaleProportionallyDown
        i.image = icon

        i.isEditable = false
        i.unregisterDraggedTypes()

        i.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)
        i.setContentCompressionResistancePriority(.defaultLow, for: .vertical)

        return i
    }()

    private lazy var imageLabel: NSTextField = {
        let t = NSTextField()
        t.translatesAutoresizingMaskIntoConstraints = false
        t.wantsLayer = true
        t.drawsBackground = false
        t.isBezeled = false
        t.font = NSFont.systemFont(ofSize: 18, weight: .bold)
        t.textColor = NSColor.tertiaryLabelColor
        t.stringValue = label
        t.alignment = .center
        t.isEditable = false
        t.isSelectable = false
        t.lineBreakMode = .byWordWrapping

        t.setContentHuggingPriority(.defaultLow, for: .horizontal)
        t.setContentCompressionResistancePriority(.defaultLow, for: .horizontal)

        return t
    }()

    private lazy var selectButton: NSButton = {
        let button = NSButton()
        button.wantsLayer = true
        button.translatesAutoresizingMaskIntoConstraints = false
        button.target = self
        button.action = #selector(selectFiles(_:))
        button.bezelStyle = .rounded
        button.isBordered = false
        button.controlSize = .regular
        button.isEnabled = true
        return button
    }()
}

// MARK: - Action callbacks

extension DropFolderView {
    @objc func selectFiles(_: Any) {
        if let userSelectedFiles = dropDelegate?.dropFilesViewWantsSelectFiles {
            userSelectedFiles(self)
        }
    }
}

// MARK: - UI Layout

extension DropFolderView {
    override public func prepareForInterfaceBuilder() {
        configureControl()
    }

    override public func layout() {
        super.layout()
        outerBoundary.path = CGPath(
            roundedRect: bounds.insetBy(dx: borderInset, dy: borderInset),
            cornerWidth: cornerRadius,
            cornerHeight: cornerRadius, transform: nil
        )
    }

    private func syncImage() {
        let template = icon?.isTemplate ?? false
        imageView.alphaValue = template ? 0.4 : 1.0
    }

    private func syncTitle() {
        let buttonTitle = selectFilesButtonLabel
        if selectFilesButtonIsLink {
            let att = NSAttributedString(
                string: buttonTitle,
                attributes: [
                    NSAttributedString.Key.underlineStyle: NSUnderlineStyle.single.rawValue,
                    NSAttributedString.Key.foregroundColor: NSColor.linkColor,
                ]
            )
            selectButton.isBordered = false
            selectButton.attributedTitle = att
        }
        else {
            selectButton.isBordered = true
            selectButton.title = buttonTitle
        }

        imageView.image = icon
        syncImage()
        imageView.isHidden = !showIcon

        imageLabel.stringValue = label

        // Hide the label if the label text is empty
        imageLabel.isHidden = label.isEmpty

        // Hide the select files button if no text has been set
        let hideSelectFilesButton = selectFilesButtonLabel.isEmpty
        selectButton.isHidden = hideSelectFilesButton
    }

    private func configureControl() {
        wantsLayer = true

        registerForDraggedTypes([.fileURL])
        
        outerBoundary.lineWidth = lineWidth

        outerBoundary.lineDashPattern = [4, 4]
        outerBoundary.lineDashPhase = 0

        layer!.addSublayer(outerBoundary)

        let stack = containerStack
        addSubview(stack)

        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|-(8)-[but]-(8)-|", options: .alignAllCenterY, metrics: nil, views: ["but": stack]))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|-(>=8)-[but]-(>=8)-|", options: .alignAllCenterX, metrics: nil, views: ["but": stack]))

        addConstraint(NSLayoutConstraint(item: stack, attribute: .centerX, relatedBy: .equal, toItem: self, attribute: .centerX, multiplier: 1, constant: 0))
        addConstraint(NSLayoutConstraint(item: stack, attribute: .centerY, relatedBy: .equal, toItem: self, attribute: .centerY, multiplier: 1, constant: 0))
        syncTitle()
        
        updateAppearance()
    }
    
    private func addObservers() {
        DistributedNotificationCenter.default.addObserver(forName: NSNotification.Name.SystemAppearanceDidChange,
                                                                  object: nil, queue: OperationQueue.main) {
          [weak self] notification in
          self?.updateAppearance()
        }
    }
    
    private func removeObservers() {
        DistributedNotificationCenter.default.removeObserver(self, name: NSNotification.Name.SystemAppearanceDidChange, object: nil)
    }
    
    private func updateAppearance() {
        isDarkAppearance = effectiveAppearance.name != .aqua
        
        outerBoundary.strokeColor = backgroundStrokeColor()
        outerBoundary.fillColor = backgroundColor()
    }
}

// MARK: - Drag and drop

public extension DropFolderView {
    private func filesOnPasteboard(for sender: NSDraggingInfo) -> [URL]? {
        let pb = sender.draggingPasteboard
        guard let objs = pb.readObjects(forClasses: [NSURL.self], options: nil) as? [NSURL] else {
            return nil
        }

        let urls = objs.compactMap { $0 as URL }
        return urls.count == 0 ? nil : urls
    }

    // Called when the user has dropped a file

    override func prepareForDragOperation(_ sender: NSDraggingInfo) -> Bool {
        if isEnabled,
            let delegate = dropDelegate,
            let files = filesOnPasteboard(for: sender)
        {
            return delegate.dropFilesView(self, validateFiles: files) != []
        }
        return false
    }

    // When the user has dragged INTO the view

    override func draggingEntered(_ sender: NSDraggingInfo) -> NSDragOperation {
        var dragOperation: NSDragOperation = []

        // If there are no files on the pasteboard then do nothing
        guard let files = filesOnPasteboard(for: sender) else {
            return []
        }

        // If we are in single select and there are multiple files then don't allow drop
        if !allowsMultipleDrop, files.count != 1 {
            return []
        }

        if let delegate = dropDelegate {
            dragOperation = delegate.dropFilesView(self, validateFiles: files)
        }

        if dragOperation == [] {
            outerBoundary.strokeColor = backgroundStrokeColor()
            outerBoundary.fillColor = backgroundColor()
        }
        else {
            outerBoundary.strokeColor = backgroundActiveStrokeColor()
            outerBoundary.fillColor = backgroundActiveColor()

            startAnimation()
        }

        return dragOperation
    }

    // When the user has dragged OUT of the view or drag is cancelled

    override func draggingExited(_: NSDraggingInfo?) {
        outerBoundary.strokeColor = backgroundStrokeColor()
        outerBoundary.fillColor = backgroundColor()
        stopAnimation()
    }

    // Perform the drag operation

    override func performDragOperation(_ sender: NSDraggingInfo) -> Bool {
        stopAnimation()

        outerBoundary.strokeColor = backgroundStrokeColor()
        outerBoundary.fillColor = backgroundColor()

        if let delegate = dropDelegate,
            let files = filesOnPasteboard(for: sender)
        {
            return delegate.dropFilesView(self, didDropFiles: files)
        }

        return false
    }
}

// MARK: - Colors

extension DropFolderView {
    func backgroundColor() -> CGColor {
        if isDarkAppearance {
            NSColor.dropFolderViewBackgroundDark.cgColor
        } else {
            NSColor.dropFolderViewBackground.cgColor
        }
    }

    func backgroundStrokeColor() -> CGColor {
        if isDarkAppearance {
            NSColor.dropFolderViewBackgroundStrokeDark.cgColor
        } else {
            NSColor.dropFolderViewBackgroundStroke.cgColor
        }
    }

    func backgroundActiveColor() -> CGColor {
        NSColor.dropFolderViewBackgroundActive.cgColor
    }

    func backgroundActiveStrokeColor() -> CGColor {
        NSColor.dropFolderViewBackgroundActiveStroke.cgColor
    }
}

// MARK: - Animation

extension DropFolderView {
    func startAnimation() {
        if !isAnimated {
            return
        }

        let lineDashPhaseAnimation = CABasicAnimation(keyPath: "lineDashPhase")
        lineDashPhaseAnimation.byValue = 8.0
        lineDashPhaseAnimation.duration = 0.75
        lineDashPhaseAnimation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        lineDashPhaseAnimation.repeatCount = .greatestFiniteMagnitude

        outerBoundary.add(lineDashPhaseAnimation, forKey: "lineDashPhaseAnimation")
    }

    func stopAnimation() {
        outerBoundary.removeAllAnimations()
    }
}
