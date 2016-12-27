//
//  MessageBar+UIWindow.swift
//  MessageBar
//
//  Created by Peter Vu on 12/27/16.
//  Copyright © 2016 Peter Vu. All rights reserved.
//

import UIKit

public extension MessageBarManager {
    public func present(message: MessageBarContentProvider,
                        position: MessageBarPosition = .top,
                        windowLevel: UIWindowLevel,
                        animated: Bool = true,
                        animationType: AnimationType = .slide,
                        animationDuration: TimeInterval = 0.3,
                        forDuration duration: TimeInterval = .forever,
                        tapToDismiss: Bool = false) {
        let windowContainer = MessageBarWindowContainer(barPosition: position)
        windowContainer.window.windowLevel = windowLevel
        
        present(message: message,
                inContainer: windowContainer,
                animated: animated,
                animationType: animationType,
                animationDuration: animationDuration,
                forDuration: duration,
                tapToDismiss: tapToDismiss)
    }
}

open class MessageBarWindowContainer: MessageBarContainerType {
    let window: UIWindow
    private let viewControllerContainer: MessageBarViewControllerContainer
    private let rootViewController: UIViewController
    
    open var barPosition: MessageBarPosition
    private var oldKeyWindow: UIWindow?
    
    public init(barPosition: MessageBarPosition) {
        self.window = PassthroughWindow(frame: UIScreen.main.bounds)
        self.window.windowLevel = UIWindowLevelStatusBar
        self.rootViewController = UIViewController()
        self.rootViewController.view.backgroundColor = .clear
        self.window.rootViewController = rootViewController
        self.barPosition = barPosition
        self.viewControllerContainer = MessageBarViewControllerContainer(containerViewController: rootViewController, barPosition: barPosition)
    }
    
    public func insert(messageBarContentView: UIView) {
        viewControllerContainer.insert(messageBarContentView: messageBarContentView)
    }
    
    public func initialFrame(forMessage message: MessageBarContentProvider) -> CGRect {
        return viewControllerContainer.initialFrame(forMessage: message)
    }
    
    public func finalFrame(forMessage message: MessageBarContentProvider) -> CGRect {
        return viewControllerContainer.finalFrame(forMessage: message)
    }
    
    public func willPresent() {
        oldKeyWindow = UIApplication.shared.keyWindow
        window.isHidden = false
        window.becomeKey()
        window.makeKeyAndVisible()
        
        oldKeyWindow?.resignKey()
    }
    
    public func didDismiss() {
        window.resignKey()
        window.isHidden = true
        
        oldKeyWindow?.becomeKey()
        oldKeyWindow?.makeKeyAndVisible()
        
        oldKeyWindow = nil
    }
}

private class PassthroughWindow: UIWindow {
    fileprivate override func hitTest(_ point: CGPoint, with event: UIEvent?) -> UIView? {
        if let viewControllerViewContainer = rootViewController?.view {
            for view in viewControllerViewContainer.subviews {
                if let passthroughHitView = view.hitTest(convert(point, to: view), with: event) {
                    return passthroughHitView
                }
            }
        }
        return nil
    }
}
