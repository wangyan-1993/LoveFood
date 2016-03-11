//
//  InfomationViewController.m
//  LoveFood
//
//  Created by SCJY on 16/2/5.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "InfomationViewController.h"
#import <MessageUI/MessageUI.h>
#import "CollectViewController.h"
#import <BmobSDK/Bmob.h>
@interface InfomationViewController ()<UITableViewDataSource, UITableViewDelegate, MFMailComposeViewControllerDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property (nonatomic, strong) NSArray *imageArray;
@property (nonatomic, strong) NSMutableArray *titleArray;
@end

@implementation InfomationViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self setHearderView];
    UIButton *backBtn = [UIButton buttonWithType:UIButtonTypeCustom];
    backBtn.frame = CGRectMake(0, 0, 100, 44);
    [backBtn setTitle:@"取消登录" forState:UIControlStateNormal];
    [backBtn addTarget:self action:@selector(backBtnAction) forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *leftBarBtn = [[UIBarButtonItem alloc]initWithCustomView:backBtn];
    self.navigationItem.leftBarButtonItem = leftBarBtn;
    self.navigationController.navigationBar.barTintColor = kMainColor;
    self.imageArray = @[@"trash", @"man", @"chat", @"mobile", @"heart1"];
    self.titleArray = [NSMutableArray arrayWithObjects:@"清除缓存", @"用户反馈", @"给我评分", @"当前版本 1.0", @"我的收藏", nil];
}

- (void)backBtnAction{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    [BmobUser logout];
    delegate.isLogin=NO;
    [self.navigationController popToRootViewControllerAnimated:YES];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
    SDImageCache *cache = [SDImageCache sharedImageCache];
    NSInteger cacheSize = [cache getSize];
    NSString *cacheStr = [NSString stringWithFormat:@"清除图片缓存(%.2fM)", (CGFloat)cacheSize / 1024 / 1024];
    [self.titleArray replaceObjectAtIndex:0 withObject:cacheStr];
    NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
    [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
    
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 5;
}


- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    static NSString *str = @"mine";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
    if (cell == nil) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleValue1 reuseIdentifier:str];
    }
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.imageView.image = [UIImage imageNamed:self.imageArray[indexPath.row]];
    cell.textLabel.text = self.titleArray[indexPath.row];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;

}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    switch (indexPath.row) {
        case 0:
        {//清除缓存
            SDImageCache *cache = [SDImageCache sharedImageCache];
            [cache clearDisk];
            [self.titleArray replaceObjectAtIndex:0 withObject:@"清除缓存"];
            NSIndexPath *index = [NSIndexPath indexPathForRow:0 inSection:0];
            [self.tableView reloadRowsAtIndexPaths:@[index] withRowAnimation:UITableViewRowAnimationAutomatic];
            
        }
            break;
        case 1:
        {//发送邮件
            [self sendEmail];
        }
            break;
        
        case 2:
        {
            NSString *str = [NSString stringWithFormat:@"itms-apps://itunes.apple.com/app"];
            [[UIApplication sharedApplication] openURL:[NSURL URLWithString:str]];
        }
            break;
        case 3:
        {
            //检测当前版本
            [ProgressHUD show:@"正在检测最新版本..."];
            [self performSelector:@selector(checkAppVersion) withObject:nil afterDelay:2.0];
        }
            
            break;
         case 4:
        {
            CollectViewController *collect = [[CollectViewController alloc]init];
            [self.navigationController pushViewController:collect animated:YES];
        }
            break;
        default:
            break;
    }
    
}
- (void)checkAppVersion{
    [ProgressHUD showSuccess:@"恭喜你已经是最新版本"];
}

- (void)sendEmail{
    Class mailClass = NSClassFromString(@"MFMailComposeViewController");
    if (mailClass != nil) {
        if ([MFMailComposeViewController canSendMail]) {
            
            
            //初始化发送邮件
            MFMailComposeViewController *picker = [[MFMailComposeViewController alloc]init];
            //设置代理
            picker.mailComposeDelegate = self;
            //设置主题
            [picker setSubject:@"用户反馈"];
            //设置收件人
            NSArray *toPicker = [NSArray arrayWithObjects:@"843668546@qq.com", nil];
            [picker setToRecipients:toPicker];
            
            //设置发送内容
            NSString *text = @"请留下您宝贵的意见";
            [picker setMessageBody:text isHTML:NO];
            [self presentModalViewController:picker animated:YES];
        }else{
            NSLog(@"未配置邮箱账号");
        }
    }else{
        NSLog(@"当前设备不能发送");
    }
}
- (void)mailComposeController:(MFMailComposeViewController *)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError *)error{
    switch (result)
    {
        case MFMailComposeResultCancelled: //取消
            NSLog(@"MFMailComposeResultCancelled-取消");
            break;
        case MFMailComposeResultSaved: // 保存
            NSLog(@"MFMailComposeResultSaved-保存邮件");
            break;
        case MFMailComposeResultSent: // 发送
            NSLog(@"MFMailComposeResultSent-发送邮件");
            break;
        case MFMailComposeResultFailed: // 尝试保存或发送邮件失败
            NSLog(@"MFMailComposeResultFailed: %@...",[error localizedDescription]);
            break;
    }
    
    // 关闭邮件发送视图
    [self dismissViewControllerAnimated:YES completion:nil];
    
}


- (void)setHearderView{
    UIView *view = [[UIView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 150)];
    view.backgroundColor = kBackColor;
    UIImageView *imageview = [[UIImageView alloc]initWithFrame:CGRectMake(10, 10, 130, 130)];
    imageview.image =[UIImage imageNamed:@"head"];
    imageview.layer.cornerRadius = 65;
    imageview.clipsToBounds = YES;
    [view addSubview:imageview];
    UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(170, 65, kWidth/3+20, 20)];
    label.text = @"  欢迎来到 i吃货";
    label.backgroundColor = kMainColor;
    label.layer.cornerRadius = 10;
    label.clipsToBounds = YES;
    [view addSubview:label];
    self.tableView.tableHeaderView = view;
    
}

- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeigth)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 55;
        [self.view addSubview:self.tableView];
    }
    return _tableView;
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
