//
//  SwiftQrCodeScanner.h
//  SwiftQrCodeScanner
//
//  Created by Manish Rathi on 09/02/19.
//  Copyright © 2019 Manish. All rights reserved.
//

import Foundation


/**
 The result of the scan with its content value and the corresponding metadata type.
 */
public struct QRCodeScannerResult {
    /**
     The error corrected data decoded into a human-readable string.
     */
    public let value: String
    
    /**
     The type of the metadata.
     */
    public let metadataType: String
    
    /**
     Init
     */
    public init(value: String, metadataType: String) {
        self.value = value
        self.metadataType = metadataType
    }
}
