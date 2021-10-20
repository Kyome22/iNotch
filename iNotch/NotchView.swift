//
//  NotchView.swift
//  iNotch
//
//  Created by Takuto Nakamura on 2021/10/20.
//

import Cocoa
import Combine

class NotchView: NSView {
    private var mouseDownSubject = PassthroughSubject<NSPoint, Never>()
    var mouseDownPublisher: AnyPublisher<NSPoint, Never> {
        return mouseDownSubject.eraseToAnyPublisher()
    }
    
    override func draw(_ dirtyRect: NSRect) {
        super.draw(dirtyRect)
        let size = self.frame.size
        let r: CGFloat = 6.0
        let gap: CGFloat = 1.5
        let notch = NSBezierPath()
        notch.move(to: NSPoint(x: 0.0, y: size.height))
        notch.curve(to: NSPoint(x: r, y: size.height - r),
                    controlPoint1: NSPoint(x: r - gap, y: size.height),
                    controlPoint2: NSPoint(x: r, y: size.height - gap))
        notch.line(to: NSPoint(x: r, y: r))
        notch.curve(to: NSPoint(x: 2 * r, y: 0.0),
                    controlPoint1: NSPoint(x: r, y: gap),
                    controlPoint2: NSPoint(x: r + gap, y: 0.0))
        notch.line(to: NSPoint(x: size.width - 2 * r, y: 0.0))
        notch.curve(to: NSPoint(x: size.width - r, y: r),
                    controlPoint1: NSPoint(x: size.width - r - gap, y: 0.0),
                    controlPoint2: NSPoint(x: size.width - r, y: gap))
        notch.line(to: NSPoint(x: size.width - r, y: size.height - r))
        notch.curve(to: NSPoint(x: size.width, y: size.height),
                    controlPoint1: NSPoint(x: size.width - r, y: size.height - gap),
                    controlPoint2: NSPoint(x: size.width - r + gap, y: size.height))
        notch.close()
        NSColor.black.setFill()
        notch.fill()
        
        let cameraRect = NSRect(x: self.frame.midX - 6.0,
                                y: self.frame.midY - 6.0,
                                width: 12.0,
                                height: 12.0)
        let camera = NSBezierPath(ovalIn: cameraRect)
        NSColor(white: 0.07, alpha: 1.0).setFill()
        camera.fill()
        
        let greenRect = NSRect(x: self.frame.midX + 12.0,
                               y: self.frame.midY - 1.0,
                               width: 2.0,
                               height: 2.0)
        let green = NSBezierPath(ovalIn: greenRect)
        NSColor(srgbRed: 0.035, green: 0.974, blue: 0.249, alpha: 0.9).setFill()
        green.fill()
    }
    
    override func mouseDown(with event: NSEvent) {
        super.mouseDown(with: event)
        mouseDownSubject.send(event.locationInWindow)
    }
}
