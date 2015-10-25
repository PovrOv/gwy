//
//  ClincDetailHeadViewCell.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/10/11.
//  Copyright © 2015年 lixiaohu. All rights reserved.
//

#import "ClincDetailHeadViewCell.h"
#define KSpace 15
@interface ClincDetailHeadViewCell ()
@property(nonatomic, strong) UIImageView *headImageView;
@property(nonatomic, strong) UILabel *titleLabel;
@property(nonatomic, strong) UILabel *contentLabel;


@end
@implementation ClincDetailHeadViewCell

- (instancetype)initWithStyle:(UITableViewCellStyle)style reuseIdentifier:(NSString *)reuseIdentifier{
    if (self = [super initWithStyle:style reuseIdentifier:reuseIdentifier]) {
        _headImageView = [[UIImageView alloc] init];
        _titleLabel = [[UILabel alloc] init];
        _titleLabel.font = [UIFont systemFontOfSize:14.0f];
        _contentLabel = [[UILabel alloc] init];
        _contentLabel.font = [UIFont systemFontOfSize:14.0f];
        _lookMapButton = [[UIButton alloc] init];
        
        [self.contentView addSubview:_headImageView];
        [self.contentView addSubview:_titleLabel];
        [self.contentView addSubview:_contentLabel];
        
        
        self.selectionStyle = UITableViewCellSelectionStyleNone;
    }
    return self;
}

- (void)layoutSubviews{
    [super layoutSubviews];
    if (_model) {
        _headImageView.frame = CGRectMake(KSpace, KSpace, kScreen_Width-2*KSpace, 120);
        _titleLabel.frame = CGRectMake(KSpace, KSpace+CGRectGetMaxY(_headImageView.frame), kScreen_Width-2*KSpace, 20);
        CGFloat height = [NSString heightWithFontSize:14.0f size:CGSizeMake(kScreen_Width-2*KSpace, CGFLOAT_MAX) str:_model.contentStr];
        _contentLabel.frame = CGRectMake(KSpace, KSpace+CGRectGetMaxY(_titleLabel.frame), kScreen_Width-2*KSpace, height+10);
        
        UIView *lineView = [[UIView alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(_contentLabel.frame)+KSpace, kScreen_Width, 1)];
        lineView.backgroundColor = rgb(215, 215, 215);
        [self.contentView addSubview:lineView];
        
        _lookMapButton.frame = CGRectMake(kScreen_Width-60-KSpace, CGRectGetMaxY(lineView.frame)+KSpace, 60, 30);
        [_lookMapButton.titleLabel setFont:[UIFont systemFontOfSize:13.0f]];
        _lookMapButton.tag = 1000;
        [_lookMapButton setTitle:@"查看地图" forState:UIControlStateNormal];
        [_lookMapButton setBackgroundColor:rgb(126, 171, 50)];
        
        
        UILabel *addressTitleL = [[UILabel alloc] initWithFrame:CGRectMake(KSpace, CGRectGetMaxY(lineView.frame)+KSpace, 100, 20)];
        addressTitleL.text = @"医院地址:";
        addressTitleL.font = [UIFont systemFontOfSize:14.0f];
        addressTitleL.textColor = rgb(126, 171, 50);
//        addressTitleL.backgroundColor = [UIColor redColor];
        [self.contentView addSubview:addressTitleL];
        
        for (int i=0; i<_model.addressArray.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KSpace, CGRectGetMaxY(addressTitleL.frame)+10+i*20, kScreen_Width-2*KSpace, 20)];
            label.text = _model.addressArray[i];
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textColor = [UIColor lightGrayColor];
//            label.backgroundColor = [UIColor redColor];
            [self.contentView addSubview:label];
        }
        
        UILabel *codeLabel = [[UILabel alloc] initWithFrame:CGRectMake(KSpace, CGRectGetMaxY(addressTitleL.frame)+KSpace+_model.addressArray.count*20, 100, 20)];
        codeLabel.text = [NSString stringWithFormat:@"邮编: %@",_model.postal_code];
        codeLabel.font = [UIFont systemFontOfSize:14.0f];
        codeLabel.textColor = rgb(126, 171, 50);
        [self.contentView addSubview:codeLabel];
        
        UILabel *telLabel = [[UILabel alloc] initWithFrame:CGRectMake(KSpace, CGRectGetMaxY(codeLabel.frame)+KSpace, 100, 20)];
        telLabel.text = @"电话:";
        telLabel.textColor = rgb(126, 171, 50);
        telLabel.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:telLabel];
        
        for (int i=0; i<_model.telArray.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KSpace, CGRectGetMaxY(telLabel.frame)+i*20, kScreen_Width-2*KSpace, 20)];
            label.text = _model.telArray[i];
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textColor = [UIColor lightGrayColor];
            [self.contentView addSubview:label];
        }
        
        UILabel *transportationL = [[UILabel alloc] initWithFrame:CGRectMake(KSpace, CGRectGetMaxY(telLabel.frame)+KSpace+_model.transportationArray.count*20, 100, 20)];
        transportationL.text = @"交通:";
        transportationL.textColor = rgb(126, 171, 50);
        transportationL.font = [UIFont systemFontOfSize:14.0f];
        [self.contentView addSubview:transportationL];
        
        for (int i=0; i<_model.transportationArray.count; i++) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(KSpace, CGRectGetMaxY(transportationL.frame)+i*20, kScreen_Width-2*KSpace, 20)];
            label.text = _model.transportationArray[i];
            label.font = [UIFont systemFontOfSize:14.0f];
            label.textColor = [UIColor lightGrayColor];
            [self.contentView addSubview:label];
        }
        [self.contentView addSubview:_lookMapButton];
    }
}

- (void)setModel:(ClincDetaiHeadModel *)model{
//    _headImageView sd_setImageWithURL:<#(NSURL *)#> placeholderImage:<#(UIImage *)#>
    _model = model;
    [_headImageView sd_setImageWithURL:[NSURL URLWithString:model.headImageUrlStr]];
    _titleLabel.text = model.name;
    _contentLabel.text = model.contentStr;
    
    [self setNeedsLayout];
}

+ (CGFloat)cellHeightWithModel:(ClincDetaiHeadModel *)model{
    CGFloat contentHeight = [NSString heightWithFontSize:14.0f size:CGSizeMake(kScreen_Width-2*KSpace, CGFLOAT_MAX) str:model.contentStr] +10;
    
    CGFloat cellHeight = 120 + 20 + 20 + model.addressArray.count*20 + 20 + model.telArray.count*20 + 20 + 20 + model.transportationArray.count*20 + contentHeight +9*KSpace;
    return cellHeight;
}
@end
