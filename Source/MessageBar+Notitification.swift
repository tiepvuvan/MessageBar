//
//  MessageBar+Notitification.swift
//  MessageBar
//
//  Created by Peter Vu on 12/27/16.
//  Copyright © 2016 Peter Vu. All rights reserved.
//

import UIKit

public extension Notification.Name {
    public static let messageBarWillShow = Notification.Name("messageBarWillShow")
    public static let messageBarDidShow = Notification.Name("messageBarDidShow")
    
    public static let messageBarWillHide = Notification.Name("messageBarWillHide")
    public static let messageBarDidHide = Notification.Name("messageBarDidHide")
}

public struct MessageBarInfo: RawRepresentable {
    public typealias RawValue = [String: Any]
    
    public var rawValue: [String: Any] {
        return ["height": height,
                "animated": animated,
                "animationDuration": animationDuration]
    }
    
    public let height: CGFloat
    public let animated: Bool
    public let animationDuration: TimeInterval
    
    public init(height: CGFloat,
                animated: Bool,
                animationDuration: TimeInterval) {
        self.height = height
        self.animated = animated
        self.animationDuration = animationDuration
    }
    
    public init?(rawValue: RawValue) {
        if let height = rawValue["height"] as? CGFloat,
            let animated = rawValue["animated"] as? Bool,
            let animationDuration = rawValue["animationDuration"] as? TimeInterval {
            self.height = height
            self.animated = animated
            self.animationDuration = animationDuration
        } else {
            return nil
        }
    }
    
    public init?(fromUserInfo userInfo: [AnyHashable: Any]?) {
        if let rawValue = userInfo as? RawValue {
            self.init(rawValue: rawValue)
        } else {
            return nil
        }
    }
}
