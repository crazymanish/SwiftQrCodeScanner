# SwiftQrCodeScanner
A light weight Qr code scanner framework written in Swift.
-------------------

SwiftQrCodeScanner is a framework which has capability to scan any Qr code by using the iOS device. It's also supports the `blur-overlay` around the scanning area. i.e.
![](SwiftQrCodeScanner.gif)

## Usage
- **SwiftQrCodeScanner** framework have **QRCodeScannerViewController** as core class, which responsible for opening the back camera of iOS device & scan the QR code.
- **QRCodeScannerViewControllerDelegate** is responsible to send back the call-back, if QR code scan successfully done or failed.

### TODO
- MockQrCodeScanner framework, which will be mock version of SwiftQrCodeScanner. This will be helpful for unit-testing.
- Example app with SwiftQrCodeScanner & MockQrCodeScanner.
- Unit Test-Cases for SwiftQrCodeScanner framework.
-------------------

# Installation

## CocoaPods
[CocoaPods](http://cocoapods.org) is a dependency manager for CocoaProjects.
To integrate RxBluetoothKit into your Xcode project using CocoaPods specify it in your `Podfile`:
```ruby
source 'https://github.com/crazymanish/CocoaPodsSpecs.git'  #Add this source line, this library still under development.

pod 'SwiftQrCodeScanner'  #Add CocoaPods dependency for SwiftQrCodeScanner
```

## Integration
- QRCodeScannerViewController can be integrated with simple steps as:
```swift
/// Step1: Import SwiftQrCodeScanner framework
import SwiftQrCodeScanner

/// Step2: Create QRCodeScannerViewController instance. Recommend to have lazy instance.
lazy var scannerViewController: QRCodeScannerViewController = {
    return QRCodeScannerViewController(cancelButtonTitle: "Cancel")
}()

/// Step3: As per requirement, Add `scannerViewController` instance as child view controller. i.e lets say on page appear, need to open QrScanner then
override func viewWillAppear(_ animated: Bool) {
    super.viewWillAppear(animated)

    //Set this delegate to receive Callbacks.
    self.scannerViewController.delegate = self

    //This helper method(see below in more details) add `scannerViewController` as child viewController on containerView.
    self.addChildViewController(self.scannerViewController, containerView: self.view)
}
```

- Currently QRCodeScannerViewControllerDelegate has below callback as:
```swift
/**
 The methods of the protocol allow the delegate to be notified when the scanner did scan result and or when the user wants to stop the scanner.
 */
public protocol QRCodeScannerViewControllerDelegate: class {
    /**
     Notify the delegate that the scanner finished scanning a Qr code successfully.
     */
    func scanner(_ scanner: QRCodeScannerViewController, didScanResult result: QRCodeScannerResult)


    /**
     Notify the delegate that the scanner failed to scan a Qr code.
     */
    func scannerFailed(_ scanner: QRCodeScannerViewController)


    /**
     Notify the delegate that the user wants to stop scanner, Pressed Cancel button.
     */
    func scannerDidCancel(_ scanner: QRCodeScannerViewController)
}
```

- If you are wondering what is above `addChildViewController: containerView` api do:
```swift
//UIViewController+ChildViewController.swift file

public extension UIViewController {
    /**
     * Add ChildViewController inside specific container-view.
     *
     */
   public func addChildViewController(_ childViewController: UIViewController, containerView: UIView) {
        if !childViewControllers.contains(childViewController) {
            //Add ChildViewController.
            guard let childView = childViewController.view else { return}
            addChildViewController(childViewController)
            containerView.addSubview(childView)
            childViewController.didMove(toParentViewController: self)

            //Add Autolayout Constraints
            childView.translatesAutoresizingMaskIntoConstraints = false
            let views: [String: UIView] = ["childView": childView]
            var visualFormatConstraints = [String]()
            visualFormatConstraints.append("H:|[childView]|")
            visualFormatConstraints.append("V:|[childView]|")
            containerView.addConstraints(visualFormatConstraints, metrics: nil, views: views)
        }
    }

    /**
     * Remove currentViewController from its parent-viewController.
     *
     */
   public func removeChildViewControllerFromParent() {
        willMove(toParentViewController: nil)
        view.removeFromSuperview()
        removeFromParentViewController()
    }
}

//UIView+Autolayout.Swift file
public func addConstraints(_ visualStringConstraints: [String],
                           metrics: [String : Any]?,
                           views: [String : Any]) {
    for visualFormat in visualStringConstraints {
        addConstraints(NSLayoutConstraint.constraints(withVisualFormat: visualFormat,
                                                                       options: [],
                                                                       metrics: metrics,
                                                                       views: views))
    }
}
```

# Requirements
- iOS 10.0+
- Xcode 10.0+

# Swift versions
* Current version supports Swift 4.2

# LICENSE
* MIT
