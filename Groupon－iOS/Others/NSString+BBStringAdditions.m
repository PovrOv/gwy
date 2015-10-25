//
//  NSString+BBStringAdditions.m
//  GoldenLeaf
//
//  Created by Sissi Chen on 7/15/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

#import "NSString+BBStringAdditions.h"

@implementation NSString (BBStringAdditions)

- (BOOL)containsString:(NSString *) string
                options:(NSStringCompareOptions) options {
    NSRange rng = [self rangeOfString:string options:options];
    return rng.location != NSNotFound;
}

- (BOOL)containsString:(NSString *) string {
    return [self containsString:string options:0];
}

- (NSString *)urlEncodeUsingEncoding:(NSStringEncoding)encoding{
    NSString *encodedSelf = [self stringByAddingPercentEscapesUsingEncoding:encoding];
    
    NSURL *asURL = [NSURL URLWithString:encodedSelf];
    if(asURL.host){
        NSMutableString *final = [NSMutableString stringWithFormat:@"%@://", asURL.scheme];
        [final appendString:[asURL.host urlEncodeUsingEncoding:encoding]];
        if(asURL.port){
            [final appendFormat:@":%@", asURL.port];
        }
        if(asURL.path){
            NSArray *pathComponents = [asURL.path componentsSeparatedByString:@"/"];
            NSUInteger idx = 0;
            for(NSString *component in pathComponents){
                [final appendFormat:@"%@", [component urlEncodeUsingEncoding:encoding]];
                if(idx != pathComponents.count - 1) [final appendString:@"/"];
                idx++;
            }
        }
        if(asURL.query){
            [final appendString:@"?"];
            
            NSArray *queryComponents = [asURL.query componentsSeparatedByString:@"&"];
            NSUInteger idx = 0;
            for(NSString *component in queryComponents){
                NSArray *innerQueryComponents = [component componentsSeparatedByString:@"="];
                NSUInteger innerIdx = 0;
                for(NSString *innerComponent in innerQueryComponents){
                    [final appendString:innerComponent];
                    if(innerIdx == 0) [final appendString:@"="];
                    innerIdx++;
                }
                if(idx != queryComponents.count - 1) [final appendString:@"&"];
                idx++;
            }
        }
        if(asURL.fragment){
            [final appendFormat:@"#%@", [asURL.fragment urlEncodeUsingEncoding:encoding]];
        }
        return final;
    } else{
        CFStringRef preprocessed = CFURLCreateStringByReplacingPercentEscapesUsingEncoding(kCFAllocatorDefault, (__bridge CFStringRef) self, CFSTR(""), CFStringConvertNSStringEncodingToEncoding(encoding));
        NSString* final = (__bridge_transfer NSString *)CFURLCreateStringByAddingPercentEscapes(kCFAllocatorDefault, preprocessed, NULL, CFSTR("!*'();:@&=+$,/?%#[]\""), CFStringConvertNSStringEncodingToEncoding(encoding));
        CFRelease(preprocessed);
        return final;
    }
}

@end
