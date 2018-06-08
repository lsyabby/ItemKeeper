//
//  ABDropDownMenu.swift
//  project_2
//
//  Created by 李思瑩 on 2018/6/7.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import ZHDropDownMenu

//Custom Protocol

protocol ABDropDownmenuDelegate: class {

    func dropDownMenu(_ menu: ABDropDownMenu, didEdit text: String)

    func dropDownMenu(_ menu: ABDropDownMenu, didSelect index: Int)
}

class ABDropDownMenu: UIView {

    private let dropDownmenu = ZHDropDownMenu()

    weak var delegate: ABDropDownmenuDelegate?

    var buttonImage: UIImage? {
        didSet {
            dropDownmenu.buttonImage = buttonImage
        }
    }

    override var frame: CGRect {
        didSet {
            dropDownmenu.frame = bounds
        }
    }

    override init(frame: CGRect) {
        super.init(frame: frame)

        setup()
    }

    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)

        setup()
    }

    private func setup() {

        addSubview(dropDownmenu)

        dropDownmenu.frame = self.bounds

//        self.frame = self.superview!.bounds

        dropDownmenu.translatesAutoresizingMaskIntoConstraints = false

        dropDownmenu.leadingAnchor.constraint(equalTo: leadingAnchor).isActive = true

        dropDownmenu.topAnchor.constraint(equalTo: topAnchor).isActive = true

        dropDownmenu.trailingAnchor.constraint(equalTo: trailingAnchor).isActive = true

        dropDownmenu.bottomAnchor.constraint(equalTo: bottomAnchor).isActive = true

        dropDownmenu.delegate = self
    }

    func option(_ options: [String]) {

        dropDownmenu.options = options

        dropDownmenu.contentTextField.text = options[0]
    }

    func firstContextText(_ text: String) -> String {

        dropDownmenu.contentTextField.text = text

        return text
    }

    func editable(_ flag: Bool) {

        dropDownmenu.editable = flag
    }

}

extension ABDropDownMenu: ZHDropDownMenuDelegate {

    func dropDownMenu(_ menu: ZHDropDownMenu, didEdit text: String) {
        self.delegate?.dropDownMenu(self, didEdit: text)
    }

    func dropDownMenu(_ menu: ZHDropDownMenu, didSelect index: Int) {
        self.delegate?.dropDownMenu(self, didSelect: index)
    }
}
