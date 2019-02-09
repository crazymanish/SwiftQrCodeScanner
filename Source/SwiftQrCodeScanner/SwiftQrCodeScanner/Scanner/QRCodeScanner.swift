//
//  SwiftQrCodeScanner.h
//  SwiftQrCodeScanner
//
//  Created by Manish Rathi on 09/02/19.
//  Copyright © 2019 Manish. All rights reserved.
//

import UIKit
import AVFoundation

/// QRCodeScanner: to read / scan 1D and 2D i.e QR codes.
public final class QRCodeScanner: NSObject {
    /// Internal Properties.
    let sessionQueue = DispatchQueue(label: "com.manish.session.queue")
    let metadataObjectsQueue = DispatchQueue(label: "com.manish.metadataObjects.queue", attributes: [], target: nil)
    
    var defaultDevice = AVCaptureDevice.default(for: .video)
    lazy var defaultDeviceInput: AVCaptureDeviceInput? = {
        guard let defaultDevice = defaultDevice else { return nil }
        return try? AVCaptureDeviceInput(device: defaultDevice)
    }()
    
    var session = AVCaptureSession()
    var metadataOutput = AVCaptureMetadataOutput()
    
    /// CALayer that you use to display video as it is being captured by an input device.
    public let previewLayer: AVCaptureVideoPreviewLayer
    
    /// An array of object identifying the types of metadata objects to process.
    public let metadataObjectTypes: [AVMetadataObject.ObjectType]

    /// Flag to know whether the scanner should stop scanning when a code is found.
    public var stopScanningWhenCodeIsFound = true
    
    /// Block is executed when a metadata object is found.
    public var didFindCode: ((QRCodeScannerResult) -> Void)?
    
    /// Block is executed when a found metadata object string could not be decoded.
    public var didFailDecoding: (() -> Void)?
    
    
    
    // MARK: - Init
    /**
     Initializes the code reader with the DataMatix metadata type object.
     */
    public convenience override init() {
        self.init(metadataObjectTypes: [AVMetadataObject.ObjectType.dataMatrix], captureDevicePosition: .back)
    }
    
    /**
     Initializes the code reader with an array of metadata object types, and the default initial capture position (.back)
     */
    public convenience init(metadataObjectTypes types: [AVMetadataObject.ObjectType]) {
        self.init(metadataObjectTypes: types, captureDevicePosition: .back)
    }
    
    /**
     Initializes the code reader with an array of metadata object types.
     */
    private init(metadataObjectTypes types: [AVMetadataObject.ObjectType], captureDevicePosition: AVCaptureDevice.Position) {
        metadataObjectTypes = types
        previewLayer = AVCaptureVideoPreviewLayer(session: session)
        super.init()
        sessionQueue.async {
            self.configureDefaultComponents(withCaptureDevicePosition: captureDevicePosition)
        }
    }
}


// MARK: - Initialize AVFoundation Components
extension QRCodeScanner {
    private func configureDefaultComponents(withCaptureDevicePosition: AVCaptureDevice.Position) {
        for output in session.outputs {
            session.removeOutput(output)
        }
        for input in session.inputs {
            session.removeInput(input)
        }
        
        // Add video input
        switch withCaptureDevicePosition {
        case .back:
            if let _defaultDeviceInput = defaultDeviceInput {
                session.addInput(_defaultDeviceInput)
            }
        case .front, .unspecified:
            print("TODO: Handle Front Camera.")
        }
        
        // Add metadata output
        session.addOutput(metadataOutput)
        metadataOutput.setMetadataObjectsDelegate(self, queue: metadataObjectsQueue)
        
        let allTypes = Set(metadataOutput.availableMetadataObjectTypes)
        let filtered = metadataObjectTypes.filter { (mediaType) -> Bool in
            allTypes.contains(mediaType)
        }

        metadataOutput.metadataObjectTypes = filtered
        previewLayer.videoGravity = .resizeAspectFill
        
        // Commit Configuration
        session.commitConfiguration()
    }
}


// MARK: - APIs
extension QRCodeScanner {
    /**
     Starts scanning the codes.
     */
    public func startScanning() {
        sessionQueue.async {
            guard !self.session.isRunning else { return }
            self.session.startRunning()
        }
    }
    
    /**
     Stops scanning the codes.
     */
    public func stopScanning() {
        sessionQueue.async {
            guard self.session.isRunning else { return }
            self.session.stopRunning()
        }
    }
    
    /**
     Check whether the session is currently running.
     */
    public var isRunning: Bool {
        return session.isRunning
    }
}


// MARK: - AVCaptureMetadataOutputObjects Delegate Methods
extension QRCodeScanner: AVCaptureMetadataOutputObjectsDelegate {
    public func metadataOutput(_ output: AVCaptureMetadataOutput, didOutput metadataObjects: [AVMetadataObject], from connection: AVCaptureConnection) {
        sessionQueue.async { [weak self] in
            guard let weakSelf = self else { return }
            for current in metadataObjects {
                if let readableCodeObject = current as? AVMetadataMachineReadableCodeObject {
                    if readableCodeObject.stringValue != nil {
                        if weakSelf.metadataObjectTypes.contains(readableCodeObject.type) {
                            guard weakSelf.session.isRunning, let value = readableCodeObject.stringValue else { return }
                            if weakSelf.stopScanningWhenCodeIsFound {
                                weakSelf.session.stopRunning()
                            }
                            let scannedResult = QRCodeScannerResult(value: value, metadataType:readableCodeObject.type.rawValue)
                            DispatchQueue.main.async {
                                weakSelf.didFindCode?(scannedResult)
                            }
                        }
                    }
                }
                else {
                    weakSelf.didFailDecoding?()
                }
            }
        }
    }
}


// MARK: - Check Current Device Capabilities.
extension QRCodeScanner {
    /**
     Checks and return whether the given metadata object types are supported by the current device or not.
     */
    public class func supportsMetadataObjectTypes(_ metadataTypes: [AVMetadataObject.ObjectType]? = nil) throws -> Bool {
        guard let captureDevice = AVCaptureDevice.default(for: .video) else {
            throw NSError(domain: "com.manish.error", code: -1, userInfo: nil)
        }
        
        let deviceInput = try AVCaptureDeviceInput(device: captureDevice)
        let output      = AVCaptureMetadataOutput()
        let session     = AVCaptureSession()
        
        session.addInput(deviceInput)
        session.addOutput(output)
        
        var metadataObjectTypes = metadataTypes
        
        if metadataObjectTypes == nil || metadataObjectTypes?.count == 0 {
            // Check the QR code metadata object type by default
            metadataObjectTypes = [.qr]
        }
        
        for metadataObjectType in metadataObjectTypes! {
            if !output.availableMetadataObjectTypes.contains { $0 == metadataObjectType } {
                return false
            }
        }
        return true
    }
}
