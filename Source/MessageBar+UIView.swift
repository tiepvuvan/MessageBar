//
//  MessageBar+UIView.swift
//  MessageBar
//
//  Created by Peter Vu on 12/27/16.
//  Copyright © 2016 Peter Vu. All rights reserved.
//

import UIKit

public enum MessageBarPosition {
    case top, bottom
}

extension TimeInterval {
    static let forever: TimeInterval = 999999
}

extension MessageBarManager {
    public func present(message: MessageBarContentProvider,
                        inView containerView: UIView,
                        position: MessageBarPosition = .top,
                        animated: Bool = true,
                        animationType: AnimationType = .slide,
                        animationDuration: TimeInterval = 0.3,
                        forDuration duration: TimeInterval = .forever,
                        tapToDismiss: Bool = false) {
        let viewContainer = MessageBarViewContainer(containerView: containerView, barPosition: position)
        present(message: message,
                inContainer: viewContainer,
                animated: animated,
                animationType: animationType,
                animationDuration: animationDuration,
                forDuration: duration,
                tapToDismiss: tapToDismiss)
    }
}

class MessageBarViewControllerContainer: MessageBarContainerType {
    private let viewContainer: MessageBarViewContainer
    var barPosition: MessageBarPosition { return viewContainer.barPosition }
    
    public init(containerViewController: UIViewController, barPosition: MessageBarPosition) {
        viewContainer = MessageBarViewContainer(containerView: containerViewController.view,
                                                barPosition: barPosition)
    }
    
    open func insert(messageBarContentView: UIView) {
        viewContainer.insert(messageBarContentView: messageBarContentView)
    }
    
    open func initialFrame(forMessage message: MessageBarContentProvider) -> CGRect {
        return viewContainer.initialFrame(forMessage: message)
    }
    
    open func finalFrame(forMessage message: MessageBarContentProvider) -> CGRect {
        return viewContainer.finalFrame(forMessage: message)
    }
}
