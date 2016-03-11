//
//  ZhuceViewController.m
//  LoveFood
//
//  Created by SCJY on 16/2/2.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ZhuceViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <BmobSDK/Bmob.h>
#import "InfomationViewController.h"
@interface ZhuceViewController ()
@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UITextField *secret;
@property (weak, nonatomic) IBOutlet UITextField *email;
@property (weak, nonatomic) IBOutlet UITextField *mima;
@property (weak, nonatomic) IBOutlet UITextField *secondmima;


@end

@implementation ZhuceViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    [self showBackBtn];
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];
    // Do any additional setup after loading the view.
}
- (IBAction)zhuce:(id)sender {
    if (self.mima.text == nil || self.secondmima.text == nil ||![self.mima.text isEqualToString:self.secondmima.text] || [self.mima.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空以及两次密码必须填写一致" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", nil];
        [alert show];
    }else{
    
    
        [BmobUser signOrLoginInbackgroundWithMobilePhoneNumber:self.phoneNum.text SMSCode:self.secret.text andPassword:self.mima.text block:^(BmobUser *user, NSError *error) {
            if (!error) {
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
                [alert show];
                [self.navigationController popViewControllerAnimated:YES];
                

            }else{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:[NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];

            }
        }];
        }
    }
- (IBAction)getSecret:(id)sender {
    [BmobSMS requestSMSCodeInBackgroundWithPhoneNumber:self.phoneNum.text andTemplate:@"验证码" resultBlock:^(int number, NSError *error) {
        if (!error) {
            NSLog(@"成功");
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
        }else{
            NSLog(@"错误信息:%@", error);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:[NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
        

    }];
    
    
//    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNum.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
//        if (!error) {
//            NSLog(@"成功");
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
//            [alert show];
//        }else{
//            NSLog(@"错误信息:%@", error);
//            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:[NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
//            [alert show];
//            
//        }
//
//    }];

}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.secret resignFirstResponder];
    [self.phoneNum resignFirstResponder];
    [self.email resignFirstResponder];
    [self.mima resignFirstResponder];
    [self.secondmima resignFirstResponder];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
