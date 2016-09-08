//
//  UIView+Addition.m
//  FuseMobileTest
//
//  Created by Munib Siddiqui on 9/8/16.
//  Copyright © 2016 Cooperative Computing. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

- (void)setBorderForColor:(UIColor *)color
                    width:(float)width
                   radius:(float)radius
{
    self.layer.cornerRadius = radius;
    self.layer.masksToBounds = YES;
    self.layer.borderColor = [color CGColor];
    self.layer.borderWidth = width;
}

// set textfield border color to red on failure
- (void) setRedBorderColor {
    
    [self setBorderForColor:[UIColor redColor] width:1 radius:0];
    
}

// set textfield border color to green on success
- (void) setGreenBorderColor {
    
    [self setBorderForColor:[UIColor greenColor] width:1 radius:0];
    
}

// set textfield border color to black normal state

- (void) setNormalBorderColor {
    
    [self setBorderForColor:[UIColor blackColor] width:1 radius:0];

}

@end
