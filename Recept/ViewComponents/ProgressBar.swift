//
//  ProgressBar.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-23.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class ProgressBar: UIView {
    fileprivate let backgroundView: UIView
    fileprivate let progressView: UIView
    fileprivate var progressPercent: CGFloat
    
    public required init?(coder aDecoder: NSCoder) {
        self.backgroundView = UIView()
        self.progressView = UIView()
        self.progressPercent = 0
        
        super.init(coder: aDecoder)
        
        self.backgroundColor = UIColor.clear
        self.layer.cornerRadius = self.frame.height / 2
        self.layer.masksToBounds = true
        
        self.backgroundView.frame = self.bounds
        self.backgroundView.backgroundColor = AppoteketTheme.Colors.ProgressTrack
        self.backgroundView.layer.cornerRadius = self.frame.height / 2
        self.backgroundView.layer.borderWidth = 0
        self.addSubview(self.backgroundView)
        
        self.progressView.frame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: 0, height: self.frame.height))
        self.progressView.backgroundColor = AppoteketTheme.Colors.ProgressDownloaded
        self.addSubview(self.progressView)
    }
    
    open var progress: CGFloat {
        get {
            return self.progressPercent
        }
    }
    
    open func setProgress(_ progress: CGFloat, animated: Bool) {
        self.progressPercent = max(0, progress)
        AnimationUtility.animate(0.1) {
            let newFrame = CGRect(origin: CGPoint(x: 0, y: 0), size: CGSize(width: self.progressPercent * self.frame.width, height: self.progressView.frame.height))
            self.progressView.frame = newFrame
        }
    }
}
