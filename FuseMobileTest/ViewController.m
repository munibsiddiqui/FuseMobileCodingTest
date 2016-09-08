//
//  ViewController.m
//  FuseMobileTest
//
//  Created by Munib Siddiqui on 9/8/16.
//  Copyright © 2016 Cooperative Computing. All rights reserved.
//

#import "ViewController.h"
#import "NSString+Utility.h"
#import "UIView+Addition.h"
#import "HttpClient.h"
#import "Company.h"

#define kAPIEndpointHost            @"http://%@.fusion-universal.com/api/v1/"
#define kAPIEndpointCompany          (kAPIEndpointHost @"company.json")


@interface ViewController ()<UITextFieldDelegate>{
    
    NSURLSessionDownloadTask *_downloadTask;

}

@property (nonatomic, weak) IBOutlet UITextField *txtFieldCompanyName;
@property (nonatomic, weak) IBOutlet UIImageView *imgViewCompany;

@end

@implementation ViewController

- (void)viewDidLoad {
    
    [super viewDidLoad];
    
    // Do any additional setup after loading the view, typically from a nib.
}


#pragma mark - Local Method

- (void) validationOfText {

    if (![self.txtFieldCompanyName.text isEmpty]) {
        
        [self.view endEditing:YES];
        
        [self requestForCompanyInformation];
        
        
        
    }else{
        
        [self notifyUserForEmptyField];
    
    }
    
}


- (void)notifyUserForEmptyField{
    
    UIAlertController * alert=   [UIAlertController
                                  alertControllerWithTitle:@"Company Name"
                                  message:@"Please provide some company name."
                                  preferredStyle:UIAlertControllerStyleAlert];
    
    [self presentViewController:alert animated:YES completion:^{
        
        dispatch_after(dispatch_time(DISPATCH_TIME_NOW, (int64_t)(0.5 * NSEC_PER_SEC)), dispatch_get_main_queue(), ^{
            
            [alert dismissViewControllerAnimated:YES completion:nil];
            
        });
        
    }];
}


- (void) populateResponseObject:(id)responseObject {
    
    NSError* err = nil;

    Company *companyObject = [[Company alloc]initWithDictionary:responseObject error:&err];

    [self.txtFieldCompanyName setText:companyObject.name];
    [self.txtFieldCompanyName setGreenBorderColor];
    
    // download and set image
    [self requestForDownloadCompanyImage:companyObject.logo];
}

#pragma mark - Http Client Request

- (void) requestForCompanyInformation {
    
    NSString *companyName = [NSString stringWithFormat:kAPIEndpointCompany,[self.txtFieldCompanyName.text stringByStrippingWhitespace]];

    //Get Company Information
    [HttpClient requestWithType:HttpRequestTypePost withBaseUrlString:companyName withUrlString:@"" withParaments:nil progress:^(float progress) {
       
    
    } withSuccess:^(NSURLSessionDataTask *task, id responseObject) {
       

        [self populateResponseObject:responseObject];
    
        
    } withFailure:^(NSURLSessionDataTask *task, NSError *error) {
       
        NSLog(@"%@",error.localizedDescription);
        
        [self.txtFieldCompanyName setRedBorderColor];
        
    
    }];
}


- (void) requestForDownloadCompanyImage :(NSString *) companyImageURL {
    
    NSString *cachesPath = [NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES)lastObject];
    NSURL *fileUrl = [NSURL fileURLWithPath:cachesPath];
   
    _downloadTask = [HttpClient downloadWithURL:companyImageURL savePathURL:fileUrl progress:^(float progress) {
      
        dispatch_async(dispatch_get_main_queue(), ^{
            NSLog(@"%f",progress);
        });
        
    } success:^(NSURLResponse *response, NSURL *filePath) {
        
        NSString *imgFilePath = [filePath path];
        UIImage *img = [UIImage imageWithContentsOfFile:imgFilePath];
        self.imgViewCompany.image = img;
        
    } fail:^(NSError *error) {
        
        NSLog(@"%@",error);
    }];

    [_downloadTask resume];

}


#pragma mark - UITextFieldDelegate

- (BOOL)textFieldShouldBeginEditing:(UITextField *)textField{
    
    [textField setNormalBorderColor];
    
    return YES;
}

- (BOOL)textFieldShouldReturn:(UITextField *)textField {

    [self validationOfText];
    
    return YES;
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

@end
