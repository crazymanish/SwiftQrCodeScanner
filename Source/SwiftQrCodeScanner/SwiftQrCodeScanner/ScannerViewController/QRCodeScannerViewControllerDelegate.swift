//
//  SwiftQrCodeScanner.h
//  SwiftQrCodeScanner
//
//  Created by Manish Rathi on 09/02/19.
//  Copyright © 2019 Manish. All rights reserved.
//

import Foundation

/**
 The methods of the protocol allow the delegate to be notified when the scanner did scan result and or when the user wants to stop the scanner.
 */
public protocol QRCodeScannerViewControllerDelegate: class {
    /**
     Notify the delegate that the scanner did scan a code.
     */
    func scanner(_ scanner: QRCodeScannerViewController, didScanResult result: QRCodeScannerResult)
    
    
    /**
     Notify the delegate that the scanner failed to scan a code.
     */
    func scannerFailed(_ scanner: QRCodeScannerViewController)
    
    
    /**
     Notify the delegate that the user wants to stop scanner.
     */
    func scannerDidCancel(_ scanner: QRCodeScannerViewController)
}
