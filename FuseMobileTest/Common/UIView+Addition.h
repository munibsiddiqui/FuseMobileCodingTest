//
//  UIView+Addition.h
//  FuseMobileTest
//
//  Created by Munib Siddiqui on 9/8/16.
//  Copyright © 2016 Cooperative Computing. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIView (Addition)

- (void)setBorderForColor:(UIColor *)color
                    width:(float)width
                   radius:(float)radius;

- (void) setRedBorderColor;
- (void) setGreenBorderColor;
- (void) setNormalBorderColor;

@end
