//
//  ReplyTableViewCell.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/29.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "ReplyTableViewCell.h"
#import "ReplyModel.h"
@interface ReplyTableViewCell ()
@property(nonatomic, strong) UIImageView *iconImageView;
@property(nonatomic, strong) UILabel *userNameL;
@property(nonatomic, strong) UILabel *cityLabel;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UIButton *replyButton;

@property(nonatomic, strong) UIView *bgView;
@end
@implementation ReplyTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if ( self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        [self initView];
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)initView{
    _iconImageView = [[UIImageView alloc] initWithFrame:CGRectMake(10+25+10, 10, 25, 25)];
//    _iconImageView.image = [UIImage imageNamed:@"common_icon_male"];
    _userNameL = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _userNameL.font = [UIFont systemFontOfSize:15.0f];
    _userNameL.textColor = rgb(237, 188, 0);
    _userNameL.numberOfLines = 1;
    
    _cityLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _cityLabel.font = [UIFont systemFontOfSize:15.0f];
    _cityLabel.numberOfLines = 1;
    
    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _contentLabel.font = [UIFont systemFontOfSize:15.0f];
    _contentLabel.numberOfLines = 1;

    _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _contentLabel.font = [UIFont systemFontOfSize:15.0f];
    _contentLabel.numberOfLines = 0;

    _timeLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
    _timeLabel.font = [UIFont systemFontOfSize:15.0f];
    _timeLabel.numberOfLines = 1;

    _floorLabel = [[UILabel alloc] initWithFrame:CGRectMake(kScreen_Width-50-10, 10, 50, 20)];
    _floorLabel.font = [UIFont systemFontOfSize:15.0f];
    _floorLabel.numberOfLines = 1;
    _floorLabel.textColor = [UIColor lightGrayColor];
    _floorLabel.textAlignment = NSTextAlignmentRight;
    
    _replyButton = [UIButton buttonWithType:UIButtonTypeCustom];
//    _replyButton.backgroundColor = [UIColor whiteColor];
    _replyButton.frame = CGRectMake(kScreen_Width-10-50, CGRectGetMaxY(_floorLabel.frame)+20, 50, 30);
    _replyButton.layer.cornerRadius = 2.0f;
    [_replyButton setTitle:@"回复" forState:UIControlStateNormal];
//    _replyButton.contentHorizontalAlignment = UIControlContentHorizontalAlignmentRight;
    [_replyButton setFont:[UIFont systemFontOfSize:17.0f]];
//    [_replyButton setTitleColor:rgb(237, 188, 0) forState:UIControlStateNormal];
    
    [_replyButton setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
    [_replyButton setBackgroundColor:[UIColor whiteColor]];
    [_replyButton addTarget:self action:@selector(replayDidClicked:) forControlEvents:UIControlEventTouchUpInside];
    
    _bgView = [[UIView alloc] init];
    _bgView.backgroundColor = rgb(235, 235, 235);
    
    [self.contentView addSubview:_bgView];
    [self.contentView addSubview:_iconImageView];
    [self.contentView addSubview:_cityLabel];
    [self.contentView addSubview:_contentLabel];
    [self.contentView addSubview:_timeLabel];
    [self.contentView addSubview:_replyButton];
    [self.contentView addSubview:_userNameL];
    [self.contentView addSubview:_floorLabel];
    
}
//*iconImageView;
//@property(nonatomic, strong) UILabel *userNameL;
//@property(nonatomic, strong) UILabel *cityLabel;
//@property(nonatomic, strong) UILabel *contentLabel;
//@property(nonatomic, strong) UILabel *timeLabel;
//@property(nonatomic, strong) UIButton *replyButton;

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat X = CGRectGetMaxX(_iconImageView.frame) + 10;
    CGFloat width = [NSString widthWithFontSize:15.0f size:CGSizeMake(CGFLOAT_MAX, 20) str:_model.userNameStr];
    _userNameL.frame = CGRectMake(X, 10, width, 20);
    
    _cityLabel.frame = CGRectMake(CGRectGetMaxX(_userNameL.frame)+10, 10, 100, 20);
    
    CGFloat height = [NSString heightWithFontSize:15.0f size:CGSizeMake(kScreen_Width-CGRectGetMinX(_userNameL.frame)-50, CGFLOAT_MAX) str:_model.contentStr];
    _contentLabel.frame = CGRectMake(X, CGRectGetMaxY(_userNameL.frame)+10, kScreen_Width-CGRectGetMinX(_userNameL.frame)-50, height);
    
    _timeLabel.frame = CGRectMake(X, CGRectGetMaxY(_contentLabel.frame) + 10, 100, 20);
    _timeLabel.text = _model.timeStr;
    
    CGFloat cellHeight = height + 10 + 20 + 10 + 20 +10 + 10;
    _bgView.frame = CGRectMake(0, 5, kScreen_Width, cellHeight-10);
    if(_model.doctor){
        //        _iconImageV.image = [UIImage imageNamed:@"common_icon_male"];
//        [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.iconImageURLStr] placeholderImage:[UIImage imageNamed:@"common_icon_doctor"]];
        _iconImageView.image = [UIImage imageNamed:@"common_icon_doctor"];
    }else{
        if (self.model.iconImageURLStr) {
            
            if ([self.model.sex isEqualToString:@"男"]) {
                [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.iconImageURLStr] placeholderImage:[UIImage imageNamed:@"common_icon_male"]];
            }else{
                [_iconImageView sd_setImageWithURL:[NSURL URLWithString:self.model.iconImageURLStr] placeholderImage:[UIImage imageNamed:@"common_icon_female"]];
            }
            
        }
    }

    
    
}
- (void)setModel:(ReplyModel *)model{
    _model = model;
    _userNameL.text = model.userNameStr;
    _cityLabel.text = model.cityStr;
    _contentLabel.text = model.contentStr;
    [_iconImageView sd_setImageWithURL:[NSURL URLWithString:model.iconImageURLStr] placeholderImage:[UIImage imageNamed:@"common_icon_male"]];
    [self setNeedsLayout];
    
}

- (CGFloat)cellHeightWithMode:(ReplyModel *)model{
    CGFloat height = [NSString heightWithFontSize:15.0f size:CGSizeMake(kScreen_Width-CGRectGetMinX(_userNameL.frame)-50, CGFLOAT_MAX) str:_model.contentStr];
    CGFloat heightM = height + 10 + 20 + 10 + 20 +10 + 10 +10+10;
    return heightM;
}

- (void)replayDidClicked:(UIButton *)sender{
    if (self.block) {
        self.block(self.model);
    }
}
@end
