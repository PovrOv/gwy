//
//  MenopauseClinicDetailController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/18.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "MenopauseClinicDetailController.h"
#import "MenopauseClinicDetailCell.h"
#import "MapViewController.h"
#import "ClincDetailHeadViewCell.h"
#import "NSString+UTC.h"
@interface MenopauseClinicDetailController ()<UITableViewDelegate, UITableViewDataSource>
@property (strong, nonatomic) UITableView *tableView;//列表
@property (strong, nonatomic) UIImageView *detailImageV;
@property (strong, nonatomic) UILabel *titleLabel;
@property (strong, nonatomic) UILabel *contentLabel;

@property(strong, nonatomic) ClincDetaiHeadModel *model;
@property (nonatomic, strong) NSMutableArray *doctorsArray;
@property (nonatomic, strong) NSDictionary *clineDetailDict;
@end

@implementation MenopauseClinicDetailController

//- (instancetype)initWithPath:(NSString *)path{
//    if (self = [super init]) {
//        _path = path;
//    }
//    return self;
//}
- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"详情";
    CGRect frame = self.view.bounds;
    frame.size.height -= 64;
    self.tableView = [[UITableView alloc] initWithFrame:frame style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.tableView registerClass:[ClincDetailHeadViewCell class] forCellReuseIdentifier:@"ClincDetailHeadViewCell"];
    [self.tableView registerClass:[MenopauseClinicDetailCell class] forCellReuseIdentifier:@"MenopauseClinicDetailCell"];
    [self.view addSubview:self.tableView];
    
//    self.tableView.rowHeight = 74;
    self.navigationItem.leftBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"返回" style:UIBarButtonItemStylePlain target:self action:@selector(returnBack)];
    [self loadData];
    
    self.doctorsArray = [[NSMutableArray alloc] init];
    
}
- (void)returnBack{
    
    if (self.isRoot) {
        [self dismissViewControllerAnimated:YES completion:nil];
    }else{
        [self.navigationController popViewControllerAnimated:YES];
    }
}
- (void)loadData{
    [[GoldenLeafNetworkAPIManager shareManager] request_getClinicsDetailWithPath:self.path andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        NSDictionary *dict = data[@"data"];
        self.model = [[ClincDetaiHeadModel alloc] initWithDict:dict];
        [self.tableView reloadData];
//        self.clineDetailDict = dict;
//        NSArray *array = dict[@"doctors"];
//    
//        [self.detailImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,dict[@"picture"]]]];
//        self.contentTextView.text = dict[@"description"];
//        
//        NSString *address_1,*address_2,*address_3, *city, *province, *postal_code, *telephone_name_1,*telephone_name_2,*telephone_name_3, *telephone_1,*telephone_2,*telephone_3,*telephone_4,*telephone_5,*telephone_6,  *transportation_1,*transportation_2,*transportation_3,*transportation_4,*transportation_5,*transportation_6,*website;
//        self.titleLabel.text = dict[@"name"];
//        address_1 = [NSString filterNULLStr:dict[@"address_1"]];
//        address_2 = [NSString filterNULLStr:dict[@"address_2"]];
//        address_3 = [NSString filterNULLStr:dict[@"address_3"]];
//        
//        telephone_1 = [NSString filterNULLStr:dict[@"telephone_1"]];
//        telephone_2 = [NSString filterNULLStr:dict[@"telephone_2"]];
//        telephone_3 = [NSString filterNULLStr:dict[@"telephone_3"]];
//        telephone_4 = [NSString filterNULLStr:dict[@"telephone_4"]];
//        telephone_5 = [NSString filterNULLStr:dict[@"telephone_5"]];
//        telephone_6 = [NSString filterNULLStr:dict[@"telephone_6"]];
//        
//        transportation_1 = [NSString filterNULLStr:dict[@"transportation_1"]];
//        transportation_2 = [NSString filterNULLStr:dict[@"transportation_2"]];
//        transportation_3 = [NSString filterNULLStr:dict[@"transportation_3"]];
//        transportation_4 = [NSString filterNULLStr:dict[@"transportation_4"]];
//        transportation_5 = [NSString filterNULLStr:dict[@"transportation_5"]];
//        transportation_6 = [NSString filterNULLStr:dict[@"transportation_6"]];
//        
//        postal_code = [NSString filterNULLStr:dict[@"postal_code"]];
//        
//        website = [NSString filterNULLStr:dict[@"website"]];
//        
//        
//        if([dict[@"province"] isKindOfClass:[NSString class]]){
//            province = dict[@"province"];
//        }else{
//            province = @"";
//        }
////
//        if([dict[@"city"] isKindOfClass:[NSString class]]){
//            city = dict[@"city"];
//        }else{
//            city = @"";
//        }
////
////        if([dict[@"address_1"] isKindOfClass:[NSString class]]){
////            address_1 = dict[@"address_1"];
////        }else{
////            address_1 = @"";
////
////        }
////        
////        if([dict[@"postal_code"] isKindOfClass:[NSString class]]){
////            postal_code = [NSString stringWithFormat:@"邮编:%@", dict[@"postal_code"]];
////        }else{
////            postal_code = @"";
////        }
////        
////        if([dict[@"telephone_name_1"] isKindOfClass:[NSString class]]){
////            telephone_name_1 = [NSString stringWithFormat:@"电话：%@", dict[@"telephone_name_1"]];
////        }else{
////            telephone_name_1 = @"";
////        }
////        
////        if([dict[@"telephone_1"] isKindOfClass:[NSString class]]){
////            telephone_1 = dict[@"telephone_1"];
////        }else{
////            telephone_1 = @"";
////        }
////        
////        if([dict[@"website"] isKindOfClass:[NSString class]]){
////            website = [NSString stringWithFormat:@"网站：%@", dict[@"website"]];
////        }else{
////            website = @"";
////        }
//        
//        NSString *infoText = [NSString stringWithFormat:@"医院地址：（%@ %@）\n%@ \n%@ \n%@\n邮编：%@\n电话：%@ %@ %@ %@ %@ %@\n交通方式：%@ %@ %@ %@ %@ %@\n网站：%@", province,city,address_1, address_2, address_3,postal_code, telephone_1, telephone_2, telephone_3, telephone_4,telephone_5,telephone_6,transportation_1,transportation_2,transportation_3,transportation_4,transportation_5,transportation_6,website];
//        self.addressLabel.text = infoText;
//        
////        self.addressLabel.text = [NSString stringWithFormat:@"%@, %@", dict[@"address_1"], dict[@"address_2"]];
////
//        NSArray *array = dict[@"doctors"];
//        for (NSDictionary *dict in array) {
//            [self.doctorsArray addObject:dict];
//        }
//        [self.tableView reloadData];
    }];
}
- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if (section == 0) {
        return 1;
    }else{
        return self.model.doctorsArray.count;
//        return 0;
    }
    
}

//@property (weak, nonatomic) IBOutlet UIImageView *iconImageV;
//@property (weak, nonatomic) IBOutlet UILabel *nameLabel;
//@property (weak, nonatomic) IBOutlet UILabel *zhichenLabel;
//@property (weak, nonatomic) IBOutlet UILabel *timeLabel;

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{

    
    if(indexPath.section == 0){
        ClincDetailHeadViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"ClincDetailHeadViewCell" forIndexPath:indexPath];
        cell.model = self.model;
        
        [cell.lookMapButton addTarget:self action:@selector(gotoSeeAddressMap:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    }else{
        NSDictionary *dict = self.model.doctorsArray[indexPath.row];
        MenopauseClinicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"MenopauseClinicDetailCell" forIndexPath:indexPath];
    //    [cell.iconImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,dict[@"picture"]]]];
    
        [cell.iconImageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,dict[@"picture"]]] placeholderImage:[UIImage imageNamed:@"appicon_512"]];
    
        cell.nameLabel.text = dict[@"name"];
        cell.zhichenLabel.text = dict[@"occupation"];
        cell.timeLabel.text = dict[@"hours"];
        return cell;
        
    }
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        return [ClincDetailHeadViewCell cellHeightWithModel:_model];
    }else{
        return 75;
    }
}
#pragma mark - private method
- (void)gotoSeeAddressMap:(id)sender {
    MapViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MapViewController"];
    if ([self.clineDetailDict[@"latitude"] respondsToSelector:@selector(floatValue)] && [self.clineDetailDict[@"longitude"] respondsToSelector:@selector(floatValue)]) {
        CLLocationCoordinate2D coordinate = CLLocationCoordinate2DMake([self.clineDetailDict[@"latitude"] floatValue], [self.clineDetailDict[@"longitude"] floatValue]);
        
        control.coordinate = coordinate;
        [self.navigationController pushViewController:control animated:YES];
    }else{
        [self showToastWithMessage:@"经纬度异常，暂不支持查看地图"];
    }
    
    
    
}
- (void)showToastWithMessage:(NSString *)msg{
    CGPoint point = CGPointMake(kScreen_Width/2, kScreen_Height/2);
    [[[UIApplication sharedApplication] keyWindow] makeToast:msg duration:0.3 position:[NSValue valueWithCGPoint:point]];
}
@end
