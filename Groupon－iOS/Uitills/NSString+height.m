//
//  NSString+height.m
//  GoldenLeaf_iOS
//
//  Created by lixiaohu on 15/9/28.
//  Copyright (c) 2015年 lixiaohu. All rights reserved.
//

#import "NSString+height.h"

@implementation NSString (height)

+ (CGFloat)heightWithFontSize:(CGFloat)fontSize size:(CGSize)size str:(NSString *)str{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                                  NSParagraphStyleAttributeName : paragraphStyle};
//    NSDictionary *attbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGFloat height =[str boundingRectWithSize:size options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.height;
    CGFloat m = height / 15;
    NSInteger num = height/15;
    if ((m - num )> 0 ) {
        num ++;
    }
    
    return height+5;
}

+ (CGFloat)widthWithFontSize:(CGFloat)fontSize size:(CGSize)size str:(NSString *)str{
    NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
    paragraphStyle.lineBreakMode = NSLineBreakByCharWrapping;
    paragraphStyle.alignment = NSTextAlignmentLeft;
    
    NSDictionary * attributes = @{NSFontAttributeName : [UIFont systemFontOfSize:fontSize],
                                  NSParagraphStyleAttributeName : paragraphStyle};
    //    NSDictionary *attbute = @{NSFontAttributeName:[UIFont systemFontOfSize:fontSize]};
    CGFloat width =[str boundingRectWithSize:size options: NSStringDrawingUsesLineFragmentOrigin attributes:attributes context:nil].size.width;
    
    return width+5;
}
//NSMutableParagraphStyle * paragraphStyle = [[NSMutableParagraphStyle alloc] init];
//paragraphStyle.lineBreakMode = self.lineBreakMode;
//paragraphStyle.alignment = self.textAlignment;
//
//NSDictionary * attributes = @{NSFontAttributeName : self.font,
//                              NSParagraphStyleAttributeName : paragraphStyle};
//
//CGSize contentSize = [self.text boundingRectWithSize:CGSizeMake(self.frame.size.width, MAXFLOAT)
//                                             options:(NSStringDrawingUsesLineFragmentOrigin|NSStringDrawingUsesFontLeading)
//                                          attributes:attributes
//                                             context:nil].size;
//return contentSize;
@end
