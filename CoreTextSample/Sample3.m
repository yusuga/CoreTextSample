//
//  Sample3.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/08.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample3.h"

@implementation Sample3

- (void)drawRect:(CGRect)rect
{
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              // 段落スタイル
                              (__bridge id)self.ctParagraphStyle, kCTParagraphStyleAttributeName, nil];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text attributes:attrDict];

    [self drawCoreTextWithRect:rect attributedString:attrStr];
}

@end
