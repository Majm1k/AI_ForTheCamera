//
//  ViewController.swift
//  AI_ForTheCamera
//
//  Created by Дмитрий Рузайкин on 29.12.2021.
//

import UIKit
import AVKit //Аудио-визуальная библиотек для работы камеры
import Vision //Api для опознания объекта

class ViewController: UIViewController, AVCaptureVideoDataOutputSampleBufferDelegate {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        //MARK: - CAMERA SETUP
        //Настройка камеры
        let captureSession = AVCaptureSession()
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {return}
        guard let input = try? AVCaptureDeviceInput(device: captureDevice) else {return}
        
        captureSession.addInput(input)
        captureSession.startRunning()
        
        let previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        view.layer.addSublayer(previewLayer)
        previewLayer.frame = view.frame
        
        //Вывод данных с камеры (покадрово)
        let dataOutput = AVCaptureVideoDataOutput()
        //Отслеживание
        dataOutput.setSampleBufferDelegate(self, queue: DispatchQueue(label: "VideoQueue"))
        captureSession.addOutput(dataOutput)
    }
    
    //Функция делегата (Вызывается при кажом кадре схемки)
    func captureOutput(_ output: AVCaptureOutput, didOutput sampleBuffer: CMSampleBuffer, from connection: AVCaptureConnection) {
        //print("Кадр успешно замечен:", Date())
        
        //Буфер пикселей
        guard let pixelBuffer: CVPixelBuffer = CMSampleBufferGetImageBuffer(sampleBuffer) else {return}
        
        guard let model = try? VNCoreMLModel(for: Resnet50().model) else {return}
        
        //Запрос
        let request = VNCoreMLRequest(model: model) { finishReq, err in
            guard let results = finishReq.results as? [VNClassificationObservation] else {return}
            guard let firstObservation = results.first else {return}
            print(firstObservation.identifier, firstObservation.confidence)
        }
        
        //Обработчик запроса, с помощью него и определяем оъект ([:] - пустой словарь)
        try? VNImageRequestHandler(cvPixelBuffer: pixelBuffer, options: [:]).perform([request])
    }
}

