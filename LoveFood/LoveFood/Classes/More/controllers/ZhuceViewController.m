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
    
    // Do any additional setup after loading the view.
}
- (IBAction)zhuce:(id)sender {
    if (self.mima.text == nil || self.secondmima.text == nil ||![self.mima.text isEqualToString:self.secondmima.text]) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空以及两次密码必须填写一致" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", nil];
        [alert show];
    }else{
    
    
    [SMSSDK commitVerificationCode:self.secret.text phoneNumber:self.phoneNum.text zone:@"86" result:^(NSError *error) {
        if (!error) {
        NSLog(@"注册成功");
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"注册成功" delegate:self cancelButtonTitle:nil otherButtonTitles:@"OK", nil];
            [alert show];
            BmobObject *userInfo = [BmobObject objectWithClassName:@"UserInfo"];
            [userInfo setObject:self.phoneNum.text forKey:@"phoneNum"];
            [userInfo setObject:self.email.text forKey:@"email"];
            [userInfo setObject:self.mima.text forKey:@"code"];
           
            [userInfo saveInBackgroundWithResultBlock:^(BOOL isSuccessful, NSError *error) {
                //进行操作
                 userInfo.objectId = self.phoneNum.text;
                NSLog(@"添加成功");
            }];
            NSLog(@"%@", userInfo.objectId);
            InfomationViewController *infoVC = [[InfomationViewController alloc]init];
            [self.navigationController pushViewController:infoVC animated:YES];
            
        }else{
             NSLog(@"错误信息:%@", error);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:[NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];

        }
    }];
    }
    }
- (IBAction)getSecret:(id)sender {
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNum.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
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
