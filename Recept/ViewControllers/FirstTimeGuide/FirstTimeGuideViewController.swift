//
//  FirstTimeGuideViewController.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-10-20.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

import Foundation

public protocol FirstTimeGuideDelegate: class {
    func didFinishFirstTimeGuide()
    func isFirstTimeLaunchForCurrentVersion() -> Bool
    func isFirstTimeLaunch() -> Bool
    func markFirstTimeLaunchForCurrentVersion()
    func markFirstTimeLaunch()
}

open class FirstTimeGuideViewController: UIViewController, UIPageViewControllerDataSource, UIPageViewControllerDelegate, PageViewControllerTransitionDelegate
{
    fileprivate var analyticsService: AnalyticsService!
    
    @IBOutlet weak var pageControl: UIPageControl!
    @IBOutlet weak var closeButton: CloseButton!
    weak var delegate: FirstTimeGuideDelegate?
    
    @IBOutlet weak var topBackgroundImage: UIImageView!
    @IBOutlet weak var bottomBackgroundImage: UIImageView!
    
    open var contentViewControllers: [PageContentViewController] = []
    open var leftTransitionSlideIndex: Int?
    open var rightTransitionSlideIndex: Int?
    open var transitionDirection: UIPageViewControllerNavigationDirection?
    fileprivate var pageViewController: PageViewController!
    
    open static func launchFromViewControllerWithDelegate(_ fromViewController: UIViewController, delegate: FirstTimeGuideDelegate, analyticsService: AnalyticsService!) {
        let storyBoard = UIStoryboard(name: "FirstTimeGuide", bundle: nil)
        let rootViewController = storyBoard.instantiateInitialViewController() as! FirstTimeGuideViewController
        rootViewController.analyticsService = analyticsService
        rootViewController.delegate = delegate
        fromViewController.present(rootViewController, animated: false, completion: nil)
    }
    
    open override func viewDidLoad() {
        super.viewDidLoad()
        
        self.initContentViewControllers()
        self.addPageViewController(self.contentViewControllers.count)
        self.pageViewController.transitionDelegate = self
        self.view.bringSubview(toFront: self.closeButton)
        self.view.bringSubview(toFront: self.pageControl)
    }
    
    fileprivate func initContentViewControllers() {
        if delegate!.isFirstTimeLaunch() {
            delegate!.markFirstTimeLaunch()
            self.contentViewControllers = [
                    PageContentViewController.instantiateWith(
                    topImageSvgName: "logo_notext.svg",
                            backgroundImageName: "first_time_guide_slide_1.jpg",
                            contentText: LocalizableStrings.FirstTimeGuide.FirstSlideText,
                            contentButtonText: nil,
                            contentButtonTarget: nil,
                            contentButtonAction: nil),
                    PageContentViewController.instantiateWith(
                    topImageSvgName: "logo_notext.svg",
                            backgroundImageName: "first_time_guide_slide_2.jpg",
                            contentText: LocalizableStrings.FirstTimeGuide.SecondSlideText,
                            contentButtonText: nil,
                            contentButtonTarget: nil,
                            contentButtonAction: nil),
                    PageContentViewController.instantiateWith(
                    topImageSvgName: "logo_notext.svg",
                            backgroundImageName: "first_time_guide_slide_3.jpg",
                            contentText: LocalizableStrings.FirstTimeGuide.ThirdSlideText,
                            contentButtonText: LocalizableStrings.FirstTimeGuide.LastSlideButtonText,
                            contentButtonTarget: self,
                            contentButtonAction: #selector(FirstTimeGuideViewController.didTapButtonOnSlide3(_:)))
            ]
        }
        else if delegate!.isFirstTimeLaunchForCurrentVersion() {
            delegate!.markFirstTimeLaunchForCurrentVersion()
            self.contentViewControllers = [
                    PageContentViewController.instantiateWith(
                            topImageSvgName: "logo_notext.svg",
                            backgroundImageName: "first_time_guide_slide_1.jpg",
                            contentText: LocalizableStrings.FirstTimeGuide.FirstSlideTextLastVersion,
                            contentButtonText: nil,
                            contentButtonTarget: nil,
                            contentButtonAction: nil),
                    PageContentViewController.instantiateWith(
                            topImageSvgName: "logo_notext.svg",
                            backgroundImageName: "first_time_guide_slide_2.jpg",
                            contentText: LocalizableStrings.FirstTimeGuide.SecondSlideTextLastVersion,
                            contentButtonText: LocalizableStrings.FirstTimeGuide.LastSlideButtonText,
                            contentButtonTarget: self,
                            contentButtonAction: #selector(FirstTimeGuideViewController.didTapButtonOnSlide3(_:)))
            ]
        }
    }
    
    @IBAction func didTapButtonOnSlide3(_ sender: UIButton) {
        self.close("Knapp på sida 3")
    }
    
    @IBAction func didTapCloseButton(_ sender: UIButton) {
        self.close("Kryssknapp")
    }
    
    fileprivate func close(_ analyticsEventLabel: String) {
        self.analyticsService.sendEvent("Intro", action: "Stäng", label: analyticsEventLabel)
        self.dismiss(animated: true, completion: nil)
        self.delegate?.didFinishFirstTimeGuide()
    }
    
    fileprivate func addPageViewController(_ numberOfPages: Int) {
        self.pageViewController = self.storyboard!.instantiateViewController(withIdentifier: "PageViewController") as! PageViewController
        self.pageViewController.dataSource = self
        self.addChildViewController(self.pageViewController)
        self.view.addSubview(self.pageViewController.view)
        self.pageViewController.didMove(toParentViewController: self)
        self.pageViewController.delegate = self
        self.setupPagingDots(numberOfPages)
        self.changeToSlide(0, animated: false)
        self.analyticsService.sendScreenView("Intro/Sida 1")
    }
    
    fileprivate func setupPagingDots(_ numberOfPages: Int) {
        self.pageControl.isUserInteractionEnabled = false
        self.pageControl.numberOfPages = numberOfPages
        self.pageControl.currentPageIndicatorTintColor = UIColor.white
        self.pageControl.pageIndicatorTintColor = AppoteketTheme.Colors.DefaultAction
    }
    
    fileprivate func changeToSlide(_ index: Int, animated: Bool) {
        let viewControllers = [self.contentViewControllers[index]] // UIPageViewController should only have one item in the array
        self.bottomBackgroundImage.image = self.contentAtIndex(index)?.background
        self.pageViewController.setViewControllers(viewControllers, direction: .forward, animated: animated, completion: nil)
    }
    
    fileprivate func setActivePageDotForContentViewController(_ pageContentViewController: PageContentViewController) {
        guard let currentIndex = self.contentIndexOf(pageContentViewController) else {
            return
        }
        
        self.pageControl.currentPage = currentIndex
    }
    
    fileprivate func contentViewControllerForOffset(_ contentViewContoller: PageContentViewController, indexOffset: Int) -> PageContentViewController? {
        guard let currentIndex = self.contentIndexOf(contentViewContoller) else {
            return nil
        }
        
        let offsettedIndex = currentIndex + indexOffset
        
        return self.contentAtIndex(offsettedIndex)
    }
    
    fileprivate func contentIndexOf(_ contentViewController: PageContentViewController) -> Int? {
        return self.contentViewControllers.index(of: contentViewController)
    }
    
    fileprivate func contentAtIndex(_ index: Int) -> PageContentViewController? {
        guard index >= 0 && index <= (self.contentViewControllers.count - 1) else {
            return nil
        }
        
        return self.contentViewControllers[index]
    }
    
    // MARK: - UIPageViewControllerDataSource
    open func presentationCount(for pageViewController: UIPageViewController) -> Int {
        return self.contentViewControllers.count
    }
    
    open func presentationIndex(for pageViewController: UIPageViewController) -> Int {
        guard let currentContentController = pageViewController.viewControllers?.last as? PageContentViewController else {
            return 0
        }
        
        return self.contentIndexOf(currentContentController)!
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerBefore viewController: UIViewController) -> UIViewController? {
        guard let currentContentViewController = viewController as? PageContentViewController else {
            return nil
        }
        
        return self.contentViewControllerForOffset(currentContentViewController, indexOffset: -1)
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, viewControllerAfter viewController: UIViewController) -> UIViewController? {
        guard let currentContentViewController = viewController as? PageContentViewController else {
            return nil
        }
        
        return self.contentViewControllerForOffset(currentContentViewController, indexOffset: 1)
    }
    
    // MARK: - UIPageViewControllerDelegate
    open func pageViewController(_ pageViewController: UIPageViewController, didFinishAnimating finished: Bool, previousViewControllers: [UIViewController], transitionCompleted completed: Bool) {
        guard let contentViewController = pageViewController.viewControllers?.last as? PageContentViewController else {
            return
        }
        
        self.setActivePageDotForContentViewController(contentViewController)
        self.didFinishTransition(contentViewController)
        
        // Track page shown to analytics
        let previousContentViewController = previousViewControllers.last as? PageContentViewController
        if previousContentViewController != contentViewController {
            self.analyticsService.sendScreenView("Intro/Sida \(self.contentIndexOf(contentViewController)! + 1)")
        }
    }
    
    open func pageViewController(_ pageViewController: UIPageViewController, willTransitionTo pendingViewControllers: [UIViewController]) {
        guard
            pageViewController.viewControllers != nil,
            let currentContent = pageViewController.viewControllers![0] as? PageContentViewController,
            let nextContent = pendingViewControllers[0] as? PageContentViewController else {
                self.didFinishTransition(pageViewController.viewControllers![0] as? PageContentViewController)
                return
        }
        
        self.setLeftAndRightTransitionIndexes(currentContent: currentContent, nextContent: nextContent)
    }
    
    fileprivate func didFinishTransition(_ contentViewController: PageContentViewController?) {
        self.leftTransitionSlideIndex = nil
        self.rightTransitionSlideIndex = nil
        self.transitionDirection = nil
        
        self.bottomBackgroundImage.image = contentViewController?.background
        self.bottomBackgroundImage.alpha = 1
        self.topBackgroundImage.alpha = 0
    }
    
    fileprivate func setLeftAndRightTransitionIndexes(currentContent theCurrentContent: PageContentViewController, nextContent: PageContentViewController) {
        let currentIndex = self.contentIndexOf(theCurrentContent)!
        let nextIndex = self.contentIndexOf(nextContent)!
        
        self.leftTransitionSlideIndex = min(currentIndex, nextIndex)
        self.rightTransitionSlideIndex = max(currentIndex, nextIndex)
        
        self.bottomBackgroundImage.image = self.contentAtIndex(self.leftTransitionSlideIndex!)?.background
        self.topBackgroundImage.image = self.contentAtIndex(self.rightTransitionSlideIndex!)?.background
        if self.leftTransitionSlideIndex == currentIndex {
            self.transitionDirection = UIPageViewControllerNavigationDirection.forward
            self.bottomBackgroundImage.alpha = 1
            self.topBackgroundImage.alpha = 0
        }
        else {
            self.transitionDirection = UIPageViewControllerNavigationDirection.reverse
            self.bottomBackgroundImage.alpha = 0
            self.topBackgroundImage.alpha = 1
        }
    }
    
    open func didChangePositionBetweenSlides(leftIndex aLeftSlideIndex: Int?, rightIndex: Int?, percentageLeftShown: CGFloat?) {
        if (percentageLeftShown != nil) {
            self.bottomBackgroundImage.alpha = percentageLeftShown!
            self.topBackgroundImage.alpha = 1 - percentageLeftShown!
        }
    }
}
