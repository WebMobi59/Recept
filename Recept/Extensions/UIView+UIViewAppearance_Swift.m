//
//  UIView+UIViewAppearance_Swift.m
//  Recept
//
//  Created by Daniel Lervik on 2015-10-20.
//  Copyright © 2015 Apoteket AB. All rights reserved.
//

#import "UIView+UIViewAppearance_Swift.h"

@implementation UIView (UIViewAppearance_Swift)

+ (instancetype)appearanceWhenContainedIn_Swift:(Class<UIAppearanceContainer>)containerClass {
    return [self appearanceWhenContainedIn:containerClass, nil];
}

@end
