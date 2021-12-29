//
//  ViewController.swift
//  AI_ForTheCamera
//
//  Created by Дмитрий Рузайкин on 29.12.2021.
//

import UIKit
import AVKit //Аудио-визуальная библиотек для работы камеры

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        
        //Настройка камеры
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
    }
}

