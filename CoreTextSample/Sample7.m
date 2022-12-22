//
//  Sample7.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/08.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample7.h"

@interface Sample7 ()

@end

@implementation Sample7

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
        NSError *error;
        NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"([a-zA-Z]*)" options:0 error:&error];
        if (!error) {
            NSArray *arr = [regexp matchesInString:self.text options:0 range:NSMakeRange(0, self.text.length)];
            for (NSTextCheckingResult *match in arr) {
                [self.attributedString addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:[match rangeAtIndex:1]];
            }
        }
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFMutableAttributedStringRef)self.attributedString);
    CGPathRef framePath = [[UIBezierPath bezierPathWithRect:rect] CGPath];
    
    if (self.ctFrame) {
        CFRelease(self.ctFrame);
        self.ctFrame = NULL;
    }
    self.ctFrame = CTFramesetterCreateFrame(
                                        framesetter, 
                                        CFRangeMake(0.f, self.attributedString.length),
                                        framePath, 
                                        NULL);
    
    [self drawCoreTextWithRect:rect ctFrame:self.ctFrame];
	CFRelease(framesetter);
}

- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateTextMarkViewWithTouches:touches withEvent:event];
}

- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    [self updateTextMarkViewWithTouches:touches withEvent:event];
}

- (void)updateTextMarkViewWithTouches:(NSSet *)touches withEvent:(UIEvent *)event
{
    // タッチpointの取得
    UITouch *touch = [touches anyObject];
    CGPoint touchPoint = [touch locationInView:self];
    // 座標系が上下逆なのでタッチpoint.yを反転
    touchPoint.y = CGRectGetHeight(self.bounds) - touchPoint.y;
    
    // CTFrame内の全ての行(CTLineRef)を取得
    NSArray *lines = (__bridge id)CTFrameGetLines(self.ctFrame);
    // 全ての行のベースラインpointを取得
    CGPoint *origins = malloc(sizeof(CGPoint) * [lines count]);
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, [lines count]), origins);
    
    // 全ての行をループ
    for (int i = 0; i < [lines count]; i++) {
        CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
        // 行のベースラインpointを取得
        CGPoint origin = *(origins + i);
        // 行の横幅、ascent, descent, leadingを取得
        CGFloat   ascent, descent, leading;
        double  width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        // 行のframeを計算
        CGRect  lineFrame = CGRectMake(
                                       origin.x,
                                       origin.y - descent, 
                                       width, 
                                       ascent + descent);
        
        // タッチpointと一致する行か
        if (CGRectContainsPoint(lineFrame, touchPoint)) {
            // タッチpointにある文字のindexを取得
            CFIndex touchIndex = CTLineGetStringIndexForPosition(line, touchPoint);            
            /* 文字列の最後の数ピクセルの範囲がself.text.lengthを超えた値になる  */
            /* [注意] self.text.length の位置がtouchIndexが返って来るので範囲外エラーのチェックが必要 (取得方法が間違っている？) */
            if (touchIndex == kCFNotFound || touchIndex >= self.text.length) {
                continue;
            }
            
            // 文字のindexから属性が設定してあるrangeと属性辞書を取得
            NSRange touchRange;
            [self.attributedString attributesAtIndex:touchIndex effectiveRange:&touchRange];
            // 属性付き文字列のrangeから文字列の開始と終了の座標を取得
            CFIndex startIndex = touchRange.location;
            CGFloat startOffset = CTLineGetOffsetForStringIndex(line, startIndex, NULL);
            CFIndex endIndex = startIndex + touchRange.length;
            CGFloat endOffset = CTLineGetOffsetForStringIndex(line, endIndex, NULL);
            CGFloat touchTextWidth = endOffset - startOffset;
            
            CGRect markFrame = CGRectMake(
                                          startOffset,
                                          self.bounds.size.height - origin.y - ascent, // 上下を反転したベースラインyからascentを引く
                                          touchTextWidth, 
                                          lineFrame.size.height);
            NSLog(@"%f %f %f", self.bounds.size.height, origin.y, ascent);
            if (!self.markTextView) {
                self.markTextView = [[UIView alloc] init];
                [self addSubview:self.markTextView];
            }
            self.markTextView.frame = markFrame;
            self.markTextView.backgroundColor = [UIColor colorWithRed:0.f green:0.342f blue:1.f alpha:0.3f];
            [self.markTextView setNeedsDisplay];
            break;
        }
    }
    // Release objects
    if (origins) {
        free(origins), origins = NULL;
    }
}

@end
