//
//  Sample4.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/10.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample4.h"

@implementation Sample4

- (void)drawRect:(CGRect)rect
{
    // フォントを明示的にヒラギノフォントし、かつ段落スタイルを設定すると日本語行間問題は解決…たぶん
    // 段落スタイルを設定しないと英語のみで行間が広くなる
    
    CTFontRef font = CTFontCreateWithName(CFSTR("HiraKakuProN-W3"), 12, NULL);
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              (__bridge id)font, kCTFontAttributeName,
                              (__bridge id)self.ctParagraphStyle, kCTParagraphStyleAttributeName, nil];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text attributes:attrDict];
    
    [self drawCoreTextWithRect:rect attributedString:attrStr];
}

@end
