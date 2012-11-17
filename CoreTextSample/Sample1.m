//
//  Sample1.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/08.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample1.h"

@implementation Sample1

- (void)drawRect:(CGRect)rect
{
	CTFontRef font = CTFontCreateWithName(CFSTR("AmericanTypewriter"), 12, NULL);
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              // フォント
                              (__bridge id)font, kCTFontAttributeName,
                              // 色
                              (id)[UIColor blueColor].CGColor, kCTForegroundColorAttributeName, nil];
    CFRelease(font);
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text attributes:attrDict];
    
    [self drawCoreTextWithRect:rect attributedString:attrStr];
}

@end
