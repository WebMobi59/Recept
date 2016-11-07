//
//  PageViewController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-10-20.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

import Foundation

public protocol PageViewControllerTransitionDelegate: class {
    var contentViewControllers: [PageContentViewController] { get set }
    var leftTransitionSlideIndex: Int? { get set }
    var rightTransitionSlideIndex: Int? { get set }
    var transitionDirection: UIPageViewControllerNavigationDirection? { get set }
    func didChangePositionBetweenSlides(leftIndex aLeftIndex: Int?, rightIndex: Int?, percentageLeftShown: CGFloat?)
}

open class PageViewController: UIPageViewController, UIScrollViewDelegate
{
    weak var transitionDelegate: PageViewControllerTransitionDelegate?
    
    open override func viewDidLoad() {
        self.removeDefaultPageControl()
    }
    
    fileprivate func removeDefaultPageControl() {
        let frameSizeWithoutBottomSpace = CGSize(width: self.view.frame.width, height: self.view.frame.height + 37)
        self.view.frame = CGRect(origin: self.view.frame.origin, size: frameSizeWithoutBottomSpace)
        
        self.hideDefaultPageControl()
    }
    
    fileprivate func hideDefaultPageControl() {
        for view in self.view.subviews {
            if view.isKind(of: UIPageControl.self) {
                view.isHidden = true
            }
            else if view.isKind(of: UIScrollView.self) {
                let scrollView = view as! UIScrollView
                scrollView.delegate = self
            }
        }
    }
    
    open func scrollViewDidScroll(_ scrollView: UIScrollView) {
        guard
            let delegate = self.transitionDelegate
        else {
            return
        }
        
        let left = delegate.leftTransitionSlideIndex
        let right = delegate.rightTransitionSlideIndex
        let direction = delegate.transitionDirection
        let isScrolling = left != nil && right != nil && direction != nil
        
        var percentageLeftShown: CGFloat? = nil
        if (isScrolling) {
            let positionX: CGFloat
            if direction! == .forward {
                positionX = (2 * scrollView.frame.width - scrollView.contentOffset.x)
            }
            else {
                positionX = (scrollView.frame.width - scrollView.contentOffset.x)
            }
            
            percentageLeftShown = (positionX / scrollView.frame.width)
            percentageLeftShown = min(CGFloat(1.0), percentageLeftShown!)
            percentageLeftShown = max(CGFloat(0.0), percentageLeftShown!)
        }
        
        delegate.didChangePositionBetweenSlides(leftIndex: left, rightIndex: right, percentageLeftShown: percentageLeftShown)
    }
}
