//
//  TopicDetailViewController.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/29.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "TopicDetailViewController.h"
#import "TopicDetailCell.h"
#import "TopicModel.h"
#import "ReplyModel.h"
#import "ReplyTableViewCell.h"
#import "LoginViewController.h"

@interface TopicDetailViewController ()<UITableViewDataSource, UITableViewDelegate, UIScrollViewDelegate, UIAlertViewDelegate>{
    BOOL _show;
}
@property(nonatomic, strong)UITableView *tableView;
@property(nonatomic, strong)UIView *sendCommentView;
@property(nonatomic, strong) TopicModel *model;
@property(nonatomic, strong) UIView *zhezhaoView;
@property(nonatomic, strong) NSMutableArray *dataArray;
@property (nonatomic, assign)BOOL couldSend;
@property(nonatomic, strong) UITextView *replyContentView;
@end
@implementation TopicDetailViewController
- (void)showToastWithMessage:(NSString *)msg{
    CGPoint point = CGPointMake(kScreen_Width/2, kScreen_Height/2);
    [[[UIApplication sharedApplication] keyWindow] makeToast:msg duration:0.3 position:[NSValue valueWithCGPoint:point]];
}

- (instancetype)initWithTopicModel:(TopicModel *)model{
    if (self = [super init]) {
        _model = model;
    }
    return self;
}
- (void)viewDidLoad{
    [super viewDidLoad];
    self.tableView = [[UITableView alloc] initWithFrame:CGRectMake(0, 0, kScreen_Width, kScreen_Height - 44 -64) style:UITableViewStylePlain];
    self.tableView.delegate = self;
    self.tableView.dataSource = self;
    [self.view addSubview:self.tableView];
    self.title = @"帖子详情";
    [self.tableView registerClass:[TopicDetailCell class] forCellReuseIdentifier:@"headCell"];
    [self.tableView registerClass:[ReplyTableViewCell class] forCellReuseIdentifier:@"replayCell"];
    self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
    self.tableView.backgroundColor = [UIColor whiteColor];
    
    _dataArray = [[NSMutableArray alloc] init];
    
    [self setupSendCommentView];
    [self loadData];
    
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardShow:) name:UIKeyboardWillShowNotification object:nil];
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardHide:) name:UIKeyboardWillHideNotification object:nil];
}
- (void)setupSendCommentView{
    self.zhezhaoView = [[UIView alloc] initWithFrame:self.view.frame];
    [self.view addSubview:self.zhezhaoView];
    UITapGestureRecognizer *guester = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(diss)];
    [self.zhezhaoView addGestureRecognizer:guester];
    self.zhezhaoView.backgroundColor = rgba(235, 235, 235, 0.6);
    self.zhezhaoView.hidden = YES;
    
    _sendCommentView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreen_Height, 44)];
    _sendCommentView.backgroundColor = rgb(235, 235, 235);
    [self.view addSubview:_sendCommentView];
    
    UITextView *textView = [[UITextView alloc] initWithFrame:CGRectMake(10, 5, kScreen_Width-20-50, 44-10)];
    textView.font = [UIFont systemFontOfSize:15.0f];
    _replyContentView = textView;
    [_sendCommentView addSubview:textView];
    
    
    UIButton *replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
    replyButton.frame = CGRectMake(kScreen_Width-50-5, 5, 50, 34);
    [replyButton setTitle:@"发送" forState:UIControlStateNormal];
//    replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [replyButton setFont:[UIFont systemFontOfSize:15.0f]];
    replyButton.backgroundColor = rgb(237, 188, 0);
    [replyButton setTitleColor:[UIColor whiteColor] forState:UIControlStateNormal];
    [replyButton addTarget:self action:@selector(sendReply:) forControlEvents:UIControlEventTouchUpInside];
    [_sendCommentView addSubview:replyButton];
    
}
- (void)loadData{
    [[GoldenLeafNetworkAPIManager shareManager] request_getGroupReplyListWithTopicID:_model.topicID andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        NSArray *array = data[@"data"];
        [self.dataArray removeAllObjects];
        for (NSDictionary *dict in array) {
            ReplyModel *model = [[ReplyModel alloc] initWithDict:dict];
            [self.dataArray addObject:model];
        }
        [self.tableView reloadData];
    }];
    
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
    return 1+self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
    if (indexPath.row == 0) {
        TopicDetailCell *cell = [tableView dequeueReusableCellWithIdentifier:@"headCell" forIndexPath:indexPath];
        cell.model = self.model;
        return cell;
    }else{
        ReplyTableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"replayCell" forIndexPath:indexPath];
        cell.block = ^(ReplyModel *model){
            _replyContentView.text = [NSString stringWithFormat:@"回复@ %@:",model.userNameStr];
        };
        cell.model = self.dataArray[indexPath.row-1];
        cell.floorLabel.text = [NSString stringWithFormat:@"%ld 楼", indexPath.row];
        return cell;
    }
    
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath{
    
    if (indexPath.row == 0) {
        CGFloat height = [NSString heightWithFontSize:15.0f size:CGSizeMake(kScreen_Width-65, MAXFLOAT) str:self.model.contentStr];
        CGFloat heightM =  height + 10 + 20 + 10 +20 + 10 + 10 + 10;
        if (self.model.imagePicStr.length) {
            heightM += 90;
        }
        return heightM;

    }else{
        return [[ReplyTableViewCell alloc] cellHeightWithMode:self.dataArray[indexPath.row -1]];
    }
}

- (void)keyboardShow:(NSNotification *)aNotification{
    self.zhezhaoView.hidden = NO;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
    int height = keyboardRect.size.height;
    
    NSIndexPath *indexPath = [NSIndexPath indexPathForRow:self.dataArray.count inSection:0];
//    self.tableView.contentOffset = CGPointMake(0, height);
     [self.tableView scrollToRowAtIndexPath:indexPath atScrollPosition:UITableViewScrollPositionNone animated:YES];
    
    CGRect frame = self.sendCommentView.frame;
    frame.origin.y = kScreen_Height - height - 44-65;
    self.sendCommentView.frame = frame;
    _show = YES;
}

- (void)keyboardHide:(NSNotification *)aNotification{
    self.zhezhaoView.hidden = YES;
    //获取键盘的高度
    NSDictionary *userInfo = [aNotification userInfo];
    NSValue *aValue = [userInfo objectForKey:UIKeyboardFrameEndUserInfoKey];
    CGRect keyboardRect = [aValue CGRectValue];
//    int height = keyboardRect.size.height;
    
//    self.tableView.contentOffset = CGPointMake(0, height);
    _sendCommentView.frame = CGRectMake(0, CGRectGetMaxY(self.tableView.frame), kScreen_Height, 44);
    [self.view endEditing:YES];
   
    _show = NO;
    
}

- (void)diss{
    [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:self];
    self.zhezhaoView.hidden = YES;
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
//    if (_show) {
//        [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillShowNotification object:self];
//    }else{
//        [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:self];
//    }
}

- (void)sendReply:(UIButton *)sender{
    
    if (![User shareUser].islogin) {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"温馨提示" message:@"此操作需要先登入，请先登录" delegate:self cancelButtonTitle:@"取消" otherButtonTitles:@"前往登入", nil];
        [alert show];
        return;

    }
    
    if ([NSString stringContainsEmoji:self.replyContentView.text]) {
        [self showToastWithMessage:@"标题不能包含表情，请删除表情后再发布"];
        return;
    }
    
    NSMutableDictionary *dict = [[NSMutableDictionary alloc] init];
    [dict setObject:self.model.topicID forKey:@"topic_id"];
    [dict setObject:[User shareUser].userID forKey:@"user_id"];
    [dict setObject:self.replyContentView.text forKey:@"body"];
    [dict setObject:self.replyContentView.text forKey:@"title"];
    
    if (_couldSend) {
        return;
    }
    _couldSend = YES;
    [[GoldenLeafNetworkAPIManager shareManager] request_createRepltWithParams:dict topicID:self.model.topicID andBlock:^(id data, NSError *error) {
//        DebugLog(@"%@", data);
        self.replyContentView.text = @"";
        [self loadData];
        _couldSend = YES;
        [[NSNotificationCenter defaultCenter] postNotificationName:UIKeyboardWillHideNotification object:self];
    }];
}

- (void)alertView:(UIAlertView *)alertView clickedButtonAtIndex:(NSInteger)buttonIndex{
    if (buttonIndex == 1) {
        LoginViewController *control = [[UIStoryboard storyboardWithName:@"Login" bundle: nil] instantiateInitialViewController];
        //    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:control];
        [self presentViewController:control animated:YES completion:nil];
    }
}
@end
