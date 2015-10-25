//
//  TopicDetailCell.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/29.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "TopicDetailCell.h"
#import "TopicModel.h"

@interface TopicDetailCell ()
@property(strong, nonatomic) UILabel *contentLabel;
@property(nonatomic, strong) UIImageView *iconV;
@property(nonatomic, strong) UILabel *nameLabel;
@property(nonatomic, strong) UILabel *timeLabel;
@property(nonatomic, strong) UILabel *countLabel;
@property(nonatomic, strong) UILabel *cityLabel;
@property(nonatomic, strong) UIImageView *picImageView;
@end
@implementation TopicDetailCell
- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _contentLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _contentLabel.font = [UIFont systemFontOfSize:15.0f];
        _contentLabel.numberOfLines = 0;
        
        _iconV = [[UIImageView alloc] initWithFrame:CGRectMake(10, 10, 25, 25)];
//        _iconV.image = [UIImage imageNamed:@"common_icon_male"];
        
        _nameLabel = [[UILabel alloc] initWithFrame:CGRectMake(0, 0, 0, 0)];
        _nameLabel.font = [UIFont systemFontOfSize:15.0f];
        _nameLabel.textColor = rgb(237, 188, 0);
        _nameLabel.numberOfLines = 1;
        
        _cityLabel = [[UILabel alloc] init];
        _cityLabel.font = [UIFont systemFontOfSize:15.0f];
        _cityLabel.numberOfLines = 1;
        
        _timeLabel = [[UILabel alloc] init];
        _timeLabel.font = [UIFont systemFontOfSize:15.0f];
        _timeLabel.numberOfLines = 1;
        
        _countLabel = [[UILabel alloc] init];
        _countLabel.font = [UIFont systemFontOfSize:15.0f];
        _countLabel.numberOfLines = 1;
        
        _picImageView = [[UIImageView alloc] init];
        
        
        [self.contentView addSubview:_iconV];
        [self.contentView addSubview:_contentLabel];
        [self.contentView addSubview:_nameLabel];
        [self.contentView addSubview:_cityLabel];
        [self.contentView addSubview:_countLabel];
        [self.contentView addSubview:_timeLabel];
        [self.contentView addSubview:_picImageView];
        
        self.backgroundColor = rgb(245, 245, 245);
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    CGFloat X = CGRectGetMaxX(_iconV.frame) + 10;
    CGFloat width = [NSString widthWithFontSize:15.0f size:CGSizeMake(CGFLOAT_MAX, 20) str:_model.userNameStr];
    _nameLabel.frame = CGRectMake(X, 10, width, 20);
    
    _cityLabel.frame = CGRectMake(X+width+10, 10, 100, 20);
    
    CGFloat timewidth = [NSString widthWithFontSize:15.0f size:CGSizeMake(CGFLOAT_MAX, 20) str:_model.timeStr];
    _timeLabel.frame = CGRectMake(X, CGRectGetMaxY(_nameLabel.frame) + 10, timewidth, 20);
    _countLabel.frame = CGRectMake(X+timewidth+10, CGRectGetMaxY(_nameLabel.frame) + 10, 100, 20);
    
    CGFloat heigt = [NSString heightWithFontSize:15.0f size:CGSizeMake(kScreen_Width-65, MAXFLOAT) str:_model.contentStr];
    _contentLabel.frame = CGRectMake(X, CGRectGetMaxY(_timeLabel.frame) + 10, kScreen_Width-65, heigt);
    _picImageView.frame = CGRectMake(X, CGRectGetMaxY(_contentLabel.frame)+10, 200, 90);
    if (_model.imagePicStr.length) {
        _picImageView.hidden = NO;
        [_picImageView sd_setImageWithURL:[NSURL URLWithString:_model.imagePicStr] placeholderImage:[UIImage imageNamed:@"appicon_114"]];
    }else{
        _picImageView.hidden = YES;
    }
    
    if(_model.doctor){
        //        _iconImageV.image = [UIImage imageNamed:@"common_icon_male"];
//        [_iconV sd_setImageWithURL:[NSURL URLWithString:self.model.iconImageStr] placeholderImage:[UIImage imageNamed:@"common_icon_doctor"]];
        _iconV.image = [UIImage imageNamed:@"common_icon_doctor"];
    }else{
        if (self.model.iconImageStr) {
            
            if ([self.model.sex isEqualToString:@"男"]) {
                [_iconV sd_setImageWithURL:[NSURL URLWithString:self.model.iconImageStr] placeholderImage:[UIImage imageNamed:@"common_icon_male"]];
            }else{
                [_iconV sd_setImageWithURL:[NSURL URLWithString:self.model.iconImageStr] placeholderImage:[UIImage imageNamed:@"common_icon_female"]];
            }
            
        }
    }

    
}

- (void)setModel:(TopicModel *)model{
    _model = model;
    _contentLabel.text = model.contentStr;
    _nameLabel.text = model.userNameStr;
    _cityLabel.text = model.city;
    _timeLabel.text = model.timeStr;
    _countLabel.text = model.replyCountStr;
    
    if(_model.doctor){
        _iconV.image = [UIImage imageNamed:@"common_icon_male"];
    }else{
        if (self.model.iconImageStr) {
            [_iconV sd_setImageWithURL:[NSURL URLWithString:self.model.iconImageStr] placeholderImage:[UIImage imageNamed:@"common_icon_male"]];
        }
    }
    [self setNeedsLayout];
}
//+ (CGFloat)cellHeight{
//  
//    
//}
//rgb(237, 188, 0)
@end
