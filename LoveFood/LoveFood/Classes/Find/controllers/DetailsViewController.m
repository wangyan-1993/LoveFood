//
//  DetailsViewController.m
//  LoveFood
//
//  Created by SCJY on 16/1/22.
//  Copyright © 2016年 SCJY. All rights reserved.
//

#import "DetailsViewController.h"
#import "DetailsTableViewCell.h"
#import "DetailsModel.h"
@interface DetailsViewController ()<UITableViewDataSource, UITableViewDelegate>
{
    NSInteger i;
}
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *modelArray;
@end

@implementation DetailsViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
 
    self.tabBarController.tabBar.hidden = YES;
    [self showBackBtn];
    [self configData];
    
    [self.tableView registerNib:[UINib nibWithNibName:@"DetailsTableViewCell" bundle:nil] forCellReuseIdentifier:@"Details"];

    [self.view addSubview:self.tableView];
    
}
- (void)configData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *str = [NSString stringWithFormat:@"%@%@", kDetailsData, self.idDetails];
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
       // NSLog(@"%@", responseObject );
        NSDictionary *dic = responseObject;
        [self configTableViewWithDic:dic];
        [self.tableView reloadData];

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
}
- (void)configTableViewWithDic:(NSDictionary *)dic{
    NSDictionary *xiachufangDic = dic[@"xiachufang"];
    NSString *status = xiachufangDic[@"@status"];
    if ([status isEqualToString:@"ok"]) {
        NSDictionary *dict = xiachufangDic[@"recipe"];
        NSArray *ingredientArray = dict[@"ingredient"];
        NSArray *instructionArray = dict[@"instruction"];
        for (NSDictionary *dic in instructionArray) {
            DetailsModel *model = [[DetailsModel alloc]initWithDictionary:dic];
            [self.modelArray addObject:model];
        }
        UIView *headerView = [[UIView alloc]init];
        UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(0, 0, kWidth, 220)];
        [image sd_setImageWithURL:[NSURL URLWithString:dict[@"photo"]] placeholderImage:nil];
                 CGFloat labelHeight = [HWTools getTextHeightWithText: dict[@"summary"]
                                                  bigestSize:CGSizeMake(365, 1000) font:15.0];
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(5, 220 , 365, 10+ labelHeight + 20)];
        view1.backgroundColor = kBackColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, 365, labelHeight)];
        
        label.font = [UIFont systemFontOfSize:15.0];
    label.text = dict[@"summary"];
        label.numberOfLines = 0;
       
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, labelHeight + 10, 150, 20)];
        nameLabel.text = dict[@"author"][@"name"];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.font = [UIFont systemFontOfSize:14];
        UILabel *doneLabel = [[UILabel alloc]initWithFrame:CGRectMake(220, labelHeight + 10, kWidth - 220 - 5, 20)];
        doneLabel.text = [NSString stringWithFormat:@"%@做过 %@收藏", dict[@"stats"][@"n_cooked"], dict[@"stats"][@"n_collects"]];
        doneLabel.font = [UIFont systemFontOfSize:14];
        doneLabel.textColor = [UIColor orangeColor];
        
        UILabel *yongliaoLabel = [[UILabel alloc]initWithFrame:CGRectMake(15, 250+labelHeight + 5, 100, 20)];
        yongliaoLabel.text = @"用料&做法";
        yongliaoLabel.font = [UIFont systemFontOfSize:15];
        [view1 addSubview:label];
        [view1 addSubview:nameLabel];
        [view1 addSubview:doneLabel];
        [headerView addSubview:view1];
        [headerView addSubview:yongliaoLabel];
        [headerView addSubview:image];
        for (i = 0; i < ingredientArray.count; i++) {
            NSDictionary *dictionary = ingredientArray[i];
            UIView *peiliaoLabel = [[UIView alloc]init];
            peiliaoLabel.backgroundColor = kBackColor;
            if (i % 2 == 0) {
               peiliaoLabel.frame = CGRectMake(5 , 280+labelHeight + 52 * i / 2 , 182, 50);
            }else{
                peiliaoLabel.frame = CGRectMake(188, 280+labelHeight + 52 * i / 2 - 26 , 182, 50);
            }
             UILabel *name = [[UILabel alloc]initWithFrame:CGRectMake(0, 0, peiliaoLabel.frame.size.width / 4 * 3, 50)];
            name.text = dictionary[@"name"];
            UILabel *height = [[UILabel alloc]initWithFrame:CGRectMake(peiliaoLabel.frame.size.width / 4 * 3, 0, peiliaoLabel.frame.size.width / 4 , 50)];
            height.text = dictionary[@"amount"];
            height.font = [UIFont systemFontOfSize:15];
            [peiliaoLabel addSubview:name];
            [peiliaoLabel addSubview:height];
           
           
            [headerView addSubview:peiliaoLabel];
        }
        
        if (i%2 == 0) {
            headerView.frame = CGRectMake(0, 0, kWidth, 280 +labelHeight + 52 * i / 2);
        }else{
            headerView.frame = CGRectMake(0, 0, kWidth, 280 + labelHeight + 52 * (i / 2 + 1));
        }
self.tableView.tableHeaderView = headerView;
    
        if (![dict[@"tips"] isEqualToString:@""]) {
            UIView *footView = [[UIView alloc]init];
            UILabel *xiaotieshi = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, kWidth - 30, 10)];
            xiaotieshi.text = @"小贴士";
            CGFloat tipsHeight = [HWTools getTextHeightWithText:dict[@"tips"] bigestSize:CGSizeMake(365, 1000) font:15.0];
            UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(5, 20, 365, tipsHeight + 10)];
            view2.backgroundColor = kBackColor;
            UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, 365, tipsHeight)];
            tipsLabel.text = dict[@"tips"];
            tipsLabel.numberOfLines = 0;
            tipsLabel.font = [UIFont systemFontOfSize:15.0];
            [view2 addSubview:tipsLabel];
            footView.frame = CGRectMake(0, 0, kWidth, 30 + tipsHeight);
            
            [footView addSubview:xiaotieshi];
            [footView addSubview:view2];
            self.tableView.tableFooterView = footView;
            

        }
        
           }

}
#pragma mark---UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
   DetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Details" forIndexPath:indexPath];
    cell.model = self.modelArray[indexPath.row];
    cell.backgroundColor = kBackColor;
    return cell;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
    
}

#pragma mark---UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsModel *model = self.modelArray[indexPath.row];
    [HWTools getTextHeightWithText:model.name bigestSize:CGSizeMake(375, 1000) font:15];
    CGFloat height;
    if (height <= 100) {
        return 100;
    }else{
        return height;
    }
}

#pragma mark---懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeigth + 40
                                                                      )];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
  
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
