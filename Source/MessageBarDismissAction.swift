//
//  MessageBarDismissAction.swift
//  MessageBar
//
//  Created by Peter Vu on 12/15/16.
//  Copyright © 2016 Peter Vu. All rights reserved.
//

import UIKit

protocol MessageBarDismissTargetType: class {
    func dismiss()
}

protocol MessageBarDismissActionType: class {
    var messageBarDismissTarget: MessageBarDismissTargetType? { get set }
}

class DelayMessageBarHideAction: MessageBarDismissActionType {
    weak var messageBarDismissTarget: MessageBarDismissTargetType?
    var dismissTimer: Timer!
    init(delay: TimeInterval) {
        dismissTimer = Timer.scheduledTimer(timeInterval: delay,
                                            target: self,
                                            selector: #selector(handleDismissTimer),
                                            userInfo: nil,
                                            repeats: false)
    }
    
    @objc func handleDismissTimer() {
        messageBarDismissTarget?.dismiss()
    }
}

class TapGestureMessageBarHideAction: MessageBarDismissActionType {
    weak var messageBarDismissTarget: MessageBarDismissTargetType?
    let tapGesture: UITapGestureRecognizer
    
    init(targetView: UIView) {
        tapGesture = UITapGestureRecognizer()
        tapGesture.addTarget(self, action: #selector(handleTap(sender:)))
        targetView.addGestureRecognizer(tapGesture)
    }
    
    @objc func handleTap(sender: UITapGestureRecognizer) {
        if sender.state == .ended {
            messageBarDismissTarget?.dismiss()
        }
    }
}
