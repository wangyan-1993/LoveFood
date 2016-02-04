//
//  FavoriteViewController.m
//  LoveFood
//
//  Created by SCJY on 16/1/18.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "FavoriteViewController.h"
#import "ListModel.h"
#import "FavoriteTableViewCell.h"
#import "PullingRefreshTableView.h"
#import "DetailsViewController.h"
@interface FavoriteViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property(nonatomic, strong) NSMutableArray *arrayModel;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, assign) BOOL refreshing;

@end

@implementation FavoriteViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.navigationController.navigationBar.barTintColor = kMainColor;
    [self.tableView registerNib:[UINib nibWithNibName:@"FavoriteTableViewCell" bundle:nil] forCellReuseIdentifier:@"favorite"];
    //[self configData];
    [self.view addSubview:self.tableView];
    [self.tableView launchRefreshing];

}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    self.tabBarController.tabBar.hidden = NO;
}



#pragma mark---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    FavoriteTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"favorite" forIndexPath:indexPath];
    
   cell.model = self.arrayModel[indexPath.row];
    return cell;
}


#pragma mark---UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *detailsVC = [[DetailsViewController alloc]init];
    ListModel *model = self.arrayModel[indexPath.row];
    detailsVC.idDetails = model.idList;
    detailsVC.navigationItem.title = model.name;

    [self.navigationController pushViewController:detailsVC animated:YES];
}
#pragma mark---PullingRefreshTableViewDelegate
- (void)pullingTableViewDidStartRefreshing:(PullingRefreshTableView *)tableView{
    _pageCount = 0;
    self.refreshing = YES;
    [self performSelector:@selector(configData) withObject:nil afterDelay:1.0];
}
- (void)pullingTableViewDidStartLoading:(PullingRefreshTableView *)tableView{
    _pageCount += 1;
    self.refreshing = NO;
    [self performSelector:@selector(configData) withObject:nil afterDelay:1.0];
    
}

- (void)configData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *string = [NSString stringWithFormat:@"%@%lu", kFavoriteData,  _pageCount * 9];
    [manager GET:string parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"+++%@", responseObject);
        
        NSDictionary *dictionary = responseObject;
        NSDictionary *dict = dictionary[@"xiachufang"];
        NSString *status = dict[@"@status"];
        if ([status isEqualToString:@"ok"]) {
            NSString *str = dict[@"recipe_ids"];
            str = [str stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
            [self configDataWithString:str];
        
        }
      } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
}
- (void)configDataWithString:(NSString *)string{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *str = [NSString stringWithFormat:@"%@%@", kTwoListData, string];
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        //NSLog(@"%@",downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"+++%@", responseObject);
        [ProgressHUD showSuccess:@"美食已烹调完毕，请食用"];
        NSDictionary *dictionary = responseObject;
        NSDictionary *dict = dictionary[@"xiachufang"];
        NSString *status = dict[@"@status"];
        if ([status isEqualToString:@"ok"]) {
            if (self.refreshing) {
                if (self.arrayModel.count > 0) {
                    [self.arrayModel removeAllObjects];
                }
            }
             NSArray *array = dict[@"recipe"];
            for (NSDictionary *dic in array) {
                ListModel *model = [[ListModel alloc]initWithDictionary:dic];
                [self.arrayModel addObject:model];
                
            }
        }
        [self.tableView reloadData];
        
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    [self.tableView tableViewDidFinishedLoading];
    self.tableView.reachedTheEnd = NO;

}
#pragma mark - ScrollView Method
//手指开始拖动方法
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    [self.tableView tableViewDidScroll:scrollView];
}

//手指结束拖动方法
- (void)scrollViewDidEndDragging:(UIScrollView *)scrollView willDecelerate:(BOOL)decelerate
{
    [self.tableView tableViewDidEndDragging:scrollView];
}



#pragma mark---懒加载
- (PullingRefreshTableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeigth - 64 - 44) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 300;
    }
    return _tableView;
}

- (NSMutableArray *)arrayModel{
    if (_arrayModel == nil) {
        self.arrayModel = [NSMutableArray new];
    }
    return _arrayModel;
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
