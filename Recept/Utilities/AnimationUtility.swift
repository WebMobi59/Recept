//
//  AnimationUtility.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-24.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

import Foundation

open class AnimationUtility {
    open static func animate(_ animations: @escaping () -> Void) {
        UIView.animate(withDuration: AppoteketTheme.Animation.DefaultDuration, delay: 0, options: AppoteketTheme.Animation.DefaultOptions, animations: animations, completion: nil)
    }
    
    open static func animate(_ duration: TimeInterval, animations: @escaping () -> Void) {
        UIView.animate(withDuration: duration, delay: 0, options: AppoteketTheme.Animation.DefaultOptions, animations: animations, completion: nil)
    }
    
    open static func animate(_ animations: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: AppoteketTheme.Animation.DefaultDuration, delay: 0, options: AppoteketTheme.Animation.DefaultOptions, animations: animations, completion: completion)
    }
    
    open static func animate(_ duration: TimeInterval, animations: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: duration, delay: 0, options: AppoteketTheme.Animation.DefaultOptions, animations: animations, completion: completion)
    }
    
    open static func animate(_ duration: TimeInterval, delay: TimeInterval, animations: @escaping () -> Void, completion: @escaping (Bool) -> Void) {
        UIView.animate(withDuration: duration, delay: delay, options: AppoteketTheme.Animation.DefaultOptions, animations: animations, completion: completion)
    }
    
    open static func animate(_ duration: TimeInterval, options: UIViewAnimationOptions, animations: @escaping () -> Void) {
        UIView.animate(withDuration: duration, delay: 0, options: options, animations: animations, completion: nil)
    }
    
    open static func animateBouncing(_ animations: @escaping () -> Void) {
        UIView.animate(
            withDuration: AppoteketTheme.Animation.DefaultDuration,
            delay: 0.0,
            usingSpringWithDamping: 0.5,
            initialSpringVelocity: CGFloat(AppoteketTheme.Animation.DefaultDuration),
            options: AppoteketTheme.Animation.DefaultOptions,
            animations: animations,
            completion: nil
        )
    }
    
    open static func animateBouncing(_ duration: TimeInterval, damping: CGFloat, animations: @escaping () -> Void) {
        UIView.animate(
            withDuration: duration,
            delay: 0.0,
            usingSpringWithDamping: damping,
            initialSpringVelocity: CGFloat(duration),
            options: AppoteketTheme.Animation.DefaultOptions,
            animations: animations,
            completion: nil
        )
    }
}
