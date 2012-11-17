//
//  Sample2.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/08.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample2.h"

@implementation Sample2

- (void)drawRect:(CGRect)rect
{
    CTFontRef font = CTFontCreateWithName(CFSTR("AmericanTypewriter"), 20, NULL);
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              // フォント
                              (__bridge id)font, kCTFontAttributeName, 
                              // 中抜き文字のライン幅
                              [NSNumber numberWithFloat:4.0f], kCTStrokeWidthAttributeName,
                              // 中抜き文字のライン色
                              (id)[UIColor blueColor].CGColor, kCTStrokeColorAttributeName, 
                              // 下線スタイル
                              [NSNumber numberWithInt:kCTUnderlineStyleDouble], kCTUnderlineStyleAttributeName, 
                              // 下線色
                              (id)[UIColor redColor].CGColor, kCTUnderlineColorAttributeName, nil];
    CFRelease(font);
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text attributes:attrDict];
    
    [self drawCoreTextWithRect:rect attributedString:attrStr];
}

@end
