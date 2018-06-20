//
//  AddImageViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/14.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit

protocol AddImageDelegate: class {
    func getAddImage(image: UIImage?)
}

class AddImageViewController: UIViewController, UINavigationControllerDelegate {

    @IBOutlet weak var addImageView: UIImageView!
    weak var delegate: AddImageDelegate?

    override func viewDidLoad() {

        super.viewDidLoad()

        setupImageView()
    }

    func setupImageView() {

        setupImageLayer()

        setupImageGesture()
    }

    private func setupImageLayer() {

        addImageView.layer.cornerRadius = 2

        addImageView.layer.borderWidth = 1

        addImageView.layer.borderColor = UIColor.lightGray.cgColor
    }

    private func setupImageGesture() {

        addImageView.isUserInteractionEnabled = true

        let touch = UITapGestureRecognizer(target: self, action: #selector(bottomAlert))

        addImageView.addGestureRecognizer(touch)
    }

    @objc func bottomAlert() {

        let alertController = UIAlertController(title: nil, message: nil, preferredStyle: .actionSheet)

        let cancelAction = UIAlertAction(title: "取消", style: .cancel, handler: nil)

        let photoAction = UIAlertAction(title: "照片", style: .default) { _ in

            let picker = UIImagePickerController()

            picker.delegate = self

            picker.sourceType = .photoLibrary

            picker.allowsEditing = true

            self.present(picker, animated: true, completion: nil)
        }

        let cameraAction = UIAlertAction(title: "相機", style: .default) { _ in

            let picker = UIImagePickerController()

            picker.delegate = self

            picker.sourceType = .camera

            picker.allowsEditing = true

            self.present(picker, animated: true, completion: nil)
        }

        alertController.addAction(cancelAction)

        alertController.addAction(photoAction)

        alertController.addAction(cameraAction)

        self.present(alertController, animated: true, completion: nil)
    }
}

extension AddImageViewController: UIImagePickerControllerDelegate {

    func imagePickerController(_ picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [String: Any]) {

        let editImage = info[UIImagePickerControllerEditedImage] as? UIImage

        let originImage = info[UIImagePickerControllerOriginalImage] as? UIImage

        if picker.sourceType == .camera {

            UIImageWriteToSavedPhotosAlbum(originImage!, self, #selector(image(_:didFinishSavingWithError:contextInfo:)), nil)
        }

        addImageView.image = editImage

        self.delegate?.getAddImage(image: editImage)

        dismiss(animated: true, completion: nil)
    }

    @objc func image(_ image: UIImage, didFinishSavingWithError error: Error?, contextInfo: UnsafeRawPointer) {

        if let error = error {

            let imageAC = UIAlertController(title: "儲存錯誤", message: error.localizedDescription, preferredStyle: .alert)

            imageAC.addAction(UIAlertAction(title: "確定", style: .default))

            present(imageAC, animated: true)

        } else {

            let imageAC = UIAlertController(title: "儲存照片", message: "已將相片存到相簿", preferredStyle: .alert)

            imageAC.addAction(UIAlertAction(title: "確定", style: .default))

            present(imageAC, animated: true)
        }
    }
}
