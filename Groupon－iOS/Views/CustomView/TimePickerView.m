//
//  TimePickerView.m
//  datePickerView
//
//  Created by lixiaohu on 15/9/19.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "TimePickerView.h"

@interface TimePickerView ()
@property(nonatomic, strong)NSMutableArray *datePickerArray;
@property(nonatomic, assign)NSInteger times;
@end
@implementation TimePickerView

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect {
    // Drawing code
}
*/
- (instancetype)initWithFrame:(CGRect)frame withTimes:(NSInteger)times{
    self.times = times;
    return [self initWithFrame:frame];
}
- (instancetype)initWithFrame:(CGRect)frame{
    if (self = [super initWithFrame:frame]) {
        
        self.datePickerArray = [[NSMutableArray alloc] init];
//        view.frame = CGRectMake(0, 0, frame.size.width, 192);
        UIView *bgView = [[UIView alloc] initWithFrame:frame];
        bgView.backgroundColor = [UIColor blackColor];
        bgView.alpha = 0.6;
        UITapGestureRecognizer *gesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(diss)];
        [bgView addGestureRecognizer:gesture];
        [self addSubview:bgView];
        self.backgroundColor = [UIColor clearColor];
        
        
        UIScrollView *scrollView = [[UIScrollView alloc] initWithFrame:CGRectMake(0, CGRectGetHeight([UIScreen mainScreen].bounds)-400, CGRectGetWidth([UIScreen mainScreen].bounds), 400)];
        [self addSubview:scrollView];
        scrollView.backgroundColor = [UIColor whiteColor];
        scrollView.contentSize = CGSizeMake(CGRectGetWidth([UIScreen mainScreen].bounds), 250*3);
        for (NSInteger i = 0 ; i<self.times; i++) {
            UIView *view = [[[NSBundle mainBundle] loadNibNamed:@"TimePickerView" owner:self options:nil] objectAtIndex:0];
            view.frame = CGRectMake(0, i*250, CGRectGetWidth([UIScreen mainScreen].bounds), 192);
            UILabel *label = (UILabel *)[view viewWithTag:999];
            label.text = [NSString stringWithFormat:@"第%ld次服药时间", i + 1];
            [scrollView addSubview:view];
            
            [self.datePickerArray addObject:[view viewWithTag:998]];
        }
        self.alpha = 0;
        
        UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(CGRectGetWidth([UIScreen mainScreen].bounds)-100, CGRectGetMinY(scrollView.frame)-30, 100, 30)];
        [button setTitle:@"完成" forState:UIControlStateNormal];
        [button setTitleColor:[UIColor blackColor] forState:UIControlStateNormal];
        [button addTarget:self action:@selector(finish:) forControlEvents:UIControlEventTouchUpInside];
        [button setBackgroundColor:[UIColor whiteColor]];
        [self addSubview:button];
        
        if (self.times == 0) {
            UILabel *label = [[UILabel alloc] initWithFrame:CGRectMake(0, CGRectGetMaxY(button.frame) + 100, CGRectGetWidth([UIScreen mainScreen].bounds), 40)];
            label.font = [UIFont systemFontOfSize:25.0f];
            label.text = @"请先选择用药次数";
            label.textColor = [UIColor redColor];
            label.textAlignment = NSTextAlignmentCenter;
            [self addSubview:label];
        }
//        [self addSubview:view];
    }
    return self;
}

- (void)show{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 1;
    }];
}
- (void)diss{
    [UIView animateWithDuration:0.5 animations:^{
        self.alpha = 0;
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (UIDatePicker *datePicker in self.datePickerArray) {
            
            NSDate *select  = [datePicker date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            NSString *dateAndTime = [dateFormatter stringFromDate:select];
            [array addObject:dateAndTime];
            NSLog(@"%@",dateAndTime);
        }
        
        NSString *str = [array componentsJoinedByString:@","];
        if (self.times == 0) {
            [self.delegate timePickerViewDidFinish:self str:@"请选择用药时间"];
        }else{
            [self.delegate timePickerViewDidFinish:self str:str];
        }

    } completion:^(BOOL finished) {
        [self removeFromSuperview];
    }];
}

- (void)finish:(UIButton *)sender{
    if ([self.delegate respondsToSelector:@selector(timePickerViewDidFinish:str:)]) {
        NSMutableArray *array = [[NSMutableArray alloc] init];
        for (UIDatePicker *datePicker in self.datePickerArray) {
            
            NSDate *select  = [datePicker date];
            NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
            [dateFormatter setDateFormat:@"HH:mm"];
            NSString *dateAndTime = [dateFormatter stringFromDate:select];
            [array addObject:dateAndTime];
            NSLog(@"%@",dateAndTime);
        }
    
        NSString *str = [array componentsJoinedByString:@"   "];
        if (self.times == 0) {
            [self.delegate timePickerViewDidFinish:self str:@"请选择用药时间"];
        }else{
            [self.delegate timePickerViewDidFinish:self str:str];
        }
        
        [self diss];
    
    }
}
@end
