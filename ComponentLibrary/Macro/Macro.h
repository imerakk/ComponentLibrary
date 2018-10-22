//
//  Macro.h
//  ComponentLibrary
//
//  Created by liuchunxi on 2018/10/22.
//  Copyright © 2018年 imera. All rights reserved.
//

#ifndef Macro_h
#define Macro_h

#define SCREEN_WIDTH ([UIScreen mainScreen].bounds.size.width)  //屏幕宽度
#define SCREEN_HEIGHT ([UIScreen mainScreen].bounds.size.height) //屏幕高度

#define UIColorFromRGB(rgbValue)    [UIColor colorWithRed:((float)(((rgbValue) & 0xFF0000) >> 16))/255.0 \
green:((float)(((rgbValue) & 0x00FF00) >> 8))/255.0 \
blue:((float)((rgbValue) & 0x0000FF))/255.0 \
alpha:1.0]

#endif /* Macro_h */
