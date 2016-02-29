//
//  MoreViewController.m
//  
//
//  Created by SCJY on 16/1/18.
//
//

#import "MoreViewController.h"
#import "ZhuceViewController.h"
#import "ForgetCodeViewController.h"
#import "InfomationViewController.h"
#import <BmobSDK/Bmob.h>
@interface MoreViewController ()
@property (weak, nonatomic) IBOutlet UITextField *name;
@property (weak, nonatomic) IBOutlet UITextField *secret;
@property(nonatomic, strong) UIButton *loginBtn;
@property(nonatomic, strong) UIButton *zhuceBtn;
@property(nonatomic, strong) UIButton *forgetBtn;
@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多";
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.secret.secureTextEntry = YES;
    self.secret.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.secret.clearButtonMode = UITextFieldViewModeUnlessEditing;
    self.name.keyboardType = UIKeyboardTypeEmailAddress;
    self.name.clearButtonMode = UITextFieldViewModeUnlessEditing;
    self.loginBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.loginBtn.frame = CGRectMake(kWidth/10*2, 240, kWidth/10+10, 30);
    self.loginBtn.backgroundColor = [UIColor lightGrayColor];
    self.loginBtn.layer.cornerRadius = 5;
    self.loginBtn.clipsToBounds = YES;
    [self.loginBtn setTitle:@"登录" forState:UIControlStateNormal];
    [self.loginBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(loginButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.loginBtn];
    self.zhuceBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.zhuceBtn.frame = CGRectMake(kWidth/10*4, 240, kWidth/10+10, 30);
    self.zhuceBtn.backgroundColor = [UIColor lightGrayColor];
    self.zhuceBtn.layer.cornerRadius = 5;
    self.zhuceBtn.clipsToBounds = YES;
    [self.zhuceBtn setTitle:@"注册" forState:UIControlStateNormal];
    [self.zhuceBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.loginBtn addTarget:self action:@selector(zhuceButton) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:self.zhuceBtn];
    
    self.forgetBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    self.forgetBtn.frame = CGRectMake(kWidth/10*6, 240, kWidth/10*2+10, 30);
    
    self.forgetBtn.backgroundColor = [UIColor lightGrayColor];
    self.forgetBtn.layer.cornerRadius = 5;
    self.forgetBtn.clipsToBounds = YES;
    [self.forgetBtn setTitle:@"忘记密码" forState:UIControlStateNormal];
    [self.forgetBtn setTitleColor:kMainColor forState:UIControlStateNormal];
    [self.forgetBtn addTarget:self action:@selector(forgetButton) forControlEvents:UIControlEventTouchUpInside];
[self.view addSubview:self.forgetBtn];
}
- (void)loginButton{
    BmobQuery *query = [BmobQuery queryWithClassName:@"UserInfo"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            
            for (BmobObject *obj in array) {
                if ([[obj objectForKey:@"phoneNum"] isEqualToString:self.name.text] && [[obj objectForKey:@"code"]isEqualToString:self.secret.text]) {
                    InfomationViewController *infoVC = [[InfomationViewController alloc]init];
                    [self.navigationController pushViewController:infoVC animated:YES];
                    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                    
                    delegate.isLogin=YES;
                }else{
                    UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"用户名或密码填写不正确" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                    [alert show];
                    
                }
            }}else{
                NSLog(@"%@", error);
            }
    }];
    

}
- (void)zhuceButton{
    UIStoryboard *moreStoryBoard = [UIStoryboard storyboardWithName:@"more" bundle:nil];
    
    ZhuceViewController *zhuce = [moreStoryBoard instantiateViewControllerWithIdentifier:@"zhuce"];
    [self.navigationController pushViewController:zhuce animated:YES];
}
- (void)forgetButton{
    UIStoryboard *moreStoryBoard = [UIStoryboard storyboardWithName:@"more" bundle:nil];
    
    ForgetCodeViewController *forget = [moreStoryBoard instantiateViewControllerWithIdentifier:@"forget"];
    [self.navigationController pushViewController:forget animated:YES];
}
- (void)touchesBegan:(NSSet<UITouch *> *)touches withEvent:(UIEvent *)event{
    [self.secret resignFirstResponder];
    [self.name resignFirstResponder];
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
