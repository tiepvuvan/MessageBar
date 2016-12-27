//
//  MessageBarAnimation.swift
//  MessageBar
//
//  Created by Peter Vu on 12/15/16.
//  Copyright © 2016 Peter Vu. All rights reserved.
//

import UIKit

protocol MessageBarAnimationContextType {
    var container: MessageBarContainerType { get }
    var isAnimated: Bool { get }
    
    // Must call after animation complete
    func completeAnimation(_ didComplete: Bool)
}

protocol MessageBarAnimationType {
    var animationDuration: TimeInterval { get }
    func animate(message: MessageBarContentProvider, inContext context: MessageBarAnimationContextType)
}

public enum AnimationType {
    case slide, fade
}

class MessageBarAnimation: MessageBarAnimationType {    
    var isDismiss: Bool
    var animationType: AnimationType
    var animationDuration: TimeInterval
    
    init(animationType: AnimationType,
         animationDuration: TimeInterval = 0.3,
         isDismiss: Bool) {
        self.isDismiss = isDismiss
        self.animationType = animationType
        self.animationDuration = animationDuration
    }
    
    func animate(message: MessageBarContentProvider,
                        inContext context: MessageBarAnimationContextType) {
        let messageBar = message.messageBarContentView
        messageBar.autoresizingMask = .flexibleWidth
        context.container.insert(messageBarContentView: messageBar)
        
        let initialFrame: CGRect
        let finalFrame: CGRect
        
        let initialAlpha: CGFloat
        let finalAlpha: CGFloat
        
        
        switch animationType {
        case .fade:
            initialFrame = context.container.finalFrame(forMessage: message)
            finalFrame = initialFrame
            
            initialAlpha = isDismiss ? 1 : 0
            finalAlpha = isDismiss ? 0 : 1
            break
        case .slide:
            initialFrame = isDismiss ? context.container.finalFrame(forMessage: message) : context.container.initialFrame(forMessage: message)
            finalFrame = isDismiss ? context.container.initialFrame(forMessage: message) : context.container.finalFrame(forMessage: message)
            
            initialAlpha = 1
            finalAlpha = 1
        }
        
        messageBar.frame = initialFrame
        messageBar.alpha = initialAlpha
        
        if context.isAnimated {
            UIView.animate(withDuration: animationDuration, animations: {
                messageBar.frame = finalFrame
                messageBar.alpha = finalAlpha
            }, completion: {
                context.completeAnimation($0)
            })
        } else {
            messageBar.frame = finalFrame
            messageBar.alpha = finalAlpha
            context.completeAnimation(true)
        }
    }
}
