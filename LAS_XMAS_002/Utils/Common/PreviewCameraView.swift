//
//  PreviewCameraView.swift
//  LAS_XMAS_002
//
//  Created by Khanh Vu on 10/11/2023.
//

import Foundation
import AVFoundation
import UIKit
import SnapKit

class PreviewCameraView: UIView {
    
    private enum SessionSetupResult {
        case success
        case notAuthorized
        case configurationFailed
    }
    
    lazy var vPreviewVideo: UIView = {
        let v = UIView()
        v.layer.cornerRadius = 20
        v.layer.masksToBounds = true
        v.backgroundColor = .black
        return v
    }()
    
    //MARK: - Property
    var session = AVCaptureSession()
    var previewLayer = AVCaptureVideoPreviewLayer()
    var videoOutput: AVCaptureVideoDataOutput!
    var videoDeviceInput: AVCaptureDeviceInput!
    private let videoDeviceDiscoverySession = AVCaptureDevice.DiscoverySession(deviceTypes: [.builtInWideAngleCamera, .builtInDualCamera], mediaType: .video, position: .unspecified)
    private let sessionQueue = DispatchQueue(label: "session queue")
    private var setupResult: SessionSetupResult = .success
    
    // Closure
    var onShowAlertSettingCamera: (() -> Void)?
    
   
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        setupUI()
    }
    
    required init?(coder: NSCoder) {
        super.init(coder: coder)
        setupUI()
    }
    
    private func setupUI() {
        self.previewLayer.session = self.session
        self.configView()
        
    }
    
    func checkPermissions() {
        switch AVCaptureDevice.authorizationStatus(for: .video) {
        case .authorized:
            // The user has previously granted access to the camera.
            break
        case .notDetermined:
            sessionQueue.suspend()
            AVCaptureDevice.requestAccess(for: .video, completionHandler: { granted in
                if !granted {
                    self.setupResult = .notAuthorized
                }
                self.sessionQueue.resume()
            })
        default:
            // The user has previously denied access.
            setupResult = .notAuthorized
        }
    }
    
    private func configView() {
        
        self.addSubview(vPreviewVideo)
        
        self.vPreviewVideo.snp.makeConstraints { make in
            make.top.leading.trailing.bottom.equalToSuperview()
        }
    }
    
    private func configureSession() {
        if setupResult != .success {
            return
        }
        self.session.beginConfiguration()
        self.session.sessionPreset = .low
        // Add input.
        self.setUpCamera()

        //Add ouput
        self.setupVideoOutput()
        
        self.session.commitConfiguration()
        
        self.session.startRunning()
    }
    
    private func setUpCamera() {
        do {
            var defaultVideoDevice: AVCaptureDevice?
            // Choose the back dual camera if available, otherwise default to a wide angle camera.
            if let backCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .front) {
                // If the back dual camera is not available, default to the back wide angle camera.
                defaultVideoDevice = backCameraDevice
            } else if let frontCameraDevice = AVCaptureDevice.default(.builtInWideAngleCamera, for: .video, position: .back) {
                defaultVideoDevice = frontCameraDevice
            }
            guard let defaultVideoDevice = defaultVideoDevice else {
                DispatchQueue.main.async {
                    self.makeToast("Can't not detect camera from this device!")
                }
                return
            }

            let videoDeviceInput = try AVCaptureDeviceInput(device: defaultVideoDevice)
            if self.session.canAddInput(videoDeviceInput) {
                self.session.addInput(videoDeviceInput)
                self.videoDeviceInput = videoDeviceInput
            } else {
                print("Could not add video device input to the session")
                setupResult = .configurationFailed
                self.session.commitConfiguration()
                return
            }
        } catch {
            print("Could not create video device input: \(error)")
            self.setupResult = .configurationFailed
            self.session.commitConfiguration()
            return
        }
    }
    
    //MARK: Set up output
    private func setUpPreviewLayer() {
        self.previewLayer.videoGravity = .resizeAspectFill
        self.vPreviewVideo.layer.insertSublayer(self.previewLayer, above: self.vPreviewVideo.layer)
        self.previewLayer.frame = self.vPreviewVideo.bounds
    }
    
    private func setupVideoOutput() {
        self.videoOutput = AVCaptureVideoDataOutput()
        self.videoOutput.alwaysDiscardsLateVideoFrames = true
        let videoQueue = DispatchQueue(label: "videoQueue", qos: .userInteractive)
//        self.videoOutput.setSampleBufferDelegate(self, queue: videoQueue)
        if self.session.canAddOutput(self.videoOutput) {
            self.session.addOutput(self.videoOutput)
        } else {
            print("could not add video output")
            self.setupResult = .configurationFailed
            self.session.commitConfiguration()
        }
        self.videoOutput.connections.first?.videoOrientation = .portrait
    }
}

extension PreviewCameraView {
    func startSession() {
        
        checkPermissions()
        sessionQueue.async {
            self.configureSession()
        }
        sessionQueue.async {
            switch self.setupResult {
            case .success:
                self.session.startRunning()
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
                    self.setUpPreviewLayer()
                }
                
            case .notAuthorized:
                if let onShowAlertSettingCamera = self.onShowAlertSettingCamera {
                    onShowAlertSettingCamera()
                }
            case .configurationFailed:
                break
//                Toast.show("Config input camera failed!")
            }
        }
    }
    
    func stopSession() {
        sessionQueue.async {
            if self.setupResult == .success {
                self.session.stopRunning()
            }
        }
    }
    
    func switchCamera() {
        sessionQueue.async {
            let currentVideoDevice = self.videoDeviceInput.device
            let currentPosition = currentVideoDevice.position
            
            let preferredPosition: AVCaptureDevice.Position
            let preferredDeviceType: AVCaptureDevice.DeviceType
            
            switch currentPosition {
            case .unspecified, .front:
                preferredPosition = .back
                preferredDeviceType = .builtInDualCamera
            case .back:
                preferredPosition = .front
                preferredDeviceType = .builtInWideAngleCamera
            }
            
            let devices = self.videoDeviceDiscoverySession.devices
            var newVideoDevice: AVCaptureDevice? = nil
            
            // First, look for a device with both the preferred position and device type. Otherwise, look for a device with only the preferred position.
            if let device = devices.first(where: { $0.position == preferredPosition && $0.deviceType == preferredDeviceType }) {
                newVideoDevice = device
            } else if let device = devices.first(where: { $0.position == preferredPosition }) {
                newVideoDevice = device
            }
            
            if let videoDevice = newVideoDevice {
                do {
                    let videoDeviceInput = try AVCaptureDeviceInput(device: videoDevice)
                    
                    self.session.beginConfiguration()
                    
                    // Remove the existing device input first, since using the front and back camera simultaneously is not supported.
                    self.session.removeInput(self.videoDeviceInput)
                    
                    if self.session.canAddInput(videoDeviceInput) {
                        self.session.addInput(videoDeviceInput)
                        self.videoDeviceInput = videoDeviceInput
                    } else {
                        self.session.addInput(self.videoDeviceInput)
                    }

                    self.videoOutput.connections.first?.videoOrientation = .portrait
                    self.session.commitConfiguration()
                } catch {
                    print("Error occured while creating video device input: \(error)")
                }
            }
        }
    }
}
