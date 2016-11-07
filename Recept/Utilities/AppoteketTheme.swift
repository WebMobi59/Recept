//
//  AppoteketTheme.swift
//  Recept
//
//  Created by Daniel Lervik on 2015-07-06.
//  Copyright (c) 2015 Apoteket AB. All rights reserved.
//

open class AppoteketTheme {
    open class Animation {
        open static let DefaultDuration: TimeInterval = 0.4
        open static let DefaultOptions: UIViewAnimationOptions = UIViewAnimationOptions()
        
        open static let MediumDuration: TimeInterval = 0.2
        open static let MediumOptions: UIViewAnimationOptions = .curveEaseOut
        
        open static let ShortDuration: TimeInterval = 0.08
        open static let ShortOptions: UIViewAnimationOptions = .curveEaseOut
    }
    
    open class Dimension {
        open static func ButtonBorderRadius(_ frameHeight: CGFloat) -> CGFloat {
            return frameHeight / 2
        }
    }
    
    open class Fonts {
        open static let Default = UIFont(name: "Arial", size: Sizes.Default)
        open static let Header = UIFont(name: "Apoprat", size: Sizes.Larger)
        open static let FirstTimeGuide = UIFont(name: "Apoprat", size: Sizes.FirstTimeGuide)
        open static let LockUI = UIFont(name: "Apoprat", size: Sizes.LockUI)
        open static let Button = UIFont(name: "Apoprat", size: Sizes.Button)
        open static let Badge = UIFont(name: "Arial-BoldMT", size: Sizes.Badge)
        open static let BasketTop = UIFont(name: "Arial", size: Sizes.Basket)
        open static let BasketBottom = UIFont(name: "Arial-BoldMT", size: Sizes.Basket)
        
        open class Sizes {
            open static let Default: CGFloat = 11
            open static let Larger: CGFloat = 23
            open static let FirstTimeGuide: CGFloat = 25
            open static let Button: CGFloat = 20
            open static let Badge: CGFloat = 15
            open static let Basket: CGFloat = 12
            open static let LockUI: CGFloat = 23
        }
    }
    
    open class Colors {
        fileprivate static let White = UIColor.white
        fileprivate static let Black = UIColor.black
        fileprivate static let GrayDark = UIColor(rgba: "#333")
        fileprivate static let Green = UIColor(rgba: "#58b320")
        fileprivate static let GreenLight = UIColor(rgba: "#7ad01f")
        fileprivate static let Blue = UIColor(rgba: "#118695")
        fileprivate static let BlueLight = UIColor(rgba: "#00c7b6")
        fileprivate static let Pink = UIColor(rgba: "#e31ba8")
        fileprivate static let Gray = UIColor(rgba: "#b2b2b2")
        fileprivate static let GrayLight = UIColor(rgba: "#dbdbdb")
        
        fileprivate static let GreenDrawer = UIColor(rgba: "#58b320")
        
        open static let DefaultText = Colors.GrayDark
        open static let DefaultTextOnBlack = Colors.White
        open static let HeaderText = Colors.Black
        open static let HeaderTextOnBlack = Colors.White
        open static let DiscreteTextOnBlack = Colors.GrayDark
        
        open static let DefaultActionText = Colors.White
        open static let DefaultActionTextActive = Colors.White
        
        open static let DefaultAction = Colors.Green
        open static let DefaultActionActive = Colors.GreenLight
        open static let PrimaryAction = Colors.Blue
        open static let PrimaryActionActive = Colors.BlueLight
        open static let PrimaryActionContrast = Colors.Pink
        open static let DiscreteAction = Colors.Gray
        open static let DiscreteActionActive = Colors.GrayLight
        
        open static let LockUI = Colors.White
        
        open static let ProgressTrack = Colors.White
        open static let ProgressDownloaded = Colors.DefaultAction
        
        open static let Drawer = Colors.GreenDrawer
        open static let DrawerBackground = Colors.White
        open static let DrawerBackgroundHighlighted = Colors.GrayLight
        
        open static let TopSeparator = Colors.Gray
    }
}
