//
//  ForgetCodeViewController.m
//  LoveFood
//
//  Created by SCJY on 16/2/5.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ForgetCodeViewController.h"
#import <SMS_SDK/SMSSDK.h>
#import <BmobSDK/Bmob.h>
#import "InfomationViewController.h"
@interface ForgetCodeViewController ()

@property (weak, nonatomic) IBOutlet UITextField *phoneNum;
@property (weak, nonatomic) IBOutlet UIButton *getSecret;
@property (weak, nonatomic) IBOutlet UITextField *code;
@property (weak, nonatomic) IBOutlet UITextField *secondCode;

@property (weak, nonatomic) IBOutlet UITextField *secret;

@end

@implementation ForgetCodeViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.view.backgroundColor = [UIColor colorWithRed:0.7 green:0.7 blue:0.7 alpha:0.3];

    [self showBackBtn];
    
}
- (IBAction)getSecret:(id)sender {
    [SMSSDK getVerificationCodeByMethod:SMSGetCodeMethodSMS phoneNumber:self.phoneNum.text zone:@"86" customIdentifier:nil result:^(NSError *error) {
        if (!error) {
            NSLog(@"发送成功");
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"发送验证码成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
        }else{
            NSLog(@"错误信息:%@", error);
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:[NSString stringWithFormat:@"%@", error] delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
        }
    }];
    

    
}
- (IBAction)done:(id)sender {
    if (self.code.text == nil || self.secondCode.text == nil ||![self.code.text isEqualToString:self.secondCode.text] || [self.code.text stringByReplacingOccurrencesOfString:@" " withString:@""].length <= 0) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码不能为空以及两次密码必须填写一致" delegate:self cancelButtonTitle:nil otherButtonTitles:@"取消", nil];
        [alert show];
    }else{
        

    
    
    [SMSSDK commitVerificationCode:self.secret.text phoneNumber:self.phoneNum.text zone:@"86" result:^(NSError *error) {
        if (!error) {
            NSLog(@"密码修改成功");
            UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改成功" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
            [alert show];
            
            BmobQuery *query = [BmobQuery queryWithClassName:@"UserInfo"];
            [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
                if (!error) {
                    
                    for (BmobObject *obj in array) {
                        if ([[obj objectForKey:@"phoneNum"] isEqualToString:self.phoneNum.text]) {
                            [obj setObject:self.code.text forKey:@"code"];
                            [obj updateInBackground];
                        }
                    }}else{
                        NSLog(@"%@", error);
                        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"提示" message:@"密码修改失败" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                        [alert show];
                    }
            }];
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
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.phoneNum resignFirstResponder];
    [self.code resignFirstResponder];
    [self.secondCode resignFirstResponder];
    [self.secret resignFirstResponder];
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
