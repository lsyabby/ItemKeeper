//
//  TrashCollectionViewCell.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/22.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import SDWebImage

protocol TrashCollectionViewCellDelegate: class {
    func delete(cell: TrashCollectionViewCell)
}

class TrashCollectionViewCell: UICollectionViewCell {

    @IBOutlet weak var trashImageView: UIImageView!
    @IBOutlet weak var deleteBtnVisualEffectView: UIVisualEffectView!
    weak var delegate: TrashCollectionViewCellDelegate?
    var isEditing: Bool = false {
        didSet {
            deleteBtnVisualEffectView.isHidden = !isEditing
        }
    }

    override func awakeFromNib() {
        super.awakeFromNib()

        setupBtnEffectView()

    }

    @IBAction func deleteAction(_ sender: Any) {
        self.delegate?.delete(cell: self)
    }

    private func setupBtnEffectView() {

        deleteBtnVisualEffectView.layer.cornerRadius = deleteBtnVisualEffectView.layer.bounds.width / 2

        deleteBtnVisualEffectView.layer.masksToBounds = true

        deleteBtnVisualEffectView.isHidden = !isEditing
    }

    func setupCell(item: ItemList) {

        deleteBtnVisualEffectView.isHidden = !isEditing

        trashImageView.sd_setImage(with: URL(string: item.imageURL))

    }

}
