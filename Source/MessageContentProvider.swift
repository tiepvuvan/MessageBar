//
//  MessageContent.swift
//  MessageBar
//
//  Created by Peter Vu on 12/27/16.
//  Copyright © 2016 Peter Vu. All rights reserved.
//

import UIKit

public protocol MessageBarContentProvider {
    var messageBarContentView: UIView { get }
    var messageBarContentHeight: CGFloat { get }
}

extension MessageBarContentProvider where Self: UIView {
    public var messageBarContentView: UIView { return self }
}
