//
//  SwiftQrCodeScanner.h
//  SwiftQrCodeScanner
//
//  Created by Manish Rathi on 09/02/19.
//  Copyright © 2019 Manish. All rights reserved.
//

import UIKit

/// Convenient controller to display a view to scan/read 1D or 2D bar codes like the QRCodes.
public class QRCodeScannerViewController: UIViewController {
    /// The scanner object used to scan the QR code.
    public let scanner = QRCodeScanner()
    public let scannerView = QRCodeScannerView()
    
    /// The receiver's delegate that will be called when a result is found.
    public weak var delegate: QRCodeScannerViewControllerDelegate?
    
    /// The completion blocak that will be called when a result is found.
    public var completionBlock: ((QRCodeScannerResult?) -> Void)?
    
    /// DeInit
    deinit {
        scanner.stopScanning()
    }
    
    // MARK: - Init
    required public init(cancelButtonTitle: String) {
        super.init(nibName: nil, bundle: nil)
        self.instanceInit(cancelButtonTitle)
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }
    
    // MARK: - View-Cycle
    override public func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        self.startScanning()
    }
    
    override public func viewWillDisappear(_ animated: Bool) {
        self.stopScanning()
        super.viewWillDisappear(animated)
    }
    
    // MARK: - Helper
    public override var prefersStatusBarHidden: Bool {
        return true
    }
    
    override public func viewWillLayoutSubviews() {
        super.viewWillLayoutSubviews()
        self.scanner.previewLayer.frame = view.bounds
    }
}


// MARK: - instanceInit
extension QRCodeScannerViewController {
    /// Helper Init.
    func instanceInit(_ cancelButtonTitle: String) {
        self.scanner.didFindCode = { [weak self] resultAsObject in
            if let weakSelf = self {
                weakSelf.completionBlock?(resultAsObject)
                weakSelf.delegate?.scanner(weakSelf, didScanResult: resultAsObject)
            }
        }
        
        self.scanner.didFailDecoding = { [weak self] in
            if let weakSelf = self {
                weakSelf.completionBlock?(nil)
                weakSelf.delegate?.scannerFailed(weakSelf)
            }
        }
        
        self.setupView(cancelButtonTitle)
    }
}


// MARK: - Setup View
extension QRCodeScannerViewController {
    func setupView(_ cancelButtonTitle: String) {
        self.scannerView.translatesAutoresizingMaskIntoConstraints = false
        self.view.addSubview(self.scannerView)
        self.scannerView.setup(scanner: self.scanner)
        
        // Setup action methods
        self.scannerView.cancelButton.setTitle(cancelButtonTitle, for: .normal)
        self.scannerView.cancelButton.addTarget(self, action: #selector(handleCancelButtonPressed), for: .touchUpInside)
        
        // Setup constraints
        for attribute in [.left, .right, .top, .bottom] as [NSLayoutConstraint.Attribute] {
            NSLayoutConstraint(item: scannerView, attribute: attribute, relatedBy: .equal, toItem: view, attribute: attribute, multiplier: 1, constant: 0).isActive = true
        }
    }
    
    @objc func handleCancelButtonPressed(_ button: UIButton) {
        scanner.stopScanning()
        self.completionBlock?(nil)
        self.delegate?.scannerDidCancel(self)
    }
}


// MARK: - Start/Stop the Scanner.
extension QRCodeScannerViewController {
    /// Starts scanning the codes.
    public func startScanning() {
        scanner.startScanning()
    }
    
    /// Stops scanning the codes.
    public func stopScanning() {
        scanner.stopScanning()
    }
}
