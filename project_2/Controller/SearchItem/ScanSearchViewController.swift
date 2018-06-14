//
//  ScanSearchViewController.swift
//  project_2
//
//  Created by 李思瑩 on 2018/5/22.
//  Copyright © 2018年 李思瑩. All rights reserved.
//

import UIKit
import AVFoundation

class ScanSearchViewController: UIViewController {

    @IBOutlet weak var greenSquareView: UIView!
    var captureSession: AVCaptureSession!
    var videoPreviewLayer: AVCaptureVideoPreviewLayer!

    override func viewDidLoad() {

        super.viewDidLoad()

        setupSquareView()

        captureDevice()

        setupVideoPreviewLayer()

        view.layer.addSublayer(videoPreviewLayer)

        captureOutput()

        self.view.bringSubview(toFront: greenSquareView)
    }

    func setupSquareView() {

        greenSquareView.layer.borderWidth = 3

        greenSquareView.layer.borderColor = UIColor.green.cgColor
    }

    func captureDevice() {

        let captureDevice = AVCaptureDevice.default(for: AVMediaType.video)

        do {

            let input = try AVCaptureDeviceInput(device: captureDevice!)

            captureSession = AVCaptureSession()

            captureSession?.addInput(input)

        } catch let error as NSError {

            print(error)
        }
    }

    func setupVideoPreviewLayer() {

        videoPreviewLayer = AVCaptureVideoPreviewLayer(session: captureSession!)

        videoPreviewLayer.videoGravity = .resizeAspectFill

        videoPreviewLayer.frame = view.layer.bounds
    }

    func captureOutput() {

        let captureMetadataOutput = AVCaptureMetadataOutput()

        captureSession?.addOutput(captureMetadataOutput)

        captureMetadataOutput.metadataObjectTypes = captureMetadataOutput.availableMetadataObjectTypes

        print(captureMetadataOutput.availableMetadataObjectTypes)

        captureMetadataOutput.setMetadataObjectsDelegate(self, queue: DispatchQueue.main)

        captureSession?.startRunning()
    }
}

extension ScanSearchViewController: AVCaptureMetadataOutputObjectsDelegate {

    func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {

        AudioServicesPlaySystemSound(SystemSoundID(kSystemSoundID_Vibrate))

        captureSession.stopRunning()

        guard let metadataObject = metadataObjects.first else { return }

        guard let readableObject = metadataObject as? AVMetadataMachineReadableCodeObject else { return }

        guard let stringValue = readableObject.stringValue else { return }

        let notificationName = Notification.Name("ScanResult")

        NotificationCenter.default.post(name: notificationName, object: nil, userInfo: ["PASS": stringValue])

        self.navigationController?.popViewController(animated: true)
    }
}
