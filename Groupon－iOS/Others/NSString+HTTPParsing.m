//
//  NSString+HTTPParsing.m
//  GoldenLeaf
//
//  Created by Sissi Chen on 7/15/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

#import "NSString+HTTPParsing.h"

#define kURLReservedCharacters CFSTR(":/?#[]@!$&'()*+,;=%")

@implementation NSString (HTTPParsing)

/// Returns a copy of this string percent encoded according to RFC 3986. Uses
/// the default string encoding for URIs which is UTF-8.
///
/// @return A new string created by URL encoding this string.
- (NSString *)stringByURLEncoding {
    return [self stringByURLEncodingUsingEncoding:kURLStringEncoding];
}

/// Returns a copy of this string percent encoded according to RFC 3986 using
/// the given string encoding.
///
/// @param encoding The string encoding in which to percent encode.
/// @return A new string created by URL encoding this string.
- (NSString *)stringByURLEncodingUsingEncoding:(NSStringEncoding)encoding {
    CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
    CFStringRef string = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                 (__bridge CFStringRef)(self),
                                                                 kURLReservedCharacters,
                                                                 NULL,
                                                                 cfEncoding);
    return CFBridgingRelease(string);
}

/// Returns a copy of this string with all reserved and invalid URL characters
/// percent encoded. Uses the default encoding for URIs which is UTF-8.
///
/// @return A new string created by URL encoding this string.
- (NSString *)stringByPercentEncoding {
    return [self stringByPercentEncodingUsingEncoding:kURLStringEncoding];
}

/// Returns a copy of this string with all reserved and invalid URL characters
/// percent encoded using the given string encoding.
///
/// @param encoding The string encoding in which to percent encode.
/// @return A new string created by URL encoding this string.
- (NSString *)stringByPercentEncodingUsingEncoding:(NSStringEncoding)encoding {
    CFStringEncoding cfEncoding = CFStringConvertNSStringEncodingToEncoding(encoding);
    CFStringRef string = CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault,
                                                                 (__bridge CFStringRef)(self),
                                                                 NULL,
                                                                 kURLReservedCharacters,
                                                                 cfEncoding);
    return CFBridgingRelease(string);
}

/// Returns a copy of this string percent unencoded. Uses the default string
/// encoding for URIs which is UTF-8.
///
/// @return A new string created by percent unencoding this string.
- (NSString *)stringByPercentUnencoding {
    return [self stringByPercentUnencodingUsingEncoding:kURLStringEncoding];
}

/// Returns a copy of this string percent unencoded using the given string
/// encoding.
///
/// @param encoding The string encoding from which to percent unescape.
/// @return A new string created by percent unencoding this string.
- (NSString *)stringByPercentUnencodingUsingEncoding:(NSStringEncoding)encoding {
    return [[self stringByReplacingOccurrencesOfString:@"+" withString:@" "]
            stringByReplacingPercentEscapesUsingEncoding:encoding];
}

@end
