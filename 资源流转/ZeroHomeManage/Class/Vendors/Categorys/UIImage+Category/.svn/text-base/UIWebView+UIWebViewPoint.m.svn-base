//
//  UIWebView+UIWebViewPoint.m
//  BYDFans
//
//  Created by scan on 15/3/20.
//  Copyright (c) 2015年 Tentinet. All rights reserved.
//

#import "UIWebView+UIWebViewPoint.h"

@implementation UIWebView (UIWebViewPoint)
- (CGSize)windowSize {

    CGSize size;
    size.width = [[self stringByEvaluatingJavaScriptFromString:@"window.innerWidth"] integerValue];
    size.height = [[self stringByEvaluatingJavaScriptFromString:@"window.innerHeight"] integerValue];
    return size;
}

- (CGPoint)scrollOffset {

    CGPoint pt;
    pt.x = [[self stringByEvaluatingJavaScriptFromString:@"window.pageXOffset"] integerValue];
    pt.y = [[self stringByEvaluatingJavaScriptFromString:@"window.pageYOffset"] integerValue];
    return pt;
}
@end
