//
//  CameraViewController.swift
//  Jumping Dino iPad
//
//  Created by Ethan Chew on 10/1/23.
//

import UIKit
import SwiftUI
import AVFoundation
import Vision

class CameraViewController: UIViewController {
    var permission = false
    
    let captureSession = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    private let sessionQueue = DispatchQueue(label: "sessionQueue")
    var screenRect: CGRect! = nil
    
    func checkPermission() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            permission = true
        case .notDetermined:
            requestPermission()
        default:
            permission = false
        }
        
    }
    
    func requestPermission() {
        sessionQueue.suspend()
        AVCaptureDevice.requestAccess(for: .video) { [unowned self] permissionGranted in
            permission = permissionGranted
        }
    }
    
    func setupCaptureSession() {
        guard let videoDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) else { return }
        
        if videoDevice.activeFormat.isCenterStageSupported {
            AVCaptureDevice.isCenterStageEnabled = true
        }
        
        guard let videoDeviceInput = try? AVCaptureDeviceInput(device: videoDevice) else { return }
        
        if captureSession.canAddInput(videoDeviceInput) {
            captureSession.addInput(videoDeviceInput)
        }
            
        
        screenRect = UIScreen.main.bounds
        previewLayer = AVCaptureVideoPreviewLayer(session: captureSession)
        previewLayer.frame = CGRect(x: 0, y: 0, width: screenRect.size.width, height: screenRect.size.height)
        previewLayer.videoGravity = AVLayerVideoGravity.resizeAspectFill
        
        // Check for orientation
        switch UIDevice.current.orientation {
        case UIDeviceOrientation.landscapeRight:
            previewLayer.connection?.videoOrientation = .landscapeRight
        case UIDeviceOrientation.landscapeLeft:
            previewLayer.connection?.videoOrientation = .landscapeLeft
        default:
            previewLayer.connection?.videoOrientation = .landscapeRight
        }
        
        DispatchQueue.main.async { [unowned self] in
            self.view.layer.addSublayer(self.previewLayer)
        }
    }
    
    override func viewDidLoad() {
        checkPermission()
        
        sessionQueue.async { [unowned self] in
            guard self.permission else { return }
            self.setupCaptureSession()
            self.captureSession.startRunning()
        }
    }
}

struct CameraView: UIViewControllerRepresentable {
    func makeUIViewController(context: Context) -> UIViewController {
        return CameraViewController()
    }
    
    func updateUIViewController(_ uiViewController: UIViewController, context: Context) {
        
    }
}
