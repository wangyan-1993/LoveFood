//
//  ListViewController.m
//  LoveFood
//
//  Created by SCJY on 16/1/19.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "ListViewController.h"
#import "PullingRefreshTableView.h"
#import "ListModel.h"
#import "ListTableViewCell.h"
@interface ListViewController ()<UITableViewDataSource, UITableViewDelegate, PullingRefreshTableViewDelegate>
{
    NSInteger _pageCount;
}
@property(nonatomic, strong) NSMutableArray *arrayModel;
@property(nonatomic, strong) PullingRefreshTableView *tableView;
@property(nonatomic, assign) BOOL refreshing;

@end

@implementation ListViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    self.tabBarController.tabBar.hidden = YES;
    [self showBackBtn];
    [self configData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"list"];

    [self.view addSubview:self.tableView];
    [self.tableView launchRefreshing];
    
}
#pragma mark---解析数据
- (void)configData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *string = [NSString stringWithFormat:@"%@%@&offset=%lu", kListData, self.name, _pageCount * 9];
    NSString *url = [string stringByAddingPercentEscapesUsingEncoding:NSUTF8StringEncoding];
    [manager GET:url parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        // NSLog(@"%@", downloadProgress);
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@", responseObject);
        NSDictionary *dictionary = responseObject;
        NSDictionary *dict = dictionary[@"xiachufang"];
        NSString *status = dict[@"@status"];
        if ([status isEqualToString:@"ok"]) {
            NSDictionary *dic = dict[@"results"];
            NSString *str = dic[@"recipe_ids"];
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
   // NSLog(@"+++%@", responseObject);
        
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

#pragma mark---UITableViewDataSource
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.arrayModel.count;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
     //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.model = self.arrayModel[indexPath.row];
    return cell;
}


#pragma mark---UITableViewDelegate

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
        self.tableView = [[PullingRefreshTableView alloc]initWithFrame:CGRectMake(0, 64, kWidth, kHeigth - 64) pullingDelegate:self];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 86;
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
