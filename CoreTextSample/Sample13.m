//
//  Sample13.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 2012/11/05.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample13.h"

@interface Sample13 ()

@property (nonatomic) UIScrollView *scrollView;

@end

@implementation Sample13

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        self.scrollView.alwaysBounceVertical = NO;
        [self.scrollView addSubview:self];
        self.text = [self.text stringByAppendingString:self.text]; // 文書が短いのでとりあえず2倍にしているだけ
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text];
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
        
        // 属性付き文字列から描画に必要なサイズを取得
        CGSize contentSize = CGSizeZero;
        contentSize = CTFramesetterSuggestFrameSizeWithConstraints(
                                                                   framesetter,
                                                                   CFRangeMake(0, attrStr.length),
                                                                   nil,
                                                                   CGSizeMake(self.bounds.size.width, CGFLOAT_MAX),
                                                                   nil);
        CFRelease(framesetter);
        
        /* 縦書きなので縦横のサイズを逆にする */
        self.frame = CGRectMake(0.f, 0.f, contentSize.height, contentSize.width);
        [self.scrollView setContentSize:CGSizeMake(contentSize.height, contentSize.width)];
        
        /* 右端から始まるようにoffsetを調整 */
        self.scrollView.contentOffset = CGPointMake(contentSize.height - self.scrollView.bounds.size.width, 0.f);
    }
    return (Sample13*)self.scrollView;
}

- (void)drawRect:(CGRect)rect
{
	CTFontRef font = CTFontCreateWithName(CFSTR("HiraKakuProN-W3"), 12, NULL);
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              // フォント
                              (__bridge id)font, kCTFontAttributeName, //nil];
                              // 縦書の指定
                              [NSNumber numberWithBool:YES], kCTVerticalFormsAttributeName, nil];
    CFRelease(font);
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text attributes:attrDict];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
    
    /* 縦書きなので縦横のサイズを逆にする */
    CGPathRef framePath = [[UIBezierPath bezierPathWithRect:CGRectMake(0.f, 0.f, rect.size.height, rect.size.width)] CGPath];
    CTFrameRef frame = CTFramesetterCreateFrame(
                                                framesetter,
                                                CFRangeMake(0.f, attrStr.length),
                                                framePath,
                                                NULL);
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 座標を上下反転
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    /* 90度右回りに回転 */
    CGContextRotateCTM(context, -M_PI/2.0);
    CGContextTranslateCTM(context, -rect.size.height, 0);
    
    CGContextSaveGState(context);
    
    // CoreTextの描画
    CTFrameDraw(frame, context);
    
    CGContextRestoreGState(context);
    
    
    CFRelease(frame);
	CFRelease(framesetter);
}

@end