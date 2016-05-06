//
//  UIButton+ExecuteOnce.m
//  Juxiaocheng
//
//  Created by 高继鹏 on 16/4/11.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import "UIButton+ExecuteOnce.h"
#import <objc/runtime.h>

static char const *objectKey;

@implementation UIButton (ExecuteOnce)

- (void)setClickOnce:(BOOL)clickOnce {
    objc_setAssociatedObject(self, objectKey, @(clickOnce), OBJC_ASSOCIATION_RETAIN_NONATOMIC);
}

- (BOOL)clickOnce {
    NSNumber *hasClick = objc_getAssociatedObject(self, objectKey);
    return hasClick.boolValue;
}

@end
