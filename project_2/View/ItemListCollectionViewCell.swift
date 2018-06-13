//
//  ItemListCollectionViewCell.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/1.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

class ItemListCollectionViewCell: UICollectionViewCell, UIGestureRecognizerDelegate {

    @IBOutlet weak var itemImageView: UIImageView!
    @IBOutlet weak var itemNameLabel: UILabel!
    @IBOutlet weak var itemIdLabel: UILabel!
    @IBOutlet weak var itemEndDateLabel: UILabel!
    @IBOutlet weak var itemCategoryLabel: UILabel!
    @IBOutlet weak var itemRemainDayLabel: UILabel!
    var pan: UIPanGestureRecognizer!
    var deleteLabel1: UILabel!
    var deleteLabel2: UILabel!

    override func awakeFromNib() {
        super.awakeFromNib()
        self.contentView.backgroundColor = UIColor(displayP3Red: 235/255, green: 235/255, blue: 235/255, alpha: 1)
        self.backgroundColor = UIColor.orange

        deleteLabel1 = UILabel()
        deleteLabel1.text = "刪除"
        deleteLabel1.textColor = UIColor.white
        self.insertSubview(deleteLabel1, belowSubview: self.contentView)

        deleteLabel2 = UILabel()
        deleteLabel2.text = "delete"
        deleteLabel2.textColor = UIColor.white
        self.insertSubview(deleteLabel2, belowSubview: self.contentView)

        pan = UIPanGestureRecognizer(target: self, action: #selector(onPan(_:)))
        pan.delegate = self
        self.addGestureRecognizer(pan)
    }

    override func prepareForReuse() {
        self.contentView.frame = self.bounds
    }

    @IBAction func givePresentAction(_ sender: UIButton) {
    }

    override func layoutSubviews() {
        super.layoutSubviews()

        if (pan.state == UIGestureRecognizerState.changed) {
            let ppp: CGPoint = pan.translation(in: self)
            let width = self.contentView.frame.width
            let height = self.contentView.frame.height
            self.contentView.frame = CGRect(x: ppp.x, y: 0, width: width, height: height)
            self.deleteLabel1.frame = CGRect(x: ppp.x - deleteLabel1.frame.size.width-10, y: 0, width: 100, height: height)
            self.deleteLabel2.frame = CGRect(x: ppp.x + width + deleteLabel2.frame.size.width, y: 0, width: 100, height: height)
        }
    }

    @objc func onPan(_ pan: UIPanGestureRecognizer) {
        if pan.state == UIGestureRecognizerState.began {

        } else if pan.state == UIGestureRecognizerState.changed {
            self.setNeedsLayout()
        } else {
            if abs(pan.velocity(in: self).x) > 500 {
                guard let collectionView: UICollectionView = self.superview as? UICollectionView else { return }
                let indexPath: IndexPath = collectionView.indexPathForItem(at: self.center)!
                collectionView.delegate?.collectionView!(collectionView, performAction: #selector(onPan(_:)), forItemAt: indexPath, withSender: nil)
            } else {
                UIView.animate(withDuration: 0.2) {
                    self.setNeedsLayout()
                    self.layoutIfNeeded()
                }
            }
        }
    }

    func gestureRecognizer(_ gestureRecognizer: UIGestureRecognizer, shouldRecognizeSimultaneouslyWith otherGestureRecognizer: UIGestureRecognizer) -> Bool {
        return true
    }

    override func gestureRecognizerShouldBegin(_ gestureRecognizer: UIGestureRecognizer) -> Bool {
        return abs((pan.velocity(in: pan.view)).x) > abs((pan.velocity(in: pan.view)).y)
    }

}
