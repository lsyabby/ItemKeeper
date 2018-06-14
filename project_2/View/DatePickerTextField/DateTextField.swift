//
//  DateTextField.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/10.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class DateTextField: UITextField {

    override func caretRect(for position: UITextPosition) -> CGRect {

        return CGRect.zero
    }

    override func selectionRects(for range: UITextRange) -> [Any] {

        return []
    }

    override func canPerformAction(_ action: Selector, withSender sender: Any?) -> Bool {

        if action == #selector(copy(_:)) || action == #selector(selectAll(_:)) || action == #selector(paste(_:)) {

            return false
        }

        return super.canPerformAction(action, withSender: sender)
    }
}
