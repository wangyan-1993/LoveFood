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
@property (weak, nonatomic) IBOutlet UIButton *login;

@property (weak, nonatomic) IBOutlet UIButton *zhuce;
@property (weak, nonatomic) IBOutlet UIButton *forget;

@end

@implementation MoreViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.title = @"更多";
    
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.secret.secureTextEntry = YES;
    self.secret.keyboardType = UIKeyboardTypeNumbersAndPunctuation;
    self.secret.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.name.keyboardType = UIKeyboardTypeEmailAddress;
    self.name.clearButtonMode = UITextFieldViewModeWhileEditing;
    self.login.backgroundColor = [UIColor darkGrayColor];
    self.login.layer.cornerRadius = 5;
    self.login.clipsToBounds = YES;
    
    self.zhuce.backgroundColor = [UIColor darkGrayColor];
    self.zhuce.layer.cornerRadius = 5;
    self.zhuce.clipsToBounds = YES;

    
       
}
- (void)viewWillAppear:(BOOL)animated{
    self.tabBarController.tabBar.hidden = NO;
}
- (IBAction)login:(id)sender {
    
    BmobQuery *query = [BmobQuery queryWithClassName:@"UserInfo"];
    [query findObjectsInBackgroundWithBlock:^(NSArray *array, NSError *error) {
        if (!error) {
            
        for (BmobObject *obj in array) {
            if ([[obj objectForKey:@"phoneNum"] isEqualToString:self.name.text] && [[obj objectForKey:@"code"]isEqualToString:self.secret.text]) {
                AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
                
                delegate.isLogin=YES;
                InfomationViewController *infoVC = [[InfomationViewController alloc]init];
                [self.navigationController pushViewController:infoVC animated:YES];
            }else{
                UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"错误提示" message:@"用户名或密码填写不正确" delegate:self cancelButtonTitle:@"OK" otherButtonTitles:nil, nil];
                [alert show];

            }
        }}else{
            NSLog(@"%@", error);
        }
    }];
    

}
- (IBAction)zhuce:(id)sender {
    
    UIStoryboard *moreStoryBoard = [UIStoryboard storyboardWithName:@"more" bundle:nil];

    ZhuceViewController *zhuce = [moreStoryBoard instantiateViewControllerWithIdentifier:@"zhuce"];
    [self.navigationController pushViewController:zhuce animated:YES];
}
- (IBAction)findSecret:(id)sender {
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
