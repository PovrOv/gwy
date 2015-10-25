//
//  UIBarButtonItem+Common.h
//  yufu
//
//  Created by 李小虎 on 15/5/26.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface UIBarButtonItem (Common)
+(instancetype)itemWithImageName:(NSString *)imageName target:(id)obj action:(SEL)action;
@end
