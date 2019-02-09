//
//  SwiftQrCodeScanner.h
//  SwiftQrCodeScanner
//
//  Created by Manish Rathi on 09/02/19.
//  Copyright © 2019 Manish. All rights reserved.
//

import UIKit

/// Scanner-View which will hold CameraView, OverlayView(Box-View), Cancel-Button.
final public class QRCodeScannerView: UIView {
    public let cameraView: UIView = {
        let cameraView = UIView()
        cameraView.clipsToBounds = true
        cameraView.translatesAutoresizingMaskIntoConstraints = false
        return cameraView
    }()
    
    public lazy var overlayView: ScannerOverlayView = {
        let overlayView = ScannerOverlayView()
        overlayView.clipsToBounds = true
        overlayView.translatesAutoresizingMaskIntoConstraints = false
        return overlayView
    }()
    
    public lazy var cancelButton: UIButton = {
        let cancelButton = UIButton()
        cancelButton.translatesAutoresizingMaskIntoConstraints = false
        cancelButton.setTitleColor(.gray, for: .highlighted)
        return cancelButton
    }()
    
    private weak var scanner: QRCodeScanner?
    
    public func setup(scanner: QRCodeScanner?) {
        self.scanner = scanner
        addComponents()
        addAutoLayoutConstraints()
    }
}


// MARK: - Convenience Methods
extension QRCodeScannerView {
    func addComponents() {
        addSubview(cameraView)
        addSubview(overlayView)
        addSubview(cancelButton)
        if let scanner = scanner {
            cameraView.layer.insertSublayer(scanner.previewLayer, at: 0)
        }
    }
    
    func addAutoLayoutConstraints() {
        let views = ["cameraView": cameraView, "cancelButton": cancelButton]
        
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "H:|[cameraView]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:|[cameraView]|", options: [], metrics: nil, views: views))
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: "V:[cancelButton]-16-|", options: [], metrics: nil, views: views))
        addConstraint(NSLayoutConstraint(item: cameraView, attribute: .centerX, relatedBy: .equal, toItem: cancelButton, attribute: .centerX, multiplier: 1, constant: 0))
        
        for attribute in [NSLayoutConstraint.Attribute]([.left, .top, .right, .bottom]) {
            addConstraint(NSLayoutConstraint(item: overlayView, attribute: attribute, relatedBy: .equal, toItem: cameraView, attribute: attribute, multiplier: 1, constant: 0))
        }
    }
}
