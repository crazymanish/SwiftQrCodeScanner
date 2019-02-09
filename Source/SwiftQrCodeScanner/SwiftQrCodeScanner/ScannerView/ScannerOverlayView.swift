//
//  SwiftQrCodeScanner.h
//  SwiftQrCodeScanner
//
//  Created by Manish Rathi on 09/02/19.
//  Copyright © 2019 Manish. All rights reserved.
//

import UIKit

/// Overlay over the camera view to display the area (a square) where to scan the code.
public final class ScannerOverlayView: UIView {
    public var overlayLayer: CAShapeLayer = {
        var overlay = CAShapeLayer()
        overlay.fillColor = UIColor.black.withAlphaComponent(0.75).cgColor
        overlay.fillRule = CAShapeLayerFillRule.evenOdd
        return overlay
    }()
    
    public var borderLayer: CAShapeLayer = {
        var overlay = CAShapeLayer()
        overlay.fillColor = UIColor.clear.cgColor
        overlay.strokeColor = UIColor.white.cgColor
        overlay.lineWidth = 1
        return overlay
    }()
    
    public var borderColor: UIColor = UIColor.white {
        didSet {
            self.borderLayer.strokeColor = borderColor.cgColor
            self.setNeedsDisplay()
        }
    }
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        self.setupOverlay()
    }
    
    required public init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        self.setupOverlay()
    }
    
    private func setupOverlay() {
        self.backgroundColor = .clear
        self.layer.addSublayer(self.overlayLayer)
        self.layer.addSublayer(self.borderLayer)
    }
    
    public override func draw(_ rect: CGRect) {
        let finalPath = UIBezierPath(rect: rect)
        finalPath.usesEvenOddFillRule = true
        
        var innerRect = rect.insetBy(dx: 37, dy: 37)
        let minSize = min(innerRect.width, innerRect.height)
        if innerRect.width != minSize {
            innerRect.origin.x += (innerRect.width - minSize) / 2
            innerRect.size.width = minSize
        } else if innerRect.height != minSize {
            innerRect.origin.y += (innerRect.height - minSize) / 2
            innerRect.size.height = minSize
        }
        
        let boxPath = UIBezierPath(roundedRect: innerRect, cornerRadius: 3)
        finalPath.append(boxPath)
        
        self.overlayLayer.path = finalPath.cgPath
        self.borderLayer.path = boxPath.cgPath
    }
}
