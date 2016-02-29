//
//  FindViewController.m
//  LoveFood
//
//  Created by SCJY on 16/1/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "FindViewController.h"
#import "FindModel.h"
#import "FindTableViewCell.h"
#import "ListViewController.h"
#import "MoreViewController.h"
@interface FindViewController ()<UITableViewDataSource, UITableViewDelegate, UISearchBarDelegate, UIAlertViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *array;
@property(nonatomic, strong) UISearchBar *mySearchBar;
@property(nonatomic, strong) UIView *blackView;

@end

@implementation FindViewController


- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"FindTableViewCell" bundle:nil] forCellReuseIdentifier:@"find"];
    self.tableView.rowHeight = 50;
    
    self.mySearchBar = [[UISearchBar alloc] initWithFrame:CGRectMake(0.0, 0.0, kWidth, 40)];
    self.mySearchBar.delegate = self;
    self.tableView.tableHeaderView = self.mySearchBar;
    self.mySearchBar.autocorrectionType = UITextAutocorrectionTypeNo;
    self.mySearchBar.autocapitalizationType = UITextAutocapitalizationTypeNone;
    self.mySearchBar.placeholder = @"搜索菜谱";
    [self.view addSubview:self.tableView];
    [self configData];
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    
    delegate.isLogin=NO;
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}



- (void)configData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *url = kFirstData;
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
       // NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@", responseObject);
        NSDictionary *dic = responseObject;
        NSDictionary *xiaDic = dic[@"xiachufang"];
        NSString *status = xiaDic[@"@status"];
        if ([status isEqualToString:@"ok"]) {
            NSArray *topkeywordArray = xiaDic[@"topkeyword"];
            for (NSDictionary *dict in topkeywordArray) {
                FindModel *model = [[FindModel alloc]initWithDictionary:dict];
                [self.array addObject:model];
            }
        }
        [self.tableView reloadData];
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"登陆后会有更多惊喜呦 >_<" delegate:self cancelButtonTitle:@"暂不登录" otherButtonTitles:@"立即登录", nil];
        [alert show];

        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

}
#pragma mark---UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.tabBarController.selectedIndex = 2;
    }
   
}
#pragma mark---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.array.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FindTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"find" forIndexPath:indexPath];
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.selectionStyle = UITableViewCellSelectionStyleNone;
    cell.model = self.array[indexPath.row];
    cell.numLabel.text = [NSString stringWithFormat:@"%ld", indexPath.row + 1];
    return cell;
}
#pragma msrk---UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    ListViewController *listVC = [[ListViewController alloc]init];
    FindModel *model = self.array[indexPath.row];
    listVC.navigationItem.title = model.keyword;
    listVC.name = model.keyword;
    [self.navigationController pushViewController:listVC animated:YES];
}

#pragma mark---懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeigth)];
        self.tableView.dataSource = self;
        self.tableView.delegate = self;
    }
    return _tableView;
}

- (NSMutableArray *)array{
    if (_array == nil) {
        self.array = [NSMutableArray new];
    }
    return _array;
}

#pragma mark---UISearchBarDelegate
- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar{
    [self.mySearchBar setShowsCancelButton:YES animated:YES];
    
        self.blackView = [[UIView alloc]initWithFrame:CGRectMake(0, 104, kWidth, kHeigth)];
        [self.blackView setBackgroundColor:[UIColor blackColor]];
        self.blackView.alpha = 0.5;
        [self.view addSubview:self.blackView];
    
    NSLog(@"搜索Begin");
    return YES;
}
- (BOOL)searchBarShouldEndEditing:(UISearchBar *)searchBar{
    NSLog(@"搜索End");
    return YES;
}
- (void)searchBarCancelButtonClicked:(UISearchBar *)searchBar{
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.blackView.hidden = YES;
}


- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar{
    ListViewController *listVC = [[ListViewController alloc]init];
       listVC.navigationItem.title = searchBar.text;
    listVC.name = searchBar.text;
    [self.navigationController pushViewController:listVC animated:YES];
    [searchBar resignFirstResponder];
    [searchBar setShowsCancelButton:NO animated:YES];
    self.blackView.hidden = YES;
    searchBar.text = nil;
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
