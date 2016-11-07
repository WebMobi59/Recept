//
//  PageContentViewController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-10-20.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class PageContentViewController: UIViewController
{
    @IBOutlet weak var label: UILabel!
    @IBOutlet weak var image: UIImageView!
    @IBOutlet weak var button: GreenButton!
    var background: UIImage?
    
    open override func viewDidLoad() {
        super.viewDidLoad()
    }
    
    open static func instantiateWith(
        topImageSvgName aTopImageSvgName: String,
        backgroundImageName: String,
        contentText: String,
        contentButtonText: String?,
        contentButtonTarget: AnyObject?,
        contentButtonAction: Selector?) -> PageContentViewController
    {
        let containingStoryBoard = UIStoryboard(name: "FirstTimeGuide", bundle: nil)
        let contentViewController = containingStoryBoard.instantiateViewController(withIdentifier: "PageContentViewController") as! PageContentViewController
        contentViewController.view.layoutIfNeeded() // Ensure view is loaded
        
        contentViewController.setupSvgImage(aTopImageSvgName)
        contentViewController.setupContentText(contentText)
        contentViewController.setupContentButton(contentButtonText, target: contentButtonTarget, action: contentButtonAction)
        contentViewController.setupBackgroundImage(backgroundImageName)
        
        return contentViewController
    }
    
    fileprivate func setupSvgImage(_ imageName: String) {
        let svgImage = SVGKImage(named: imageName)
        svgImage?.size = self.image.frame.size
        self.image.image = svgImage?.uiImage
        self.applyShadowDefaultsToLayer(self.image.layer)
    }
    
    fileprivate func setupContentText(_ text: String) {
        self.label.font = AppoteketTheme.Fonts.FirstTimeGuide
        self.label.textColor = AppoteketTheme.Colors.HeaderTextOnBlack
        self.applyShadowDefaultsToLayer(self.label.layer)
        self.label.layer.shadowOpacity = 0.7
        self.label.layer.shadowRadius = 4
        self.setContentText(text, lineSpacing: 8)
    }
    
    fileprivate func setContentText(_ text: String?, lineSpacing: CGFloat) {
        let paragraphStyle = NSMutableParagraphStyle()
        paragraphStyle.lineSpacing = lineSpacing
        paragraphStyle.alignment = self.label.textAlignment
        let attributes = [NSParagraphStyleAttributeName: paragraphStyle]
        
        let attributedText: NSAttributedString?
        if text != nil {
            attributedText = NSAttributedString(string: text!, attributes: attributes)
        }
        else {
            attributedText = nil
        }
        
        self.label.attributedText = attributedText
    }
    
    fileprivate func applyShadowDefaultsToLayer(_ layer: CALayer) {
        layer.shadowOffset = CGSize(width: 0, height: 0.5)
        layer.shadowColor = UIColor.black.cgColor
        layer.shadowOpacity = 0.25
        layer.shadowRadius = 4
    }
    
    fileprivate func setupContentButton(_ text: String?, target: AnyObject?, action: Selector?) {
        guard text != nil && target != nil && action != nil else {
            self.button.isHidden = true
            return
        }
        
        self.button.title = text
        self.button.addTarget(target!, action: action!, for: .touchUpInside)
    }
    
    fileprivate func setupBackgroundImage(_ imageName: String) {
        self.background = UIImage(named: imageName)
    }
}
