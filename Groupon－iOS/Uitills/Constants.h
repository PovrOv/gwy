//
//  Constants.h
//  GoldenLeaf
//
//  Created by Sissi Chen on 7/15/15.
//  Copyright (c) 2015 Sissi Chen . All rights reserved.
//

#ifndef VLC_Constants_h
#define VLC_Constants_h

// Begin Convinent Constants ....
#define IS_IPAD (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPad)
#define IS_IPHONE (UI_USER_INTERFACE_IDIOM() == UIUserInterfaceIdiomPhone)
#define IS_IPHONE_4 (IS_IPHONE && [[UIScreen mainScreen] bounds].size.height < 568.0)
#define IS_RETINA ([[UIScreen mainScreen] scale] == 2.0)
#define SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(v)                                                                                         \
    ([[[UIDevice currentDevice] systemVersion] compare:v options:NSNumericSearch] != NSOrderedAscending)

#define IS_IOS8 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"8.0")
#define IS_IOS7 SYSTEM_VERSION_GREATER_THAN_OR_EQUAL_TO(@"7.0")

#define SCREEN_WIDTH                                                                                                                       \
    ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) ||                                        \
      ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ||                             \
             IS_IOS8                                                                                                                       \
         ? [[UIScreen mainScreen] bounds].size.width                                                                                       \
         : [[UIScreen mainScreen] bounds].size.height)
#define SCREEN_HEIGHT                                                                                                                      \
    ((([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortrait) ||                                        \
      ([UIApplication sharedApplication].statusBarOrientation == UIInterfaceOrientationPortraitUpsideDown)) ||                             \
             IS_IOS8                                                                                                                       \
         ? [[UIScreen mainScreen] bounds].size.height                                                                                      \
         : [[UIScreen mainScreen] bounds].size.width)

// IPHONE constants
#define TAB_BAR_HEIGHT 49.0f
#define NAV_BAR_HEIGHT 44.0f
#define STATUS_BAR_HEIGHT 20.0f
#define STATUS_NAV_BAR_HEIGHT 64.0f

#endif