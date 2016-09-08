//
//  NSString+Utility.m
//  FuseMobileTest
//
//  Created by Munib Siddiqui on 9/8/16.
//  Copyright © 2016 Cooperative Computing. All rights reserved.
//

#import "NSString+Utility.h"

@implementation NSString (Utility)

- (BOOL) isEmpty {
    
    if([[self stringByStrippingWhitespace] isEqualToString:@""])
        return YES;
    return NO;
}

- (NSString *) stringByStrippingWhitespace {
    return [self stringByReplacingOccurrencesOfString:@" " withString:@""];
}


@end
