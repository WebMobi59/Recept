//
//  MMDrawerVisualStateExt.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-06-16.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

extension MMDrawerVisualState {
    // State extension needed for Swift compatibility
    static func parallaxVisualStateBlockWithParallaxFactorSwift(_ parallaxFactor: CGFloat, drawerVisualStateDelegate: DrawerVisualStateDelegate?) -> ((MMDrawerController?, MMDrawerSide, CGFloat) -> Void) {
        return {
            (drawerController: MMDrawerController!, drawerSide: MMDrawerSide, percentVisible: CGFloat) -> Void in
            assert(parallaxFactor >= 1.0)
            
            var transform: CATransform3D = CATransform3DIdentity
            var sideDrawerViewController: UIViewController?
            
            if drawerSide == MMDrawerSide.left {
                sideDrawerViewController = drawerController.leftDrawerViewController
                let distance: CGFloat = max(drawerController.maximumLeftDrawerWidth,drawerController.visibleLeftDrawerWidth)
                
                if percentVisible <= 1 {
                    transform = CATransform3DMakeTranslation((-distance)/parallaxFactor+(distance*percentVisible/parallaxFactor), 0.0, 0.0)
                }
                else {
                    transform = CATransform3DMakeScale(percentVisible, 1, 1)
                    transform = CATransform3DTranslate(transform, drawerController.maximumLeftDrawerWidth*(percentVisible-1)/2, 0, 0)
                }
            }
            else if drawerSide == MMDrawerSide.right {
                sideDrawerViewController = drawerController.rightDrawerViewController
                let distance: CGFloat = max(drawerController.maximumRightDrawerWidth,drawerController.visibleRightDrawerWidth)
                
                if percentVisible <= 1 {
                    transform = CATransform3DMakeTranslation((distance)/parallaxFactor-(distance*percentVisible)/parallaxFactor, 0.0, 0.0)
                }
                else {
                    transform = CATransform3DMakeScale(percentVisible, 1, 1)
                    transform = CATransform3DTranslate(transform, -drawerController.maximumRightDrawerWidth*(percentVisible-1)/2, 0, 0)
                }
            }
            
            if let controller = sideDrawerViewController {
                controller.view.layer.transform = transform
            }
            
            drawerVisualStateDelegate?.didUpdateDrawerVisualState(percentVisible)
        } as! ((MMDrawerController?, MMDrawerSide, CGFloat) -> Void)
    }
}
