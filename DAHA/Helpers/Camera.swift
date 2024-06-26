//
//  Camera.swift
//  DAHA
//
//  Created by Adrian Adegbesan on 2/4/23.
//

import Foundation
import AVFoundation
import UIKit

class CameraService {
    
    var session: AVCaptureSession?
    var delegate: AVCapturePhotoCaptureDelegate?
    
    let output = AVCapturePhotoOutput()
    let previewLayer = AVCaptureVideoPreviewLayer()
    
    var flashMode: AVCaptureDevice.FlashMode = .off
    
    func start(delegate: AVCapturePhotoCaptureDelegate, completion: @escaping (Error?) -> ()) {
        self.delegate = delegate
        checkPermissions(completion: completion)
        
    }
    
    private func checkPermissions(completion: @escaping (Error?) -> ()){
        switch AVCaptureDevice.authorizationStatus(for: .video){
            
        case .notDetermined:
            AVCaptureDevice.requestAccess(for: .video) { [weak self] granted in
                guard granted else { return }
                DispatchQueue.main.async {
                    self?.setupCamera(completion: completion)
                }
            }
        case .restricted:
            break
        case .denied:
            break
        case .authorized:
            DispatchQueue.main.async {
                self.setupCamera(completion: completion)
            }
        @unknown default:
            break
        }
    }
    
    private func setupCamera(completion: @escaping (Error?) -> ()) {
        let session = AVCaptureSession()
        if let device = AVCaptureDevice.default(for: .video){
            do {
                let input = try AVCaptureDeviceInput(device: device)
                if session.canAddInput(input){
                    session.addInput(input)
                }
                
                if session.canAddOutput(output) {
                    session.addOutput(output)
                }
                
                previewLayer.videoGravity = .resizeAspectFill
                previewLayer.session = session
                
                Task {
                    session.startRunning()
                    self.session = session
                }
            } catch {
                completion(error)
            }

            
        }
    }
    
    func capturePhoto(with settings: AVCapturePhotoSettings = AVCapturePhotoSettings()){
        
        settings.flashMode = flashMode
        output.capturePhoto(with: settings, delegate: delegate!)
    }
    
    func toggleFlashMode() {
        if flashMode == .off {
            flashMode = .on
        } else {
            flashMode = .off
        }
    }
    
    
    
    
    
    

}
