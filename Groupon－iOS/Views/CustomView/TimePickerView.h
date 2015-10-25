//
//  TimePickerView.h
//  datePickerView
//
//  Created by lixiaohu on 15/9/19.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>
@class TimePickerView;
@protocol TimePickerViewDelegate <NSObject>

- (void)timePickerViewDidFinish:(TimePickerView *)pickerView str:(NSString *)timeStr;

@end

@interface TimePickerView : UIView

@property(nonatomic, weak)id<TimePickerViewDelegate> delegate;
//@property(nonatomic, assign)NSInteger times;
- (void)show;
- (instancetype)initWithFrame:(CGRect)frame withTimes:(NSInteger)times;
@end
