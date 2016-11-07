//
//  UIWebViewExt.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-09.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

extension UIWebView {
    func updateDeviceWidth() -> Void {
        let viewportWidth = Int(self.frame.width)
        let viewportJS = "document.querySelector('meta[name=viewport]').setAttribute('content', 'width=\(viewportWidth)', false);"
        self.stringByEvaluatingJavaScript(from: viewportJS)
    }
    
    func disableLongPressGestures() {
        // Fix to disable the magnifying glass (overrides default gesture)
        let longPress:UILongPressGestureRecognizer = UILongPressGestureRecognizer(target: nil, action: nil)
        longPress.minimumPressDuration = 0.2
        self.addGestureRecognizer(longPress)
    }
}
