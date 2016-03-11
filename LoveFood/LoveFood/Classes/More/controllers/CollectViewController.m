//
//  CollectViewController.m
//  LoveFood
//
//  Created by SCJY on 16/3/6.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "CollectViewController.h"
#import "ListTableViewCell.h"
#import "DataBaseManager.h"
#import "Collect.h"
#import "ListModel.h"
#import "DetailsViewController.h"
#import "ListModel.h"
#import <BmobSDK/Bmob.h>
@interface CollectViewController ()<UITableViewDataSource, UITableViewDelegate>
@property(nonatomic, strong) UITableView *tableView;
@property(nonatomic, strong) NSMutableArray *modelArray;
@end

@implementation CollectViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    [self showBackBtn];
    self.title = @"我的收藏";
    [self.tableView registerNib:[UINib nibWithNibName:@"ListTableViewCell" bundle:nil] forCellReuseIdentifier:@"list"];
DataBaseManager *dbManager = [DataBaseManager shareInatance];
    dbManager.name = [BmobUser getCurrentUser].username;
    NSMutableArray *array = [NSMutableArray new];
array = [dbManager selectAllCollect];
    
    for (Collect *collect in array) {
        ListModel *model = [[ListModel alloc]initWithDictionary:collect.dict];
        [self.modelArray addObject:model];
    }
    [self.view addSubview:self.tableView];
}
- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:animated];
    if (self.modelArray.count > 0) {
        [self.modelArray removeAllObjects];
    }
    self.tabBarController.tabBar.hidden = YES;
    DataBaseManager *dbManager = [DataBaseManager shareInatance];
    dbManager.name = [BmobUser getCurrentUser].username;

    NSMutableArray *array = [NSMutableArray new];
    array = [dbManager selectAllCollect];
    
    for (Collect *collect in array) {
        ListModel *model = [[ListModel alloc]initWithDictionary:collect.dict];
        [self.modelArray addObject:model];
    }

    [self.tableView reloadData];
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   
    ListTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"list" forIndexPath:indexPath];
    
    cell.model = self.modelArray[indexPath.row];
    return cell;
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsViewController *detailsVC = [[DetailsViewController alloc]init];
    ListModel *model = self.modelArray[indexPath.row];
    detailsVC.idDetails = model.idList;
    detailsVC.navigationItem.title = model.name;
    [self.navigationController pushViewController:detailsVC animated:YES];
}
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:self.view.frame];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
        self.tableView.rowHeight = 86;

    }
    return _tableView;
}
- (NSMutableArray *)modelArray{
    if (_modelArray == nil) {
        self.modelArray = [NSMutableArray new];
    }
    return _modelArray;
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
