//
//  UIBarButtonItem+Common.m
//  yufu
//
//  Created by 李小虎 on 15/5/26.
//  Copyright (c) 2015年 lee. All rights reserved.
//

#import "UIBarButtonItem+Common.h"

@implementation UIBarButtonItem (Common)

+(instancetype)itemWithImageName:(NSString *)imageName target:(id)obj action:(SEL)action{
    UIImage *image = [UIImage imageNamed:imageName];
    UIButton *button = [[UIButton alloc] initWithFrame:CGRectMake(0, 0, image.size.width, image.size.height)];
    [button setImage:image forState:UIControlStateNormal];
    [button addTarget:obj action:action forControlEvents:UIControlEventTouchUpInside];
    UIBarButtonItem *barBtn = [[UIBarButtonItem alloc] initWithCustomView:button];
    return barBtn;
}
@end
