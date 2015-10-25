//
//  NSObject+BBNSObjectAdditions.m
//  GoldenLeaf
//
//  Created by Sissi Chen on 7/15/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

#import "NSObject+BBNSObjectAdditions.h"
#import <objc/runtime.h>

const char * property_getTypeString(objc_property_t property);

@implementation NSObject (BBNSObjectAdditions)

- (BOOL)isValidObject {
    return self != nil && self != [NSNull null];
}

- (BOOL)isValidDictionary {
    return [self isKindOfClass:[NSDictionary class]];
}

- (BOOL)isValidDict {
    return [self isValidDictionary];
}

- (BOOL)isValidArray {
    return [self isKindOfClass:[NSArray class]];
}

- (BOOL)isValidString {
    return [self isKindOfClass:[NSString class]];
}

- (BOOL)isValidNumber {
    return [self isKindOfClass:[NSNumber class]];
}

- (NSDictionary *)classProperties {
    NSMutableDictionary *properties = [NSMutableDictionary dictionary];
    unsigned int outCount, i;
    Class cls = [self class];
    while (cls != [NSObject class]) {
        objc_property_t *props = class_copyPropertyList(cls, &outCount);
        for(i = 0; i < outCount; i++){
            objc_property_t property = props[i];
            
            const char *property_name = property_getName(property);
            const char *property_typestr = property_getTypeString(property);
            
            NSString *classString = @"";
            if(property_typestr != NULL){
                classString = [[NSString alloc] initWithUTF8String:property_typestr];
                if([classString rangeOfString:@"@"].location != NSNotFound){
                    if (classString.length > 2) {
                        classString = [classString substringFromIndex:3];
                        classString = [classString stringByReplacingOccurrencesOfString:@"\"" withString:@""];
                    }
                    Class cls2 = NSClassFromString(classString);
                    if (cls2 == NULL) {
                        classString = @"";
                    }
                } else {
                    classString = [classString substringFromIndex:1];
                }
            }
            
            NSString *propName = [[NSString alloc] initWithUTF8String:property_name];
            properties[propName] = classString;
        }
        free(props);
        cls = [cls superclass];
    }
    
    return [properties copy];
}

@end

const char * property_getTypeString(objc_property_t property){
	const char *attrs = property_getAttributes(property);
	if (attrs == NULL)
		return (NULL);
    
	static char buffer[256];
	const char *e = strchr(attrs, ',');
	if (e == NULL)
		return (NULL);
    
	int len = (int)(e - attrs);
	memcpy(buffer, attrs, len);
	buffer[len] = '\0';
    
	return (buffer);
}
