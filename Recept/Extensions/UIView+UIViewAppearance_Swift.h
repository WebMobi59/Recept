//
//  UIView+UIViewAppearance_Swift.h
//  Recept
//
//  Created by Daniel Lervik on 2015-10-20.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (UIViewAppearance_Swift)

+ (instancetype) appearanceWhenContainedIn_Swift:(Class<UIAppearanceContainer>)containerClass;

@end
