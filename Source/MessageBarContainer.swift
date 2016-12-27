//
//  MessageBarContainer.swift
//  MessageBar
//
//  Created by Peter Vu on 12/27/16.
//  Copyright © 2016 Peter Vu. All rights reserved.
//

import UIKit

public protocol MessageBarContainerType: class {
    func insert(messageBarContentView: UIView)
    
    func initialFrame(forMessage: MessageBarContentProvider) -> CGRect
    func finalFrame(forMessage: MessageBarContentProvider) -> CGRect
    
    func willPresent()
    func didDismiss()
}

extension MessageBarContainerType {
    public func willPresent() { }
    public func didDismiss() { }
}
