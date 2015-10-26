//
//  HomeRootViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/7/29.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "HomeRootViewController.h"
#import "HomeColllectionViewTableViewCell.h"
#import "HomeTextContentTableViewCell.h"
#import "HomeTextAndImageViewTableViewCell.h"
#import "HomeCCollectionViewCell.h"
#import "DoctorViewController.h"
#import "LoginViewController.h"
#import "GLDiagnosisStep1ViewController.h"
#import "Constants.h"
#import <MobileCoreServices/MobileCoreServices.h>
#import "DoctorannouncementViewController.h"
#import "MenopauseClinicTableViewController.h"
#import "NoticeDetailTableViewController.h"
#import "HomeTextAndImageViewTableView2CellTableViewCell.h"
#import "SettingTableViewController.h"

#import "MeDoctorCenter.h"
#import "MeUserCenter.h"
#import "NoticeDetailTableViewController.h"
#import "NoticeTableViewController.h"
#import "HomeTableViewClineCell.h"
#import "TopicsTableViewController.h"
#import "UIButton+WebCache.h"
#import "MenopauseClinicDetailController.h"
#import "AnnounceDetailTableViewController.h"
#import "LoginViewModel.h"
#import "RemindModel.h"

@interface HomeRootViewController ()<UITableViewDataSource, UITableViewDelegate, UIAlertViewDelegate, CLLocationManagerDelegate, UIActionSheetDelegate, UIImagePickerControllerDelegate, UINavigationControllerDelegate, UIScrollViewDelegate, cellDidClickedDelegate>{
    NSString *_weather;
    NSString *_city;
    CGFloat icon1_X, tip1_X, icon2_X, tip2_X;
    CGFloat constraint1, constraint2,constraint3,constraint4;
    BOOL _animation;
}
@property (weak, nonatomic) IBOutlet UIScrollView *scrollerView;
@property (weak, nonatomic) IBOutlet UIPageControl *pageControl;

@property (weak, nonatomic) IBOutlet UITableView *tableView;

@property (weak, nonatomic) IBOutlet UIButton *userImageView;

@property (weak, nonatomic) IBOutlet UILabel *userNameLabel;
@property (weak, nonatomic) IBOutlet UILabel *dateLabel;

@property (weak, nonatomic) IBOutlet UILabel *weatherLabel;

@property (weak, nonatomic) IBOutlet UILabel *cityLabel;


@property (weak, nonatomic) IBOutlet UILabel *tipLabel;

@property (nonatomic, strong) NSArray *array;

@property (strong, nonatomic) CLLocationManager *locationManager;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *timeLabelConstraint;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *icon1Constraint;

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *iconConstraint;
@property BOOL newMedia;
@property (weak, nonatomic) IBOutlet NSLayoutConstraint *tipConstraint;
@property (weak, nonatomic) IBOutlet UIImageView *timeIcon;
@property (weak, nonatomic) IBOutlet UILabel *timeLabel;
@property (weak, nonatomic) IBOutlet UIImageView *icon1;


@property (nonatomic, strong) NSArray *announcement;
@property (nonatomic, strong) NSDictionary *healthy;
@property (nonatomic, strong) NSDictionary *clinic;

@property (weak, nonatomic) IBOutlet UIView *bgView;

@property (nonatomic, strong) NSArray *clinicArray;


@property (nonatomic, strong) UIImageView *tipIconImageView;
@property (nonatomic, strong) UILabel *tipLabelM;
@property (nonatomic, strong) UIImageView *clineImageView;
@property (nonatomic, strong) UILabel *clineLabel;

@property (nonatomic, assign) CGFloat maxX,x1,x2,x3,x4;
@property (weak, nonatomic) IBOutlet UIView *annitionBGView;

@property(nonatomic, strong) HomeTextContentTableViewCell *heaythCell;
@end

@implementation HomeRootViewController

#pragma mark - life cycle

- (void)loadListData{
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:@"created_at,desc" forKey:@"sort"];
    [[GoldenLeafNetworkAPIManager shareManager] request_getTopicsListWithParams:dict andBlock:^(id data, NSError *error) {
        NSArray *array = data[@"data"];
        if (array.count > 0) {
            self.announcement = array;
            [self.tableView reloadData];
        }
        
        
    }];
    
    [[GoldenLeafNetworkAPIManager shareManager] request_getArticleListWithPath:nil andBlock:^(id data, NSError *error) {
//            DebugLog(@"%@", data);
        NSArray *array = data[@"data"];
        if (array.count > 0) {
            self.healthy = array[0];
            [self.tableView reloadData];
        }
        
       
    }];
    
    [[GoldenLeafNetworkAPIManager shareManager] request_getClinicsListWithParams:nil andBlock:^(id data, NSError *error) {
        self.clinicArray = data[@"data"];
        if ([data[@"data"] count]) {
        
           [self.tableView reloadData];
        }
        
    }];

    NSString *path = [NSString stringWithFormat:@"%@%@", @"/api/v1/users/",[User shareUser].userID];
    [[GoldenLeafNetworkAPIManager shareManager] request_getUserInfoWithPath:path andBlock:^(id data, NSError *error) {
        if (data) {
            
            User *user = [User shareUser];
            user.token = [data[@"token"] safeCastToString];
            user.user_name = [data[@"data"][@"user_name"] safeCastToString];
            user.phone_number = [data[@"data"][@"phone_number"] safeCastToString];
            user.email_address = [data[@"data"][@"email_address"] safeCastToString];
            user.type = [data[@"data"][@"type"] safeCastToString];
            user.userID = [data[@"data"][@"id"] safeCastToString];
            
            NSDictionary *dataM = data[@"data"];
            user.birth_day = [dataM[@"birth_day"] safeCastToString];
            user.birth_month = [dataM[@"birth_month"] safeCastToString];
            user.birth_year = [dataM[@"birth_year"] safeCastToString];
            user.city = [dataM[@"city"] safeCastToString];
            user.sex = [dataM[@"sex"] safeCastToString];
            if ([dataM[@"name"] isKindOfClass:[NSString class]]) {
                user.name = dataM[@"name"];
            }
            [user saveToDisk];
            
            dispatch_async ( dispatch_get_main_queue (), ^{
              NSString *url = [NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,data[@"data"][@"picture"]];
//                 [self.userImageView sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal];
                
                if (user.userImageData) {
                    [self.userImageView setImage:[UIImage imageWithData:user.userImageData] forState:UIControlStateNormal];
                }else{
                    [self.userImageView sd_setImageWithURL:[NSURL URLWithString:url] forState:UIControlStateNormal placeholderImage:[UIImage imageNamed:@"appicon_1024"]];
                }
                
                
                [self.tableView reloadData];
            });
        }else{
//            self
        }
    }];
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)gotoLogin{
    
    User *user = [User shareUser];
    [LoginViewModel loginRequest_Params:[[NSMutableDictionary alloc] initWithDictionary:@{@"user_name":user.user_name , @"password":user.passworld}] andBlock:^(BOOL success) {
        if (success) {
            //                        [self dismissViewControllerAnimated:YES completion:nil];
        }else{
            //                        [self showToastWithMessage:@"账号或密码不匹配，请重新输入"];
        }
        
    }];
}
- (void)viewDidLoad {
    [super viewDidLoad];
    
//    if (![User shareUser].islogin) {
//        [self gotoLogin];
//    }
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(loadWeather) name:KUpdateweatherNotification object:nil];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(gotoLogin) name:KLoginNotification object:nil];
    
    self.title = @"首页";
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    
    self.locationManager = [[CLLocationManager alloc] init];
    self.locationManager.delegate = self;

    if ([self.locationManager respondsToSelector:@selector(requestWhenInUseAuthorization)]) {
        [self.locationManager requestWhenInUseAuthorization];
    }
    [self.locationManager startUpdatingLocation];
    
    // Today
    NSDate *today = [NSDate date];
    NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
    dateFormatter.dateFormat = [NSDateFormatter dateFormatFromTemplate:@"yyyy MMM d EEEE" options:0 locale:[NSLocale currentLocale]];
    dateFormatter.locale = [[NSLocale alloc] initWithLocaleIdentifier:@"zh_CN"];
    self.dateLabel.text = [dateFormatter stringFromDate:today];
    
    NSArray *imageArray = @[@"firstpage_yellowbg", @"firstpage_greenbg", @"firstpage_purplebg"];
    self.scrollerView.backgroundColor = [UIColor redColor];
    self.scrollerView.contentSize = CGSizeMake(kScreen_Width * imageArray.count , 140);
    CGFloat x;
    for (int i=0; i<imageArray.count; i++) {
        NSString *imageStr = imageArray[i];
        UIImageView *imageV = [[UIImageView  alloc] initWithImage:[UIImage imageNamed:imageStr]];
        x = i * kScreen_Width;
        imageV.frame = CGRectMake(x, 0, kScreen_Width, 140);
        [self.scrollerView addSubview:imageV];
    }
    
}

- (void)configureTipLabel{
    if (![[User shareUser].type isEqualToString:@"user"]) {
        _bgView.hidden = YES;
    }else{
        _bgView.hidden = NO;
    }
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"remind.plist"];
    NSString *tipStr, *timeStr;
    NSArray *arrayM = [[NSMutableArray alloc] initWithContentsOfFile:path];
    if (arrayM == nil) {
        arrayM = [[NSMutableArray alloc] init];
        tipStr = [NSString stringWithFormat:@"前往个人特区设置提醒时间"];
        timeStr = [NSString stringWithFormat:@"前往个人特区设置随诊时间"];
    }else{
//        NSString *time = [arrayM[0][@"time"] countDownStrWithTimeStr];
//        tipStr = [NSString stringWithFormat:@"下次吃药的时间是%@", time];
//        
//        NSString *date = [arrayM[2][@"date"] countDays];
//        timeStr = [NSString stringWithFormat:@"下次的复查时间是%@", date];
        
        NSString *medStr, *pad, *data;
        
//        for (NSDictionary *dict in arrayM) {
//            NSArray *allkeys = [dict allKeys];
//            if ([allkeys containsObject:@"medicine"]) {
//                if ([dict[@"time"] hadSetted]) {
//                    medStr = [NSString stringWithFormat:@"下次吃%@药品的时间是%@", dict[@"medicine"],[dict[@"time"] countDownStrWithTimeStr]];
//                }else{
//                    medStr = @"";
//                }
//            }
//            if ([allkeys containsObject:@"pad"]) {
//                if ([dict[@"time"] hadSetted]) {
//                    pad = [NSString stringWithFormat:@"下次吃%@药剂的时间是%@", dict[@"pad"],[dict[@"time"] countDownStrWithTimeStr]];
//                }else{
//                    pad = @"";
//                }
//                
//            }
//            if (!pad.length && !medStr.length) {
//                medStr = @"吃药时间未设置";
//            }
//            if ([allkeys containsObject:@"date"]) {
//                NSString *dateM = [dict[@"date"] countDays];
//                data = [NSString stringWithFormat:@"下次的复查时间是%@", dateM];
//            }
//        }
        
        
//        NSArray *allkeys = [dict allKeys];
        NSDictionary *medDic = arrayM[0];
            if ([[medDic allKeys] containsObject:@"medicine"]) {
                if ([medDic[@"time"] hadSetted]) {
                    medStr = [NSString stringWithFormat:@"下次吃%@药品的时间是%@", medDic[@"medicine"],[medDic[@"time"] countDownStrWithTimeStr]];
                }else{
                    medStr = @"";
                }
            }
        NSDictionary *padDic = arrayM[1];
            if ([[padDic allKeys] containsObject:@"pad"]) {
                if ([padDic[@"time"] hadSetted]) {
                    pad = [NSString stringWithFormat:@"下次吃%@药剂的时间是%@", padDic[@"pad"],[padDic[@"time"] countDownStrWithTimeStr]];
                }else{
                    pad = @"";
                }

            }
            if (!pad.length && !medStr.length) {
                medStr = @"吃药时间未设置";
            }
        NSDictionary *dateDic = arrayM[2];
            if ([[dateDic allKeys] containsObject:@"date"]) {
                NSString *dateM = [dateDic[@"date"] countDays];
                data = [NSString stringWithFormat:@"下次的复查时间是%@", dateM];
            }

        tipStr = [NSString stringWithFormat:@"%@  %@", medStr, pad];
        timeStr = data;
        
    }
    
    if (_tipIconImageView) {
        [_tipIconImageView removeFromSuperview];
    }
    if (_tipLabelM) {
        [_tipLabelM removeFromSuperview];
    }
    if (_clineImageView) {
        [_clineImageView removeFromSuperview];
    }
    if (_clineLabel) {
        [_clineLabel removeFromSuperview];
    }
    _tipIconImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"firstpage_timeicon"]];
    _tipIconImageView.frame = CGRectMake(8, 3, 16, 16);
    [_bgView addSubview:_tipIconImageView];
    _x1 = 8;
    CGFloat width = [NSString widthWithFontSize:14.0f size:CGSizeMake(CGFLOAT_MAX, 24) str:tipStr];
    _tipLabelM = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_tipIconImageView.frame) + 10, 0, width, 24)];
    _x2 = CGRectGetMaxX(_tipIconImageView.frame) + 10;
    _tipLabelM.text = tipStr;
    _tipLabelM.font = [UIFont systemFontOfSize:14.0f];
    [_bgView addSubview:_tipLabelM];
    
    
    _clineImageView = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"firstpage_timeicon"]];
    _clineImageView.frame = CGRectMake(CGRectGetMaxX(_tipLabelM.frame)+10, 3, 16, 16);
    [_bgView addSubview:_clineImageView];
    _x3 = CGRectGetMaxX(_tipLabelM.frame)+10;
    CGFloat widthM = [NSString widthWithFontSize:14.0f size:CGSizeMake(kScreen_Width, 24) str:timeStr];
    _clineLabel = [[UILabel alloc] initWithFrame:CGRectMake(CGRectGetMaxX(_clineImageView.frame) + 10, 0, widthM, 24)];
    _clineLabel.text = timeStr;
    _clineLabel.font = [UIFont systemFontOfSize:14.0f];
    _x4 = CGRectGetMaxX(_clineImageView.frame) + 10;
    _maxX = CGRectGetMaxX(_clineLabel.frame);
    
    [_bgView addSubview:_clineLabel];
    
    
    CGRect frame = _tipIconImageView.frame;
    frame.origin.x = _x1 - _maxX;
    _tipIconImageView.frame = frame;
    
    CGRect frame2 = _tipLabelM.frame;
    frame2.origin.x = _x2 - _maxX;
    _tipLabelM.frame = frame2;
    
    CGRect frame3 = _clineImageView.frame;
    frame3.origin.x = _x3 - _maxX;
    _clineImageView.frame = frame3;
    
    CGRect frame4 = _clineLabel.frame;
    frame4.origin.x = _x4 - _maxX;
    _clineLabel.frame = frame4;
    
    [self tipAnnimation];
}

- (void)updateTipText{
    
    
    NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"remind.plist"];
    NSString *tipStr, *timeStr;
    NSArray *arrayM = [[NSMutableArray alloc] initWithContentsOfFile:path];
    if (arrayM == nil) {
        arrayM = [[NSMutableArray alloc] init];
        tipStr = [NSString stringWithFormat:@"前往个人特区设置提醒时间"];
        timeStr = [NSString stringWithFormat:@"前往个人特区设置随诊时间"];
    }else{
//        NSString *time = [arrayM[0][@"time"] countDownStrWithTimeStr];
//        tipStr = [NSString stringWithFormat:@"下次吃药的时间是%@", time];
//        
//        NSString *date = [arrayM[2][@"date"] countDays];
//        timeStr = [NSString stringWithFormat:@"下次的复查时间是%@", date];
        
        NSString *medStr, *pad, *data;
        
        NSDictionary *medDic = arrayM[0];
        if ([[medDic allKeys] containsObject:@"medicine"]) {
            if ([medDic[@"time"] hadSetted]) {
                medStr = [NSString stringWithFormat:@"下次吃%@药品的时间是%@", medDic[@"medicine"],[medDic[@"time"] countDownStrWithTimeStr]];
            }else{
                medStr = @"";
            }
        }
        NSDictionary *padDic = arrayM[1];
        if ([[padDic allKeys] containsObject:@"pad"]) {
            if ([padDic[@"time"] hadSetted]) {
                pad = [NSString stringWithFormat:@"下次吃%@药剂的时间是%@", padDic[@"pad"],[padDic[@"time"] countDownStrWithTimeStr]];
            }else{
                pad = @"";
            }
            
        }
        if (!pad.length && !medStr.length) {
            medStr = @"吃药时间未设置";
        }
        NSDictionary *dateDic = arrayM[2];
        if ([[dateDic allKeys] containsObject:@"date"]) {
            NSString *dateM = [dateDic[@"date"] countDays];
            data = [NSString stringWithFormat:@"下次的复查时间是%@", dateM];
        }
        if (!pad.length && !medStr.length) {
            medStr = @"吃药时间未设置";
        }
        tipStr = [NSString stringWithFormat:@"%@  %@", medStr, pad];
        timeStr = data;
    }
    
    _tipLabelM.text = tipStr;
    _clineLabel.text = timeStr;
}
- (void)tipAnnimation{
    [self updateTipText];
    
    [UIView animateWithDuration:15.0f animations:^{
        CGRect frame = _tipIconImageView.frame;
        frame.origin.x = _x1 +kScreen_Width;
        _tipIconImageView.frame = frame;
        
        CGRect frame2 = _tipLabelM.frame;
        frame2.origin.x = _x2 +kScreen_Width;
        _tipLabelM.frame = frame2;
        
        CGRect frame3 = _clineImageView.frame;
        frame3.origin.x = _x3 +kScreen_Width;
        _clineImageView.frame = frame3;
        
        CGRect frame4 = _clineLabel.frame;
        frame4.origin.x = _x4 +kScreen_Width;
        _clineLabel.frame = frame4;
        
    }completion:^(BOOL finished) {
        if (finished) {
//            [UIView animateWithDuration:15.0f animations:^{
                CGRect frame = _tipIconImageView.frame;
                frame.origin.x = _x1 - _maxX;
                _tipIconImageView.frame = frame;
                
                CGRect frame2 = _tipLabelM.frame;
                frame2.origin.x = _x2 - _maxX;
                _tipLabelM.frame = frame2;
                
                CGRect frame3 = _clineImageView.frame;
                frame3.origin.x = _x3 - _maxX;
                _clineImageView.frame = frame3;
                
                CGRect frame4 = _clineLabel.frame;
                frame4.origin.x = _x4 - _maxX;
                _clineLabel.frame = frame4;
//
//            } completion:^(BOOL finished) {
//                if (finished) {
                    [self tipAnnimation];
//                }
//            }];
        }
    }];
}

- (void)viewDidDisappear:(BOOL)animated{
    [super viewDidDisappear:YES];
    _bgView.hidden = YES;
}

- (void)viewWillAppear:(BOOL)animated{
    [super viewWillAppear:YES];
    _bgView.hidden = NO;
    [self.tableView reloadData];

    [super viewWillAppear:YES];
    
    [self loadListData];
    [self configureTipLabel];
    
//    [self loadWeather];
    
    if ([User shareUser].user_name.length) {
        self.userNameLabel.text = [User shareUser].user_name;
        
        [self loadRemind];
    }else{
        self.userNameLabel.text = @"未登录";
        [self.userImageView setImage:[UIImage imageNamed:@"appicon_1024"] forState:UIControlStateNormal];
        
    }
    [[NSNotificationCenter defaultCenter] postNotificationName:@"returnBack" object:nil];
    [self updaUserInfo];
    
}
#pragma mark - private


- (void)loadRemind{
    [[GoldenLeafNetworkAPIManager shareManager] request_getRemindWithBlock:^(id data, NSError *error) {
        if (data) {
            NSString *path = [[NSSearchPathForDirectoriesInDomains(NSDocumentDirectory, NSUserDomainMask, YES) objectAtIndex:0] stringByAppendingPathComponent:@"remind.plist"];
            
            NSFileManager *defaultManager = [NSFileManager defaultManager];
//            [defaultManager removeFileAtPath: path handler: nil];
            [defaultManager removeItemAtPath:path error:nil];
            NSMutableArray *array = [[NSMutableArray alloc] init];
            
            [array insertObject:@{@"medicine":@"请输入药品名称", @"time":@"请选择用药时间",@"times":@"请输入用药次数"} atIndex:0];
            
            [array insertObject:@{@"pad":@"请输入药品名称", @"time":@"请选择用药时间",@"times":@"请输入用药次数"} atIndex:1];
            
            [array insertObject:@{@"date":@"请选择"} atIndex:2];

            
            DebugLog(@"%@", data);
            NSArray *arrayM = data[@"data"];
            for (NSDictionary *dict in arrayM) {
                RemindModel *model = [[RemindModel alloc] initWithDic:dict];
                if (model.iSMedicine) {
                    [array removeObjectAtIndex:0];
                    [array insertObject:@{@"medicine":model.medicine_name, @"time":model.time,@"times":model.times, @"id":@(model.rID)} atIndex:0];
                }else if (model.iSPad){
                    [array removeObjectAtIndex:1];
                    [array insertObject:@{@"pad":model.medicine_name, @"time":model.time, @"times" : model.times, @"id":@(model.rID)} atIndex:1];
                }else if(model.iSDaily){
                    [array removeObjectAtIndex:2];
                    [array insertObject:@{@"date":model.day, @"id":@(model.rID)} atIndex:2];
                }
            }
            [array writeToFile:path atomically:YES];
            [self.tableView reloadData];
        }
    }];
}
- (void)loadWeather{
    [[GoldenLeafNetworkAPIManager shareManager] request_getWeatherWithCityName:self.cityLabel.text andBlock:^(id data, NSError *error) {
//        DebugLog(@"%s\n%@", __func__,data);
        
        NSString *pm = data[@"results"][0][@"pm25"];
        NSString *weather = data[@"results"][0][@"weather_data"][0][@"weather"];
        NSString *temperature = data[@"results"][0][@"weather_data"][0][@"temperature"];
        
        NSString *weatherM = [NSString stringWithFormat:@"%@ %@ %@ : %@", weather, temperature, @"PM2.5", pm];
        _weather = weatherM;
        self.weatherLabel.adjustsFontSizeToFitWidth = YES;
//        self.weatherLabel.minimumFontSize = 13;
        self.weatherLabel.text = weatherM;
    }];
}


- (void)updaUserInfo{
//    user_name (optional)
//    email_address (optional)
//    password (optional)
//    type ('user' or 'doctor') (optional)
//    name (optional)
//    sex (optional)
//    birth_day (optional)
//    birth_month (optional)
//    birth_year (optional)
//    phone_number (optional)
//    picture (optional)
//    occupation (optional)
//    hospital (optional)
//    department (optional)
//    city (optional)
    User *user = [User shareUser];
    NSMutableDictionary *userInfoDict = [[NSMutableDictionary alloc] init];
    if (user.user_name.length > 0) {
        [userInfoDict setObject:user.user_name forKey:@"user_name"];
    }
    
    if (user.email_address.length > 0) {
        [userInfoDict setObject:user.email_address forKey:@"email_address"];
    }
    
    if (user.passworld.length > 0) {
        [userInfoDict setObject:user.passworld forKey:@"password"];
    }
    if (user.name.length > 0) {
        [userInfoDict setObject:user.name forKey:@"name"];
    }

    if (user.birth_day) {
        [userInfoDict setObject:user.birth_day forKey:@"birth_day"];
    }
   
    if (user.birth_month) {
        [userInfoDict setObject:user.birth_month forKey:@"birth_month"];
    }

    if (user.birth_year) {
        [userInfoDict setObject:user.birth_year forKey:@"birth_year"];
    }

    if (user.phone_number.length > 0) {
        [userInfoDict setObject:user.phone_number forKey:@"phone_number"];
    }
    if (user.sex.length > 0) {
        [userInfoDict setObject:user.sex forKey:@"sex"];
    }
    
    [[GoldenLeafNetworkAPIManager shareManager] request_updateUserInfoWithParams:userInfoDict andBlock:^(id data, NSError *error) {
                if (data) {
//                    DebugLog(@"%@", data);
                }
    }];
    
    if (user.userImageData) {
        [[GoldenLeafNetworkAPIManager shareManager] request_updateUserInfoWithParams:nil andBlock:^(id data, NSError *error) {
            if (data) {
//                DebugLog(@"%@", data);
                user.userImageData = nil;
            }
        }];
    }
    
}
- (IBAction)gotoSettingViewController:(id)sender {
    if ([[User shareUser] islogin]) {
        SettingTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"SettingTableViewController"];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
        [self presentViewController:nav animated:YES completion:nil];
        
    }else{
        
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此操作需要先登入，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往登入", nil];
        [alert show];
    }
    
}

- (IBAction)gotoPersonInfomation:(id)sender {
    UIActionSheet *sheet = [[UIActionSheet alloc] initWithTitle:@"请选择更换头像的方式" delegate:self cancelButtonTitle:@"取消" destructiveButtonTitle:nil otherButtonTitles:@"拍照", @"从手机相册选择", nil];
    [sheet showInView:self.view];
    
}

- (void)gotoList:(UIButton *)sender{
    switch (sender.tag) {
        case 110:{
            DoctorannouncementViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorannouncementViewController"];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
            control.isRoot = YES;
            [self presentViewController:nav animated:YES completion:nil];
            
        }
            break;
        case 111:{
            NoticeTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NoticeTableViewController"];
            control.isRoot = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
        case 112:{
            MenopauseClinicTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenopauseClinicTableViewController"];
            control.isRoot = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
            [self presentViewController:nav animated:YES completion:nil];
        }
            break;
            
        default:
            break;
    }

}
#pragma mark - tableView delegate & datasource

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
    return 2;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    if (section == 0) {
        return 3;
    }else{
        if (!self.clinicArray.count) {
            return 0;
        }
        if (self.clinicArray.count <= 2) {
            return self.clinicArray.count;
        }
        return 2;
//        return 0;
    }
    
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 0) {
        switch (indexPath.row) {
                
            case 0:
                return [HomeColllectionViewTableViewCell cellHeight];
                break;
            case 1:
                return [HomeTextContentTableViewCell cellHeight];
                break;
            case 2:
                return [HomeTextAndImageViewTableViewCell cellHeight];
                break;
                
            default:
                break;
        }
    }else{
        return [HomeTableViewClineCell cellHeight];
    }
    
    
    return 0;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section{
    if (section == 1) {
        return 55;
    }
    return 0;
}

- (UIView *)tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section{
    HomeTextAndImageViewTableView2CellTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"HomeTextAndImageViewTableView2CellTableViewCell"];
    cell.block = ^{
        MenopauseClinicTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenopauseClinicTableViewController"];
        control.isRoot = YES;
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
        [self presentViewController:nav animated:YES completion:nil];
    };
    UIButton *sender =  (UIButton *)[cell.contentView viewWithTag:111];
    
    [sender addTarget:self action:@selector(gotoList:) forControlEvents:UIControlEventTouchUpInside];
    return cell;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section ==  0) {
        switch (indexPath.row) {
            case 0:{
                HomeColllectionViewTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"HomeColllectionViewTableViewCell" forIndexPath:indexPath];
                cell.ccellDidClickedBlock = ^(NSInteger index){
//                    DebugLog(@"%ld", (long)index);
                    if (index == 0) {
                        if ([[User shareUser] islogin]) {
                            GLDiagnosisStep1ViewController *control = [[UIStoryboard storyboardWithName:@"Menses" bundle:nil] instantiateInitialViewController];
                            [self presentViewController:control animated:YES completion:nil];
                            
                        }else{
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此操作需要先登入，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往登入", nil];
                            [alert show];
                        }
                        
                    }else if (index == 1){
                        DoctorViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"DoctorViewController"];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
                        //                    nav.navigationBar.tintColor = rgb(237, 188, 0);
                        
                        [self presentViewController:nav animated:YES completion:^{
                            
                        }];
                    }else if (index == 2){
                        TopicsTableViewController *control = [[TopicsTableViewController alloc] init];
                        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
                        [self presentViewController:nav animated:YES completion:^{
                            
                        }];
                    }else{
                        if ([[User shareUser] islogin]) {
                            if ([[User shareUser].type isEqualToString:@"user"]) {
                                MeUserCenter *userCenter = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"MeUserCenterNav"];
                                [self presentViewController:userCenter animated:YES completion:nil];
                            }else{
                                MeDoctorCenter *doctorCenter = [[UIStoryboard storyboardWithName:@"Me" bundle:nil] instantiateViewControllerWithIdentifier:@"MeDoctorCenterNav"];
                                [self presentViewController:doctorCenter animated:YES completion:nil];
                            }
                        }else{
                            UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此操作需要先登入，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往登入", nil];
                            [alert show];
                        }

                    }
                };
                return cell;
            }
                break;
            case 1:{
//                HomeTextContentTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"HomeTextContentTableViewCell" forIndexPath:indexPath];
//                
//                UIButton *sender =  (UIButton *)[cell.contentView viewWithTag:110];
//                
//                [sender addTarget:self action:@selector(gotoList:) forControlEvents:UIControlEventTouchUpInside];
//                
//                if (self.announcement) {
//                    cell.contentLabel.text = self.announcement[@"title"];
//                }
//                self.heaythCell = cell;
//                [cell animation];
                HomeTextContentTableViewCell *cell = [[HomeTextContentTableViewCell alloc] cellWithTableView:tableView];
                //
//                    if (self.announcement) {
//                        cell.contentLabel.text = self.announcement[@"title"];
//                    }
//                    self.heaythCell = cell;
//                    [cell animation];
                cell.dataArray = self.announcement;
                cell.delegate = self;
                    UIButton *sender =  (UIButton *)[cell.contentView viewWithTag:110];
    
                    [sender addTarget:self action:@selector(gotoList:) forControlEvents:UIControlEventTouchUpInside];
    
                return cell;
                
            }
                
                break;
            case 2:{
                HomeTextAndImageViewTableViewCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"HomeTextAndImageViewTableViewCell" forIndexPath:indexPath];
                cell.iconView.image = [UIImage imageNamed:self.array[0][@"icon"]];
                cell.titleLabel.text = self.array[0][@"title"];
                if (self.healthy) {
                    cell.contentLabel.text = self.healthy[@"title"];
                    [cell.imageV sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,self.healthy[@"picture"]]]];
                }
                UIButton *sender =  (UIButton *)[cell.contentView viewWithTag:111];
                
                [sender addTarget:self action:@selector(gotoList:) forControlEvents:UIControlEventTouchUpInside];
                return cell;
                
            }
                
                break;
            
                
            default:
                break;
        }

    }else{
    
        NSDictionary *dict = self.clinicArray[indexPath.row];
        HomeTableViewClineCell *cell =  [tableView dequeueReusableCellWithIdentifier:@"HomeTableViewClineCell" forIndexPath:indexPath];
        //            cell.iconView.image = [UIImage imageNamed:self.array[1][@"icon"]];
        //            cell.titleLabel.text = self.array[1][@"title"];
//        UILabel *label = (UILabel *)[cell viewWithTag:1000];
//        label.text = self.clinic[@"description"];
//        
//        UIImageView *imageV = (UIImageView *)[cell viewWithTag:2000];
        
//        cell.hospitalName
//        cell.hospitalName.text = dict[@"name"];
//        cell.cityLabel.text = dict[@"city"];
//        cell.infoLabel.text = dict[@"description"];
//        
//        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,dict[@"picture"]]]];
        
        [cell.iconImageView sd_setImageWithURL:[NSURL URLWithString:[NSString stringWithFormat:@"%@%@", KNetpath_Code_Base,[NSString convertString:dict[@"picture"]]]]];
        cell.hospitalName.text = [NSString convertString:dict[@"name"]];
        cell.cityLabel.text = [NSString convertString:dict[@"city"]];
        
        cell.infoLabel.text = [NSString convertString:dict[@"description"]];
        
        UIButton *sender =  (UIButton *)[cell.contentView viewWithTag:112];
        
        [sender addTarget:self action:@selector(gotoList:) forControlEvents:UIControlEventTouchUpInside];
        return cell;
    
    }
    return nil;
}

- (void)cellDidClicked:(NSDictionary *)dict{
//    NSDictionary *dict = self.announcement;
    NSString *path = [NSString stringWithFormat:@"%@%@", @"/api/v1/announcements/",dict[@"id"]];
    AnnounceDetailTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"AnnounceDetailTableViewController"];
    control.path = path;
    control.isRoot = YES;
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
    //            [self.navigationController pushViewController:control animated:YES];
    [self presentViewController:nav animated:YES completion:nil];
}
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.section == 1) {
//        MenopauseClinicTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenopauseClinicTableViewController"];
//        control.isRoot = YES;
//        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
        
        NSDictionary *dict = self.clinicArray[indexPath.row];
        NSString *path = [NSString stringWithFormat:@"%@%@", @"/api/v1/clinics/",dict[@"id"]];
//        MenopauseClinicDetailController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenopauseClinicDetailController"];
        
        MenopauseClinicDetailController *control = [[MenopauseClinicDetailController alloc] init];
        control.isRoot = YES;
        control.path = path;
        [self.navigationController pushViewController:control animated:YES];
        UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
        [self presentViewController:nav animated:YES completion:nil];
    
    }
    switch (indexPath.row) {
        case 1:{
            
        }
            break;
        case 2:{
            User *user = [User shareUser];
            
            if (user.islogin) {
                user.healthTitle = @"";
                [user saveToDisk];
            }else{
                if (user.healthTitle.length > 0 && ![user.healthTitle isEqualToString:self.healthy[@"title"]]) {
//                    DebugLog(@"不能看");
                    NSString *message = [NSString stringWithFormat:@"当前您只能查看标题为<%@>的须知", user.healthTitle];
                    UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"您尚未登录,登录之后更精彩" message:message delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"登录", nil];
                    alert.delegate = self;
                    [alert show];
                    return;
                }else{
                    user.healthTitle = self.healthy[@"title"];
                    [user saveToDisk];
                }
            }

            NSString *path = [NSString stringWithFormat:@"%@%@", @"/api/v1/articles/",self.healthy[@"id"]];
            NoticeDetailTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NoticeDetailTableViewController"];
            control.path = path;
            control.isRoot = YES;
//            NoticeTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NoticeTableViewController"];
//            control.isRoot = YES;
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
            [self presentViewController:nav animated:YES completion:nil];
//            if ([User shareUser].token.length) {
//                GLDiagnosisStep1ViewController *control = [[UIStoryboard storyboardWithName:@"Menses" bundle:nil] instantiateInitialViewController];
//                [self presentViewController:control animated:YES completion:nil];
//                
//            }else{
//                UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此操作需要先登入，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往登入", nil];
//                [alert show];
//            }
//            NoticeDetailTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NoticeDetailTableViewController"];
//            [self presentViewController:[[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"NoticeDetailTableViewController"] animated:YES completion:^{
//                
//            }];
        }
            break;
            
        case 3:{
//            MenopauseClinicTableViewController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenopauseClinicTableViewController"];
//            control.isRoot = YES;
            NSDictionary *dict = self.clinicArray[indexPath.row];
            NSString *path = [NSString stringWithFormat:@"%@%@", @"/api/v1/clinics/",dict[@"id"]];
            MenopauseClinicDetailController *control = [[UIStoryboard storyboardWithName:@"Main" bundle:nil] instantiateViewControllerWithIdentifier:@"MenopauseClinicDetailController"];
            control.path = path;
            [self.navigationController pushViewController:control animated:YES];
            UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
            [self presentViewController:nav animated:YES completion:nil];
        }
        default:
            break;
    }
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (alertView.tag == 1000) {
        if (buttonIndex == 1) {
            // Send the user to the Settings for this app
            NSURL *settingsURL = [NSURL URLWithString:UIApplicationOpenSettingsURLString];
            [[UIApplication sharedApplication] openURL:settingsURL];
        }
    }else{
        if (buttonIndex == 1) {
            LoginViewController *control = [[UIStoryboard storyboardWithName:@"Login" bundle: nil] instantiateInitialViewController];
            //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
            [self presentViewController:control animated:YES completion:nil];
        }
    }
    
    
}
#pragma mark - setter & getter

- (NSArray *)array{
    if (!_array) {
        _array = @[@{@"icon":@"firstpage_diagnosisicon_pressed", @"title":@"每日健康"}, @{@"icon":@"firstpage_outpatienticon", @"title":@"更年期门诊"}];
    }
    return _array;
}

- (void)requestAlwaysAuthorization {
    CLAuthorizationStatus status = [CLLocationManager authorizationStatus];
    
    // If the status is denied or only granted for when in use, display an alert
    if (status == kCLAuthorizationStatusAuthorizedWhenInUse || status == kCLAuthorizationStatusDenied) {
        NSString *title;
        title = (status == kCLAuthorizationStatusDenied) ? @"Location services are off" : @"Background location is not enabled";
        NSString *message = @"To use background location you must turn on 'Always' in the Location Services Settings";
        
        UIAlertView *alertView = [[UIAlertView alloc] initWithTitle:title
                                                            message:message
                                                           delegate:self
                                                  cancelButtonTitle:@"Cancel"
                                                  otherButtonTitles:@"Settings", nil];
        alertView.tag = 1000;
        [alertView show];
    }
    // The user has not enabled any location services. Request background authorization.
    else if (status == kCLAuthorizationStatusNotDetermined) {
        [self.locationManager requestAlwaysAuthorization];
    }
}


// this delegate is called when the app successfully finds your current location
- (void)locationManager:(CLLocationManager *)manager didUpdateLocations:(NSArray *)locations{
    CLGeocoder *geocoder = [[CLGeocoder alloc] init];
    CLLocation *currectLoaction = [locations lastObject];
    [geocoder reverseGeocodeLocation:currectLoaction completionHandler:^(NSArray *placemarks, NSError *error) {
        CLPlacemark *placemark = placemarks[0];
        NSString *city = placemark.locality;
        self.cityLabel.text = city;
        
        [self loadWeather];
//        self.weatherLabel.text = [NSString stringWithFormat:@"%@ 多云 20C PM2.5值:179", city];
    }];
}

- (void)locationManager:(CLLocationManager *)manager didFailWithError:(NSError *)error {
    NSLog(@"didFailWithError: %@", error);
//    self.weatherLabel.text = @"上海 多云 20C PM2.5值:179";
    self.cityLabel.text = @"定位失败";
}

#pragma mark -
#pragma mark - Action sheet delegate

- (void)actionSheet:(UIActionSheet *)actionSheet clickedButtonAtIndex:(NSInteger)buttonIndex {
    if (buttonIndex == 0) {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeCamera]) {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypeCamera;
            imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
            self.newMedia = YES;
        }
    } else if (buttonIndex == 1) {
        if ([UIImagePickerController isSourceTypeAvailable:
             UIImagePickerControllerSourceTypeSavedPhotosAlbum]) {
            UIImagePickerController *imagePicker =
            [[UIImagePickerController alloc] init];
            imagePicker.delegate = self;
            imagePicker.sourceType =
            UIImagePickerControllerSourceTypePhotoLibrary;
            imagePicker.mediaTypes = @[(NSString *) kUTTypeImage];
            imagePicker.allowsEditing = NO;
            [self presentViewController:imagePicker
                               animated:YES completion:nil];
            self.newMedia = NO;
        }
    }
    
    [actionSheet dismissWithClickedButtonIndex:buttonIndex animated:YES];
}


#pragma mark -
#pragma mark UIImagePickerControllerDelegate

- (void)imagePickerController:(UIImagePickerController *)picker didFinishPickingMediaWithInfo:(NSDictionary *)info {
    NSString *mediaType = info[UIImagePickerControllerMediaType];
    
    [self dismissViewControllerAnimated:YES completion:nil];
    
    if ([mediaType isEqualToString:(NSString *) kUTTypeImage]) {
        UIImage *image = info[UIImagePickerControllerOriginalImage];
        
//        NSData *data = UIImagePNGRepresentation(image);
        NSData *data = UIImageJPEGRepresentation(image, 0.2);
        NSUserDefaults *prefs = [NSUserDefaults standardUserDefaults];
        [prefs setObject:data forKey:@"PROFILE_IMAGE"];
        [prefs synchronize];
        [User shareUser].userImageData = data;
        [self.userImageView setImage:image forState:UIControlStateNormal];
        
        
        if (_newMedia) {
            UIImageWriteToSavedPhotosAlbum(image, self,@selector(image:finishedSavingWithError:contextInfo:), nil);
        }
    }
}

- (void)image:(UIImage *)image finishedSavingWithError:(NSError *)error contextInfo:(void *)contextInfo {
    if (error) {
        UIAlertView *alert = [[UIAlertView alloc]
                              initWithTitle: @"Save failed"
                              message: @"Failed to save image"
                              delegate: nil
                              cancelButtonTitle:@"OK"
                              otherButtonTitles:nil];
        [alert show];
    }
}

- (void)imagePickerControllerDidCancel:(UIImagePickerController *)picker {
    
    [self dismissViewControllerAnimated:YES completion:nil];
}

#pragma mark - uiscrowview delegate

- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
    if(scrollView.contentOffset.x > kScreen_Width * 1.5){
        self.pageControl.currentPage = 2;
    }else if (scrollView.contentOffset.x > kScreen_Width/2 && self.scrollerView.contentOffset.x < kScreen_Width * 1.5) {
        self.pageControl.currentPage = 1;
    }else{
        self.pageControl.currentPage = 0;
    }
}

@end
