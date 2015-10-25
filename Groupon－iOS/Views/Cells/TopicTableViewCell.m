//
//  TopicTableViewCell.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/28.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "TopicTableViewCell.h"
#import "TopicModel.h"
@interface TopicTableViewCell (){
    CGFloat _cellheight;
}
@property(nonatomic, strong) UIImageView *iconImageV;
@property(nonatomic, strong) UILabel *contentLabel;
@property(nonatomic, strong) UIImageView *pciImageView;
@property(nonatomic, strong) UILabel *userNameLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property (nonatomic, strong) UILabel *replyCountLabel;
@property(nonatomic, strong) UIView *backgroudView;

@end
@implementation TopicTableViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    self = [super initWithStyle:style reuseIdentifier:reuseIdentifier];
    if (self) {
        [self initView];
        self.contentView.backgroundColor = [UIColor clearColor];
        self.backgroundColor = [UIColor clearColor];
    }
    return self;
}

- (void)initView{
    _backgroudView = [[UIView alloc] init];
    _backgroudView.backgroundColor = [UIColor whiteColor];
    [self.contentView addSubview:_backgroudView];
    
    _iconImageV = [[UIImageView alloc] init];
    _iconImageV.image = [UIImage imageNamed:@"common_icon_male"];
    _iconImageV.clipsToBounds = YES;
//    _iconImageV.layer.cornerRadius
    [self.contentView addSubview:_iconImageV];
    
    _contentLabel = [[UILabel alloc] init];
    _contentLabel.font = [UIFont systemFontOfSize:14.0f];
    _contentLabel.numberOfLines = 2;
    _contentLabel.textAlignment = NSTextAlignmentLeft;
    _contentLabel.lineBreakMode = NSLineBreakByWordWrapping;
    [_contentLabel sizeToFit];
//    _contentLabel.backgroundColor = [UIColor redColor];
    [self.contentView addSubview:_contentLabel];
    
    _pciImageView = [[UIImageView alloc] init];
    _pciImageView.image = [UIImage imageNamed:@"firstpage_purplebg"];
    [self.contentView addSubview:_pciImageView];
    
    _userNameLabel = [[UILabel alloc] init];
    _userNameLabel.textColor = [UIColor lightGrayColor];
    _userNameLabel.font = [UIFont systemFontOfSize:15.0f];
    _userNameLabel.numberOfLines = 1;
    [self.contentView addSubview:_userNameLabel];
    
    _timeLabel = [[UILabel alloc] init];
    _timeLabel.textColor = [UIColor lightGrayColor];
    _timeLabel.font = [UIFont systemFontOfSize:13.0f];
    _timeLabel.numberOfLines = 0;
    [self.contentView addSubview:_timeLabel];
    
    _replyCountLabel = [[UILabel alloc] init];
    _replyCountLabel.font = [UIFont systemFontOfSize:15.0f];
    _replyCountLabel.textColor = [UIColor lightGrayColor];
    [self.contentView addSubview:_replyCountLabel];
    
    
    self.selectionStyle = UITableViewCellSelectionStyleNone;

}

- (void)layoutSubviews{
    [super layoutSubviews];
    @weakify(self);
    [_iconImageV mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(25, 25));
        make.left.mas_equalTo(self.contentView).with.offset(10);
        make.top.mas_equalTo(self.contentView).with.offset(20);
    }];
    
    if(_model.doctor){
//        _iconImageV.image = [UIImage imageNamed:@"common_icon_male"];
//        [_iconImageV sd_setImageWithURL:[NSURL URLWithString:self.model.iconImageStr] placeholderImage:[UIImage imageNamed:@"common_icon_doctor"]];
        _iconImageV.image = [UIImage imageNamed:@"common_icon_doctor"];
    }else{
        if (self.model.iconImageStr) {
            
            if ([self.model.sex isEqualToString:@"男"]) {
                [_iconImageV sd_setImageWithURL:[NSURL URLWithString:self.model.iconImageStr] placeholderImage:[UIImage imageNamed:@"common_icon_male"]];
            }else{
                [_iconImageV sd_setImageWithURL:[NSURL URLWithString:self.model.iconImageStr] placeholderImage:[UIImage imageNamed:@"common_icon_female"]];
            }
            
        }
    }
        [_contentLabel sizeToFit];
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 10 - 25 - 30;
//    CGFloat heigt = [NSString heightWithFontSize:15.0f size:CGSizeMake(width, MAXFLOAT) str:_model.contentStr] + 10;
    
//    [_contentLabel setNeedsUpdateConstraints];
    [_contentLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
//        make.size.mas_equalTo(CGSizeMake(width, heigt));
        make.width.mas_offset(width);
//        make.height.mas_offset(heigt);
        make.top.mas_equalTo(self.contentView).offset(20);
        make.left.mas_equalTo(self.iconImageV.mas_right).offset(10);
    }];
    _contentLabel.text = self.model.contentStr;
    [_contentLabel sizeToFit];
    
    [_pciImageView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(120, 65));
        make.top.mas_equalTo(self.contentLabel.mas_bottom).offset(10);
        make.left.mas_equalTo(self.iconImageV.mas_right).offset(10);
    }];
    [_pciImageView sd_setImageWithURL:[NSURL URLWithString:_model.imagePicStr] placeholderImage:[UIImage imageNamed:@"appicon_114"]];
//    if (self.model.imagePicStr) {
//        [_iconImageV sd_setImageWithURL:[NSURL URLWithString:self.model.imagePicStr] placeholderImage:[UIImage imageNamed:@"firstpage_purplebg"]];
//    }
    
    [_userNameLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(150, 25));
        make.bottom.mas_equalTo(self.contentView).offset(-5);
        make.left.mas_equalTo(self.iconImageV.mas_right).offset(10);
    }];
    
    
    [_replyCountLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.bottom.mas_equalTo(self.contentView).offset(-5);
        make.size.mas_equalTo(CGSizeMake(50, 30));
        make.right.mas_equalTo(self.contentView).offset(10);
    }];
    
    [_timeLabel mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.size.mas_equalTo(CGSizeMake(100, 30));
        make.bottom.mas_equalTo(self.contentView).offset(-5);
        make.right.mas_equalTo(self.replyCountLabel.mas_left).offset(10);
    }];
    
    [_backgroudView mas_makeConstraints:^(MASConstraintMaker *make) {
        @strongify(self);
        make.edges.equalTo(self.contentView).insets(UIEdgeInsetsMake(10, 0, 0, 0));
    }];
    if (self.model.imagePicStr.length > 0) {
        self.pciImageView.hidden = NO;
    }else{
        self.pciImageView.hidden = YES;
    }
    [_contentLabel updateConstraints];
//    _cellheight = 10 + heigt + 10 +30 +10;
}

- (void)setModel:(TopicModel *)model{
    _model = model;
    _contentLabel.text = model.contentStr;
    _userNameLabel.text = model.userNameStr;
    _replyCountLabel.text = model.replyCountStr;
    _timeLabel.text = model.timeStr;
//    [_contentLabel sizeToFit];
    [self setNeedsLayout];
}

- (CGFloat)cellHeightWithMode:(TopicModel *)model{
    CGFloat width = [UIScreen mainScreen].bounds.size.width - 10 - 25 - 30;
//    CGFloat heigt = [NSString heightWithFontSize:15.0f size:CGSizeMake(width, MAXFLOAT) str:model.contentStr];
    CGFloat cellHeight;
    if (model.imagePicStr.length > 0) {
        cellHeight = 20 + 60.0f + 65.0f +10;
    }else{
        cellHeight = 20 + 60.0f +10;
    }
    return cellHeight;
}
@end
