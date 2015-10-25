//
//  NSDictionary+HTTPParsing.m
//  GoldenLeaf
//
//  Created by Sissi Chen on 7/15/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

#import "NSDictionary+HTTPParsing.h"

#import "NSString+HTTPParsing.h"

@implementation NSDictionary (HTTPParsing)

/// Returns a string created by encoding all the key/value pairs contained in
/// this dictionary as a query string using application/x-www-form-urlencoded
/// encoding.
///
/// @return A query string representation of this dictionary.
- (NSString *)queryStringValue {
    NSMutableArray *compositeParameters = [NSMutableArray arrayWithCapacity:self.count];

    for (NSString *name in self) {
        id val = self[name];

        if ([val isKindOfClass:[NSString class]]) {
            [compositeParameters addObject:[NSString stringWithFormat:@"%@=%@",
                                            [name stringByPercentEncoding],
                                            [val stringByPercentEncoding]]];
        } else if ([val isKindOfClass:[NSNumber class]]) {
            [compositeParameters addObject:[NSString stringWithFormat:@"%@=%@",
                                            [name stringByPercentEncoding],
                                            [val stringValue]]];
        } else {
            [compositeParameters addObject:[name stringByPercentEncoding]];
        }
    }

    return [compositeParameters componentsJoinedByString:@"&"];
}

@end
