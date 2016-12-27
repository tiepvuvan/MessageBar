//
//  MessageBar+UIViewController.swift
//  MessageBar
//
//  Created by Peter Vu on 12/27/16.
//  Copyright © 2016 Peter Vu. All rights reserved.
//

import UIKit

extension MessageBarManager {
    public func present(message: MessageBarContentProvider,
                        inViewController controller: UIViewController,
                        position: MessageBarPosition = .top,
                        animated: Bool = true,
                        animationType: AnimationType = .slide,
                        animationDuration: TimeInterval = 0.3,
                        forDuration duration: TimeInterval = .forever,
                        tapToDismiss: Bool = false) {
        let viewControllerContainer = MessageBarViewControllerContainer(containerViewController: controller,
                                                                        barPosition: position)
        present(message: message,
                inContainer: viewControllerContainer,
                animated: animated,
                animationType: animationType,
                animationDuration: animationDuration,
                forDuration: duration,
                tapToDismiss: tapToDismiss)
    }
    
    public func present(message: MessageBarContentProvider,
                        inNavigationController navigationController: UINavigationController,
                        position: MessageBarPosition = .top,
                        animated: Bool = true,
                        animationType: AnimationType = .slide,
                        animationDuration: TimeInterval = 0.3,
                        forDuration duration: TimeInterval = .forever,
                        tapToDismiss: Bool = false) {
        let navigationControllerContainer = MessageBarNavigationControllerContainer(navigationControllerContainer: navigationController,
                                                                                    barPosition: position)
        present(message: message,
                inContainer: navigationControllerContainer,
                animated: animated,
                animationType: animationType,
                animationDuration: animationDuration,
                forDuration: duration,
                tapToDismiss: tapToDismiss)
    }
    
    public func present(message: MessageBarContentProvider,
                        inTabBarController tabBarController: UITabBarController,
                        position: MessageBarPosition = .bottom,
                        animated: Bool = true,
                        animationType: AnimationType = .slide,
                        animationDuration: TimeInterval = 0.3,
                        forDuration duration: TimeInterval = .forever,
                        tapToDismiss: Bool = false) {
        let tabBarControllerContainer = MessageBarTabBarControllerContainer(tabBarControllerContainer: tabBarController,
                                                                            barPosition: position)
        present(message: message,
                inContainer: tabBarControllerContainer,
                animated: animated,
                animationType: animationType,
                animationDuration: animationDuration,
                forDuration: duration,
                tapToDismiss: tapToDismiss)
    }
}

class MessageBarViewContainer: MessageBarContainerType {
    weak var containerView: UIView?
    var barPosition: MessageBarPosition
    
    init(containerView: UIView, barPosition: MessageBarPosition) {
        self.containerView = containerView
        self.barPosition = barPosition
    }
    
    func insert(messageBarContentView: UIView) {
        containerView?.addSubview(messageBarContentView)
    }
    
    func initialFrame(forMessage message: MessageBarContentProvider) -> CGRect {
        guard let containerView = self.containerView else { return .zero }
        switch barPosition {
        case .top:
            return CGRect(x: 0,
                          y: -message.messageBarContentHeight,
                          width: containerView.bounds.width,
                          height: message.messageBarContentHeight)
        case .bottom:
            return CGRect(x: 0,
                          y: containerView.bounds.height + message.messageBarContentHeight,
                          width: containerView.bounds.width,
                          height: message.messageBarContentHeight)
        }
    }
    
    func finalFrame(forMessage message: MessageBarContentProvider) -> CGRect {
        guard let containerView = self.containerView else { return .zero }
        switch barPosition {
        case .top:
            return CGRect(x: 0,
                          y: 0,
                          width: containerView.bounds.width,
                          height: message.messageBarContentHeight)
        case .bottom:
            return CGRect(x: 0,
                          y: containerView.bounds.height - message.messageBarContentHeight,
                          width: containerView.bounds.width,
                          height: message.messageBarContentHeight)
        }
    }
}


class MessageBarNavigationControllerContainer: MessageBarViewControllerContainer {
    private weak var navigationControllerContainer: UINavigationController?
    
    init(navigationControllerContainer: UINavigationController, barPosition: MessageBarPosition) {
        self.navigationControllerContainer = navigationControllerContainer
        super.init(containerViewController: navigationControllerContainer, barPosition: barPosition)
    }
    
    override func insert(messageBarContentView: UIView) {
        guard let navigationControllerContainer = self.navigationControllerContainer else { return }
        navigationControllerContainer.view.insertSubview(messageBarContentView, belowSubview: navigationControllerContainer.navigationBar)
    }
    
    override func initialFrame(forMessage message: MessageBarContentProvider) -> CGRect {
        switch barPosition {
        case .bottom:
            return super.initialFrame(forMessage: message)
        case .top:
            guard let navigationControllerContainer = self.navigationControllerContainer else {
                return super.initialFrame(forMessage: message)
            }
            return CGRect(x: 0,
                          y: navigationControllerContainer.navigationBar.frame.minY - message.messageBarContentHeight,
                          width: navigationControllerContainer.view.bounds.width,
                          height: message.messageBarContentHeight)
        }
    }
    
    override func finalFrame(forMessage message: MessageBarContentProvider) -> CGRect {
        switch barPosition {
        case .bottom:
            return super.finalFrame(forMessage: message)
        case .top:
            guard let navigationControllerContainer = self.navigationControllerContainer else {
                return super.finalFrame(forMessage: message)
            }
            return CGRect(x: 0,
                          y: navigationControllerContainer.navigationBar.frame.maxY,
                          width: navigationControllerContainer.view.bounds.width,
                          height: message.messageBarContentHeight)
        }
    }
}

class MessageBarTabBarControllerContainer: MessageBarViewControllerContainer {
    private weak var tabBarControllerContainer: UITabBarController?
    
    init(tabBarControllerContainer: UITabBarController, barPosition: MessageBarPosition) {
        self.tabBarControllerContainer = tabBarControllerContainer
        super.init(containerViewController: tabBarControllerContainer, barPosition: barPosition)
    }
    
    override func insert(messageBarContentView: UIView) {
        guard let tabbarControllerContainer = self.tabBarControllerContainer else { return }
        tabbarControllerContainer.view.insertSubview(messageBarContentView,
                                                     belowSubview: tabbarControllerContainer.tabBar)
    }
    
    override func initialFrame(forMessage message: MessageBarContentProvider) -> CGRect {
        switch barPosition {
        case .top:
            return super.initialFrame(forMessage: message)
        case .bottom:
            guard let tabbarControllerContainer = self.tabBarControllerContainer else {
                return super.initialFrame(forMessage: message)
            }
            return CGRect(x: 0,
                          y: tabbarControllerContainer.tabBar.frame.minY + message.messageBarContentHeight,
                          width: tabbarControllerContainer.view.bounds.width,
                          height: message.messageBarContentHeight)
        }
    }
    
    override func finalFrame(forMessage message: MessageBarContentProvider) -> CGRect {
        switch barPosition {
        case .top:
            return super.finalFrame(forMessage: message)
        case .bottom:
            guard let tabbarControllerContainer = self.tabBarControllerContainer else {
                return super.finalFrame(forMessage: message)
            }
            return CGRect(x: 0,
                          y: tabbarControllerContainer.tabBar.frame.minY - message.messageBarContentHeight,
                          width: tabbarControllerContainer.view.bounds.width,
                          height: message.messageBarContentHeight)
        }
    }
}
