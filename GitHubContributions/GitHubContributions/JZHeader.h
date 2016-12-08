//
//  JZHeader.h
//  GitHubContributions
//
//  Created by Justin Fincher on 2016/12/7.
//  Copyright © 2016年 JustZht. All rights reserved.
//

#ifndef JZHeader_h
#define JZHeader_h

#define UIColorFromRGB(rgbValue) \
[UIColor colorWithRed:((float)((rgbValue & 0xFF0000) >> 16))/255.0 \
green:((float)((rgbValue & 0x00FF00) >>  8))/255.0 \
blue:((float)((rgbValue & 0x0000FF) >>  0))/255.0 \
alpha:1.0f]

#define JZSuiteName @"group.com.JustZht.GitHubContributions"

#ifdef DEBUG
#   define JZLog(fmt, ...) NSLog((@"%s [Line %d] " fmt), __PRETTY_FUNCTION__, __LINE__, ##__VA_ARGS__);
#else
#   define JZLog(...)
#endif

#endif /* JZHeader_h */
