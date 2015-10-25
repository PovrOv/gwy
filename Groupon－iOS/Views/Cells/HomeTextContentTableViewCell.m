//
//  HomeTextContentTableViewCell.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/8/13.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "HomeTextContentTableViewCell.h"

@interface HomeTextContentTableViewCell ()

@property (weak, nonatomic) IBOutlet NSLayoutConstraint *contentLabelConstraint;
@property (weak, nonatomic) IBOutlet UIView *bgView;
@property (nonatomic, strong) NSDictionary *selectedData;

@end
@implementation HomeTextContentTableViewCell
- (void)showToastWithMessage:(NSString *)msg{
    CGPoint point = CGPointMake(kScreen_Width/2, kScreen_Height/2);
    [[[UIApplication sharedApplication] keyWindow] makeToast:msg duration:0.3 position:[NSValue valueWithCGPoint:point]];
}
+ (CGFloat)cellHeight{
    return 120;
}
- (void)awakeFromNib {
    // Initialization code
    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animation) name:@"returnBack" object:nil];
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kScreen_Width-40-30, 50)];
//    _contentLabel.backgroundColor = [UIColor redColor];
    _contentLabel.numberOfLines = 3;
    [_bgView insertSubview:_contentLabel atIndex:0];
    [self animation];
    
    
}
- (instancetype)cellWithTableView:(UITableView *)tableView{
    HomeTextContentTableViewCell *cell = [[[NSBundle mainBundle] loadNibNamed:@"cell" owner:self options:nil] objectAtIndex:0];
    
    
//    [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(animation) name:@"returnBack" object:nil];
//    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(40, 0, kScreen_Width-40-30, 30)];
//    _contentLabel.numberOfLines = 2;
//    _contentLabel.backgroundColor = [UIColor redColor];
//    [cell.bgView insertSubview:_contentLabel atIndex:0];
//    [self animation];
    return cell;
    
}
- (IBAction)clickedAction:(id)sender {
    if (self.dataArray.count) {
        if ([self.delegate respondsToSelector:@selector(cellDidClicked:)]) {
            [self.delegate cellDidClicked:self.selectedData];
        }

    }else{
        [self showToastWithMessage:@"暂无公告"];
    }
}

- (void)animation
{
    
    [UIView animateWithDuration:3 animations:^{
        
        CGRect frame = _contentLabel.frame;
        frame.origin.y = 75;
        _contentLabel.frame = frame;
    }
                     completion:^(BOOL finished) {
//                         if (finished) {
//                             [UIView animateWithDuration:1.5f animations:^{
                                 CGRect frame = _contentLabel.frame;
                                 frame.origin.y = 0;
                                 _contentLabel.frame = frame;
//
//                             } completion:^(BOOL finished) {
////                                 if (finished) {
//                                 self.selectedData
                                 if (self.dataArray.count) {
                                     NSInteger count = self.dataArray.count;
                                     NSInteger selectedIndex = random()%count;
                                     self.selectedData = self.dataArray[selectedIndex];
                                     NSString *content = [NSString stringWithFormat:@"%@\n%@", self.selectedData[@"title"], self.selectedData[@"body"]];
                                     _contentLabel.text =content;

                                 }else{
                                     _contentLabel.text = @"暂无公告";
                                 }
                                [self animation];
//                                 }
//                             }];
//                         }
                     }];
}
- (void)setSelected:(BOOL)selected animated:(BOOL)animated {
    [super setSelected:selected animated:animated];

    // Configure the view for the selected state
}

- (void)dealloc{
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}
@end
