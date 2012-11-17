//
//  Sample0.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/08.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample0.h"

@implementation Sample0

- (void)drawRect:(CGRect)rect
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text];
    //    CFAttributedStringRef attrStr = CFAttributedStringCreate(
    //                                                             NULL,
    //                                                             (__bridge CFStringRef)self.text,
    //                                                             nil);

    [self drawCoreTextWithRect:rect attributedString:attrStr];
//    CFRelease(attrStr);
}

@end
