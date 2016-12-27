//
//  MessageBarManager.swift
//  MessageBar
//
//  Created by Peter Vu on 12/15/16.
//  Copyright © 2016 Peter Vu. All rights reserved.
//

import UIKit

public class MessageBarManager: MessageBarDismissTargetType {
    public private(set) var isBarShowing: Bool = false {
        didSet {
            if isBarShowing {
                container?.willPresent()
            } else {
                container?.didDismiss()
                container = nil
                message?.messageBarContentView.removeFromSuperview()
                message = nil
                dismissActions.forEach { $0.messageBarDismissTarget = nil }
                dismissActions = []
                presentAnimation = nil
                dismissAnimation = nil
                animated = false
            }
        }
    }
    
    private var container: MessageBarContainerType?
    private var message: MessageBarContentProvider?
    private var dismissActions: [MessageBarDismissActionType] = []
    private var presentAnimation: MessageBarAnimationType?
    private var dismissAnimation: MessageBarAnimationType?
    private var animated: Bool = false
    
    private let notificationCenter: NotificationCenter = .default
    
    public func present(message: MessageBarContentProvider,
                        inContainer container: MessageBarContainerType,
                        animated: Bool = true,
                        animationType: AnimationType = .slide,
                        animationDuration: TimeInterval = 0.3,
                        forDuration duration: TimeInterval = 99999,
                        tapToDismiss: Bool = false) {
        var dismissActions: [MessageBarDismissActionType] = [DelayMessageBarHideAction(delay: duration)]
        if tapToDismiss {
            dismissActions.append(TapGestureMessageBarHideAction(targetView: message.messageBarContentView))
        }
        
        let presentAnimation = MessageBarAnimation(animationType: animationType,
                                                   animationDuration: animationDuration,
                                                   isDismiss: false)
        
        let dismissAnimation = MessageBarAnimation(animationType: animationType,
                                                   animationDuration: animationDuration,
                                                   isDismiss: true)
        
        present(message: message,
                inContainer: container,
                animated: animated,
                presentAnimation: presentAnimation,
                dismissAnimation: dismissAnimation,
                dismissActions: dismissActions)
    }
    
    public init() {  }
    
    private func present(message: MessageBarContentProvider,
                 inContainer container: MessageBarContainerType,
                 animated: Bool,
                 presentAnimation: MessageBarAnimationType,
                 dismissAnimation: MessageBarAnimationType,
                 dismissActions: [MessageBarDismissActionType]) {
        if isBarShowing {
            dismiss(animated: false)
        }
        self.animated = animated
        self.dismissActions = dismissActions
        self.dismissActions.forEach { $0.messageBarDismissTarget = self }
        self.message = message
        self.container = container
        self.presentAnimation = presentAnimation
        self.dismissAnimation = dismissAnimation
        self.isBarShowing = true
        
        postNotificationNameForPresentIfNeeded(.messageBarWillShow)
        
        let animationContext = TransitionContext(container: container,
                                                 isAnimated: animated,
                                                 completionTransitionHandler: { [weak self] completed in
                                                    guard let strongSelf = self, completed else { return }
                                                    strongSelf.postNotificationNameForPresentIfNeeded(.messageBarDidShow)
                                                 })
        presentAnimation.animate(message: message, inContext: animationContext)
    }
    
    public func dismiss(animated: Bool) {
        if let currentContainer = container, let currentMessage = message, animated {
            postNotificationNameForDismissIfNeeded(.messageBarWillHide)
            let animationContext = TransitionContext(container: currentContainer,
                                                     isAnimated: animated,
                                                     completionTransitionHandler: { [weak self] completed in
                                                        if completed {
                                                            self?.postNotificationNameForDismissIfNeeded(.messageBarDidHide)
                                                        }
                                                        self?.isBarShowing = !completed
                                                     })
            dismissAnimation?.animate(message: currentMessage, inContext: animationContext)
        } else {
            postNotificationNameForDismissIfNeeded(.messageBarWillHide)
            isBarShowing = false
            postNotificationNameForDismissIfNeeded(.messageBarDidHide)
        }
    }
    
    public func dismiss() {
        dismiss(animated: animated)
    }
    
    // MARK: - Notification Handling
    private func postNotificationNameForPresentIfNeeded(_ notificationName: Notification.Name) {
        if let presentMessageBarInfo = messageBarInfoForPresent() {
            if notificationName == .messageBarWillShow {
                notificationCenter.post(name: .messageBarWillShow,
                                        object: self,
                                        userInfo: presentMessageBarInfo.rawValue)
            } else if notificationName == .messageBarDidShow, isBarShowing {
                notificationCenter.post(name: .messageBarDidShow,
                                        object: self,
                                        userInfo: presentMessageBarInfo.rawValue)
            }
        }
    }
    
    private func postNotificationNameForDismissIfNeeded(_ notificationName: Notification.Name) {
        if let dismissMessageBarInfo = messageBarInfoForDismiss() {
            if notificationName == .messageBarWillHide {
                notificationCenter.post(name: .messageBarWillHide,
                                        object: self,
                                        userInfo: dismissMessageBarInfo.rawValue)
            } else if notificationName == .messageBarDidHide, !isBarShowing {
                notificationCenter.post(name: .messageBarDidHide,
                                        object: self,
                                        userInfo: dismissMessageBarInfo.rawValue)
            }
        }
    }
    
    private func messageBarInfoForPresent() -> MessageBarInfo? {
        if let currentMessage = message, let currentPresentAnimation = presentAnimation {
            return MessageBarInfo(height: currentMessage.messageBarContentHeight,
                                  animated: animated,
                                  animationDuration: currentPresentAnimation.animationDuration)
        } else {
            return nil
        }
    }
    
    private func messageBarInfoForDismiss() -> MessageBarInfo? {
        if let currentMessage = message, let currentDismissAnimation = dismissAnimation {
            return MessageBarInfo(height: currentMessage.messageBarContentHeight,
                                  animated: animated,
                                  animationDuration: currentDismissAnimation.animationDuration)
        } else {
            return nil
        }
    }
    
    private class TransitionContext: MessageBarAnimationContextType {
        fileprivate var container: MessageBarContainerType
        fileprivate var isAnimated: Bool
        fileprivate var completionTransitionHandler: ((_ didComplete: Bool) -> (Void))?
        
        fileprivate init(container: MessageBarContainerType,
                         isAnimated: Bool,
                         completionTransitionHandler: ((_ didComplete: Bool) -> (Void))?) {
            self.container = container
            self.isAnimated = isAnimated
            self.completionTransitionHandler = completionTransitionHandler
        }
        
        fileprivate func completeAnimation(_ didComplete: Bool) {
            completionTransitionHandler?(didComplete)
        }
    }
}
