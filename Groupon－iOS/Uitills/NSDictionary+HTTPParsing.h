//
//  NSDictionary+HTTPParsing.h
//  GoldenLeaf
//
//  Created by Sissi Chen on 7/15/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

@import Foundation;

@interface NSDictionary (HTTPParsing)

/// Returns a string created by encoding all the key/value pairs contained in
/// this dictionary as a query string using application/x-www-form-urlencoded
/// encoding.
///
/// @return A query string representation of this dictionary.
- (NSString *)queryStringValue;

@end
