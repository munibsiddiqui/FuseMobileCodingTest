//
//  UIView+Addition.m
//  FuseMobileTest
//
//  Created by Munib Siddiqui on 9/8/16.
//  Copyright © 2016 Cooperative Computing. All rights reserved.
//

#import "UIView+Addition.h"

@implementation UIView (Addition)

// set textfield border color to red on failure
- (void) setRedBorderColor {
    
    [self setBackgroundColor:[UIColor redColor]];
    
}

// set textfield border color to green on success
- (void) setGreenBorderColor {
    
    [self setBackgroundColor:[UIColor greenColor]];
    
}

// set textfield border color to black normal state

- (void) setNormalBorderColor {
    
    [self setBackgroundColor:[UIColor whiteColor]];

}

@end
