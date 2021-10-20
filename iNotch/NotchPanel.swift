//
//  NotchPanel.swift
//  iNotch
//
//  Created by Takuto Nakamura on 2021/10/20.
//

import Cocoa
import Combine

class NotchPanel: NSPanel {
    private let notchSize = NSSize(width: 128.0, height: 22.0)
    private(set) var notchView = NotchView()
    
    var notchClickPublisher: AnyPublisher<NSPoint, Never> {
        return notchView.mouseDownPublisher
    }
    
    init(_ center: NSPoint) {
        let frame = NSRect(x: center.x - 0.5 * notchSize.width,
                           y: center.y - notchSize.height,
                           width: notchSize.width,
                           height: notchSize.height)
        super.init(contentRect: frame,
                   styleMask: [.borderless, .nonactivatingPanel],
                   backing: .buffered,
                   defer: true)
        self.level = .popUpMenu
        self.collectionBehavior = [.canJoinAllSpaces, .fullScreenAuxiliary]
        self.isOpaque = false
        self.hasShadow = false
        self.backgroundColor = NSColor.clear
        
        setNotchView()
    }
    
    private func setNotchView() {
        self.contentView?.addSubview(notchView)
        notchView.translatesAutoresizingMaskIntoConstraints = false
        notchView.leftAnchor
            .constraint(equalTo: self.contentView!.leftAnchor)
            .isActive = true
        notchView.topAnchor
            .constraint(equalTo: self.contentView!.topAnchor)
            .isActive = true
        notchView.rightAnchor
            .constraint(equalTo: self.contentView!.rightAnchor)
            .isActive = true
        notchView.bottomAnchor
            .constraint(equalTo: self.contentView!.bottomAnchor)
            .isActive = true
    }
    
    func fadeIn() {
        NSAnimationContext.runAnimationGroup { context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            self.notchView.animator().alphaValue = 1.0
        }
    }
    
    func fadeOut(_ callback: (() -> Void)?) {
        NSAnimationContext.runAnimationGroup({ context in
            context.duration = 0.3
            context.allowsImplicitAnimation = true
            self.notchView.animator().alphaValue = 0.0
        }) {
            callback?()
            self.close()
        }
    }
    
    func updateOrigin(center: NSPoint) {
        let frame = NSRect(x: center.x - 0.5 * notchSize.width,
                           y: center.y - notchSize.height,
                           width: notchSize.width,
                           height: notchSize.height)
        self.setFrame(frame, display: true)
    }
}
