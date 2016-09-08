//
//  Company.h
//  FuseMobileTest
//
//  Created by Munib Siddiqui on 9/8/16.
//  Copyright © 2016 Cooperative Computing. All rights reserved.
//

#import <JSONModel/JSONModel.h>

@interface Company : JSONModel

@property (strong, nonatomic) NSString* name;
@property (strong, nonatomic) NSString* logo;
@property (strong, nonatomic) NSString* custom_color;
@property (assign, nonatomic) BOOL passwordChangingEnabled;
@property (assign, nonatomic) NSString<Optional>* passwordChangingSecureField;

@end
