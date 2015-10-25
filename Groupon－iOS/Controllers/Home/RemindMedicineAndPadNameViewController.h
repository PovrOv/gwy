//
//  RemindMedicineAndPadNameViewController.h
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/18.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import <UIKit/UIKit.h>

typedef enum : NSUInteger {
    KMedicineName,
    KMedicineNum,
    KPadName,
    KPadNum
} RemindType;
@protocol RemindProtocol <NSObject>

- (void)ChangeTextInfo:(RemindType)type str:(NSString *)str;
@end
@interface RemindMedicineAndPadNameViewController : UITableViewController
@property(nonatomic, assign)RemindType type;
@property(nonatomic, weak)id<RemindProtocol> delegate;
@end
