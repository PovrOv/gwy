//
//  NSString+BBStringAdditions.h
//  GoldenLeaf
//
//  Created by Sissi Chen on 7/15/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

@import Foundation;

@interface NSString (BBStringAdditions)

- (BOOL)containsString:(NSString *) string;
- (BOOL)containsString:(NSString *) string options:(NSStringCompareOptions) options;
- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding;
@end
