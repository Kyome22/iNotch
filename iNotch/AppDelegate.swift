//
//  AppDelegate.swift
//  iNotch
//
//  Created by Takuto Nakamura on 2021/10/20.
//

import Cocoa
import Combine

class AppDelegate: NSObject, NSApplicationDelegate {
    private var notchPanel: NotchPanel?
    private var cancellables = Set<AnyCancellable>()

    func applicationDidFinishLaunching(_ aNotification: Notification) {
        showNotchPanel()
    }
    
    func applicationWillTerminate(_ notification: Notification) {
        cancellables.removeAll()
    }

    func applicationSupportsSecureRestorableState(_ app: NSApplication) -> Bool {
        return true
    }
    
    private func showNotchPanel() {
        guard notchPanel == nil else { return }
        if let screen = NSScreen.main {
            let center = NSPoint(x: screen.frame.midX, y: screen.frame.maxY)
            notchPanel = NotchPanel(center)
            notchPanel?.orderFrontRegardless()
            notchPanel?.fadeIn()
            notchPanel?.notchClickPublisher
                .sink(receiveValue: { [weak self] point in
                    self?.showContextMenu(at: point)
                })
                .store(in: &cancellables)
        }
    }
    
    private func showContextMenu(at: NSPoint) {
        let menu = NSMenu(title: "Menu")
        menu.addItem(withTitle: "About",
                     action: #selector(openAboutPanel(_:)),
                     keyEquivalent: "")
        menu.addItem(withTitle: "Quit",
                     action: #selector(removeNotchAndTerminate(_:)),
                     keyEquivalent: "")
        menu.popUp(positioning: nil, at: at, in: notchPanel?.notchView)
    }
    
    @objc func openAboutPanel(_ sender: Any?) {
        NSApp.activate(ignoringOtherApps: true)
        let mutableAttrStr = NSMutableAttributedString()
        var attr: [NSAttributedString.Key : Any] = [.foregroundColor : NSColor.textColor]
        let oss = "iNotch is an open-source software.\n"
        mutableAttrStr.append(NSAttributedString(string: oss, attributes: attr))
        let url = "https://github.com/Kyome22/iNotch"
        attr = [.foregroundColor : NSColor(named: "urlColor")!, .link : url]
        mutableAttrStr.append(NSAttributedString(string: url, attributes: attr))
        let key = NSApplication.AboutPanelOptionKey.credits
        NSApp.orderFrontStandardAboutPanel(options: [key: mutableAttrStr])
    }
    
    @objc func removeNotchAndTerminate(_ sender: Any?) {
        if let notchPanel = notchPanel {
            notchPanel.fadeOut { NSApp.terminate(nil) }
        } else {
            NSApp.terminate(nil)
        }
    }
    
    private func setNotification() {
        let nc = NotificationCenter.default
        nc.publisher(for: NSApplication.didChangeScreenParametersNotification)
            .sink(receiveValue: { [weak self] _ in
                self?.updateNotchPosition()
            })
            .store(in: &cancellables)
    }
    
    private func updateNotchPosition() {
        if let screen = NSScreen.main {
            let center = NSPoint(x: screen.frame.midX, y: screen.frame.maxY)
            notchPanel?.updateOrigin(center: center)
        }
    }
}

