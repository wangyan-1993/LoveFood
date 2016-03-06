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
#import "ShareView.h"
#import "AnotherTableViewCell.h"
#import "DataBaseManager.h"
@interface DetailsViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate>
{
    NSInteger i;
    BOOL isCollect;
}
@property(nonatomic, retain) UITableView *tableView;
@property(nonatomic, retain) NSMutableArray *modelArray;
@property(nonatomic, retain) NSMutableArray *recommendArray;
@property(nonatomic, retain) ShareView  *shareView;
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
    
    UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
    button.frame = CGRectMake(0, kHeigth - 40, kWidth/2, 40);
    [button setTitle:@"分享" forState:UIControlStateNormal];
    button.backgroundColor = kMainColor;
    button.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [button addTarget:self action:@selector(shareButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button];
    
    UIButton *button1 = [UIButton buttonWithType:UIButtonTypeSystem];
    button1.frame = CGRectMake(kWidth/2, kHeigth - 40, kWidth/2, 40);
       DataBaseManager *dbManager = [DataBaseManager shareInatance];
    
    if ([dbManager selectAllCollectWithNum:[self.idDetails integerValue]].count == 0) {
        [button1 setTitle:@"收藏" forState:UIControlStateNormal];
        button1.tag = 0;
    }else{
        [button1 setTitle:@"取消收藏" forState:UIControlStateNormal];
        button1.tag = 1;

    }
    
    button1.backgroundColor = kMainColor;
    button1.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    [button1 addTarget:self action:@selector(collectButtonClickHandler:) forControlEvents:UIControlEventTouchUpInside];
    [self.view addSubview:button1];


    
}
- (void)viewWillAppear:(BOOL)animated{
    
}
- (void)configData{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
        NSString *str1 = [NSString stringWithFormat:@"%@%@", kRecommendData, self.idDetails];
    [manager GET:str1 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
        //NSLog(@"%@", responseObject);
        NSDictionary *dictionary = responseObject;
        NSDictionary *dict = dictionary[@"xiachufang"];
        NSString *status = dict[@"@status"];
        if ([status isEqualToString:@"ok"]) {
            NSString *str = dict[@"recipe_ids"];
            str = [str stringByReplacingOccurrencesOfString:@":" withString:@"%3A"];
//            [self configDataWithString:str];
            NSString *str2 = [NSString stringWithFormat:@"%@%@", kTwoListData, str];
            [manager GET:str2 parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
                
            } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
               // NSLog(@"%@", responseObject);
                NSDictionary *dictionary = responseObject;
                NSDictionary *dict = dictionary[@"xiachufang"];
                NSString *status = dict[@"@status"];
                if ([status isEqualToString:@"ok"]) {
                    NSArray *array = dict[@"recipe"];
                    for (NSDictionary *dic in array) {
                        [self.recommendArray addObject:dic];
                    }
                    [self configDataWithArray:self.recommendArray];
                }
                //[self.tableView reloadData];
            } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
                NSLog(@"%@", error);
            }];

        }

    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];
    
    
  
   
    
}
- (void)configDataWithArray:(NSMutableArray *)array{
    AFHTTPSessionManager *manager = [AFHTTPSessionManager manager];
    manager.responseSerializer.acceptableContentTypes = [NSSet setWithObject:@"application/json"];
    NSString *str = [NSString stringWithFormat:@"%@%@", kDetailsData, self.idDetails];
    NSLog(@"---------------%@", str);
    [manager GET:str parameters:nil progress:^(NSProgress * _Nonnull downloadProgress) {
        
    } success:^(NSURLSessionDataTask * _Nonnull task, id  _Nullable responseObject) {
         //NSLog(@"%@", responseObject );
        NSDictionary *dic = responseObject;

        [self configTableViewWithDic:dic withArray:array];
        [self.tableView reloadData];
        
    } failure:^(NSURLSessionDataTask * _Nullable task, NSError * _Nonnull error) {
        NSLog(@"%@", error);
    }];

}

- (void)configTableViewWithDic:(NSDictionary *)dic withArray:(NSMutableArray *)array{
    NSDictionary *xiachufangDic = dic[@"xiachufang"];
    NSString *status = xiachufangDic[@"@status"];
    if ([status isEqualToString:@"ok"]) {
        NSDictionary *dict = xiachufangDic[@"recipe"];
        if (isCollect) {
            DataBaseManager *dbManager = [DataBaseManager shareInatance];
            [dbManager insertIntoCollect:dict withNumber:[self.idDetails integerValue]];
        }
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
                                                  bigestSize:CGSizeMake(kWidth - 10, 1000) font:15.0];
        UIView *view1 = [[UIView alloc]initWithFrame:CGRectMake(5, 220 , kWidth - 10, 10+ labelHeight + 20)];
        view1.backgroundColor = kBackColor;
        UILabel *label = [[UILabel alloc]initWithFrame:CGRectMake(5, 0, kWidth - 10, labelHeight)];
        
        label.font = [UIFont systemFontOfSize:15.0];
        label.text = dict[@"summary"];
        label.numberOfLines = 0;
        
        UILabel *nameLabel = [[UILabel alloc]initWithFrame:CGRectMake(5, labelHeight + 10, 150, 20)];
        nameLabel.text = dict[@"author"][@"name"];
        nameLabel.textColor = [UIColor darkGrayColor];
        nameLabel.font = [UIFont systemFontOfSize:14];
        UILabel *doneLabel = [[UILabel alloc]initWithFrame:CGRectMake(150, labelHeight + 10, kWidth - 150 - 5-10, 20)];
        doneLabel.text = [NSString stringWithFormat:@"%@做过 %@收藏", dict[@"stats"][@"n_cooked"], dict[@"stats"][@"n_collects"]];
        doneLabel.font = [UIFont systemFontOfSize:14];
        doneLabel.textColor = [UIColor orangeColor];
        doneLabel.textAlignment = NSTextAlignmentRight;
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
                peiliaoLabel.frame = CGRectMake(5 , 280+labelHeight + 52 * i / 2 , (kWidth-11)/2, 50);
            }else{
                peiliaoLabel.frame = CGRectMake((kWidth-11)/2 + 7, 280+labelHeight + 52 * i / 2 - 26 , (kWidth-11)/2, 50);
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
        
#pragma mark---footview
        UIView *footView = [[UIView alloc]init];
        UILabel *recommendLabel = [[UILabel alloc]init];
        recommendLabel.text = @"喜欢这个的吃货也喜欢";
        recommendLabel.font = [UIFont systemFontOfSize:15];
        recommendLabel.textColor = [UIColor darkGrayColor];
        UIView *recommendView = [[UIView alloc]init];
        for (int j = 0; j < 6; j ++) {
            UIButton *button = [UIButton buttonWithType:UIButtonTypeSystem];
            button.frame = CGRectMake(5+ (j%2) * ((kWidth-13)/2 + 3), 5 + j / 2 * 122, (kWidth-13)/2 , 119);
            button.backgroundColor = kBackColor;
            button.tag = j;
            [button addTarget:self action:@selector(details:) forControlEvents:UIControlEventTouchUpInside];
            UIImageView *image = [[UIImageView alloc]initWithFrame:CGRectMake(5, 5, (kWidth-13)/2 - 10, 90)];
            [image sd_setImageWithURL:[NSURL URLWithString:array[j][@"photo"]] placeholderImage:nil];
            [button addSubview:image];
            UILabel *recommendName = [[UILabel alloc]initWithFrame:CGRectMake(5, 100, (kWidth-13)/2 - 10, 20)];
            recommendName.text = array[j][@"name"];
            recommendName.font = [UIFont systemFontOfSize:15];
            [button addSubview:recommendName];
            
            [recommendView addSubview:button];
        }
        
        
        if (![dict[@"tips"] isEqualToString:@""]) {
            UILabel *xiaotieshi = [[UILabel alloc]initWithFrame:CGRectMake(15, 5, kWidth - 30, 10)];
            xiaotieshi.text = @"小贴士";
            xiaotieshi.textColor = [UIColor darkGrayColor];
            CGFloat tipsHeight = [HWTools getTextHeightWithText:dict[@"tips"] bigestSize:CGSizeMake(kWidth - 10, 1000) font:15.0];
            UIView *view2 = [[UIView alloc]initWithFrame:CGRectMake(5, 20, kWidth - 10, tipsHeight + 10)];
            view2.backgroundColor = kBackColor;
            UILabel *tipsLabel = [[UILabel alloc]initWithFrame:CGRectMake(0, 5, kWidth - 10, tipsHeight)];
            tipsLabel.text = dict[@"tips"];
            tipsLabel.numberOfLines = 0;
            tipsLabel.font = [UIFont systemFontOfSize:15.0];
            [view2 addSubview:tipsLabel];
            recommendLabel.frame = CGRectMake(15, 35 + tipsHeight, 200, 10);
            recommendView.frame = CGRectMake(0, 50 + tipsHeight, kWidth, 366);
            footView.frame = CGRectMake(0, 0, kWidth, 416 + tipsHeight);
            
            [footView addSubview:xiaotieshi];
            [footView addSubview:view2];
        }else{
            recommendLabel.frame = CGRectMake(15, 10, 200, 8);
            recommendView.frame = CGRectMake(0, 25, kWidth,366);
            footView.frame = CGRectMake(0, 0, kWidth,391);
        }
        
        [footView addSubview:recommendLabel];
        [footView addSubview:recommendView];
        self.tableView.tableFooterView = footView;
    }
    
}
#pragma mark---UITableViewDataSource
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsModel *model = self.modelArray[indexPath.row];
    if ([model.image isEqualToString:@""]) {
        static NSString *str = @"another";
        AnotherTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:str];
        if (cell == nil) {
            cell = [[AnotherTableViewCell alloc]initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:str];
        }
        cell.model = model;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

   
        cell.backgroundColor = kBackColor;
        return cell;
    }else{
    
   DetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Details" forIndexPath:indexPath];
    cell.model = model;
    cell.backgroundColor = kBackColor;
        cell.selectionStyle = UITableViewCellSelectionStyleNone;

    return cell;
    }
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return self.modelArray.count;
    
}

#pragma mark---UITableViewDelegate
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    DetailsModel *model = self.modelArray[indexPath.row];
    if ([model.image isEqualToString:@""]) {
        CGFloat height = [HWTools getTextHeightWithText:model.name bigestSize:CGSizeMake(kWidth-70, 1000) font:15];
        height = height > 90 ? height : 90;
        return height + 10;
    }else{
     DetailsTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"Details"];
    cell.contentLabel.text = model.name;
    CGSize textViewSize = [cell.contentLabel sizeThatFits:CGSizeMake(kWidth- 160, FLT_MAX)];
    
    CGFloat h =  textViewSize.height;
    
    h = h > 90 ? h : 90;  //90是图片显示的最低高度， 见xib
    CGFloat height = cell.contentLabel.frame.size.height;
    height = h;
    return  10+h;
    }
   }
#pragma mark---button method
- (void)details:(UIButton *)btn{
    DetailsViewController *details = [[DetailsViewController alloc]init];
    details.idDetails  = self.recommendArray[btn.tag][@"id"];
    details.title = self.recommendArray[btn.tag][@"name"];
    [self.navigationController pushViewController:details animated:YES];
}

- (void)shareButtonClickHandler:(id)sender
{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (delegate.isLogin==NO) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"分享之前请先登录" delegate:self cancelButtonTitle:@"暂不登录" otherButtonTitles:@"立即登录", nil];
        [alert show];
    }else{
    
    self.shareView = [[ShareView alloc]init];
    }
}
- (void)collectButtonClickHandler:(UIButton *)sender{
    AppDelegate *delegate=(AppDelegate*)[[UIApplication sharedApplication]delegate];
    if (delegate.isLogin==NO) {
        UIAlertView* alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"收藏之前请先登录" delegate:self cancelButtonTitle:@"暂不登录" otherButtonTitles:@"立即登录", nil];
        [alert show];
    }else{
    
    
    if (sender.tag == 0) {
        isCollect = YES;
        
            [sender setTitle:@"取消收藏" forState:UIControlStateNormal];
        
        sender.tag = 1;
        [self configData];
    }
    else {
        isCollect = NO;
        
                    DataBaseManager *dbManager = [DataBaseManager shareInatance];
                    [dbManager deleteWithNum:[self.idDetails integerValue]];
        [sender setTitle:@"收藏" forState:UIControlStateNormal];
        sender.tag = 0;

    }
    }
}

#pragma mark---UIAlertViewDelegate
- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        self.tabBarController.selectedIndex = 2;
    }
}


#pragma mark---懒加载
- (UITableView *)tableView{
    if (_tableView == nil) {
        self.tableView = [[UITableView alloc]initWithFrame:CGRectMake(0, 0, kWidth, kHeigth-20)];
        self.tableView.delegate = self;
        self.tableView.dataSource = self;
  self.tableView.estimatedRowHeight = 200;
        self.tableView.rowHeight = UITableViewAutomaticDimension;
    }
    return _tableView;
}
- (NSMutableArray *)modelArray{
    if (_modelArray == nil) {
        self.modelArray = [NSMutableArray new];
    }
    return _modelArray;
}
- (NSMutableArray *)recommendArray{
    if (_recommendArray == nil) {
        self.recommendArray = [NSMutableArray new];
    }
    return _recommendArray;
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
