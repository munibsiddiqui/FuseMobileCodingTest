//
//  Company.m
//  FuseMobileTest
//
//  Created by Munib Siddiqui on 9/8/16.
//  Copyright © 2016 Cooperative Computing. All rights reserved.
//

#import "Company.h"

@implementation Company


+(JSONKeyMapper*)keyMapper
{
    return [[JSONKeyMapper alloc] initWithModelToJSONDictionary:@{
                                                                  @"passwordChangingEnabled":
                                                                      @"password_changing.enabled",
                                                                  @"passwordChangingSecureField": @"password_changing.secure_field"
                                                                  }];
}
@end
