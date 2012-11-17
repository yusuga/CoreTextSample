//
//  Sample12.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/10.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample12.h"

@interface Sample12 ()

@property (nonatomic) NSUInteger length;
@property (nonatomic, strong) NSString *textToDraw;
- (void)incrementText;
- (void)drawAllText;

@property (nonatomic, strong) NSTimer *timer;
- (void)startAnimation;
- (void)stopAnimation;

@end

@implementation Sample12

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.textToDraw = @"";
        self.length = 1;
    }
    return self;
}

- (void)drawRect:(CGRect)rect
{
    CTFontRef font = CTFontCreateWithName(CFSTR("HiraKakuProN-W3"), 12, NULL);
    
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              (__bridge id)font, kCTFontAttributeName,
                              (__bridge id)self.ctParagraphStyle, kCTParagraphStyleAttributeName, nil];
    CFRelease(font);
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.textToDraw attributes:attrDict];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
    
    CGPathRef framePath = [[UIBezierPath bezierPathWithRect:rect] CGPath];
    CTFrameRef frame = CTFramesetterCreateFrame(
                                                framesetter, 
                                                CFRangeMake(0.f, attrStr.length), 
                                                framePath, 
                                                NULL);
    
    NSArray *lines = (__bridge id)CTFrameGetLines(frame);
    
    // 全ての行のベースラインpointを取得
    CGPoint *origins = malloc(sizeof(CGPoint) * [lines count]);
    CTFrameGetLineOrigins(frame, CFRangeMake(0, [lines count]), origins);  
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 座標を上下反転
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSaveGState(context);
    // CoreTextを1行づつ描画
    for (int i = 0; i < [lines count]; i++) {
        CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
        // 行のベースラインpointを取得
        CGPoint origin = *(origins + i);
        // 行からdescentを取得
        float   descent;
        CTLineGetTypographicBounds(line, nil, &descent, nil);
        // originはベースラインなのでdescentを引けば行の原点(その行の左上端)になる。
        CGContextSetTextPosition(context, origin.x, origin.y - descent);
        CTLineDraw(line, context);
    }
    if (origins) {
        free(origins);
        origins = NULL;
    }
    CGContextRestoreGState(context);
    
    CFRelease(frame);
	CFRelease(framesetter);
}

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    [super touchesEnded:touches withEvent:event];

    UITouch *touch = [touches anyObject];
    if (touch.tapCount == 1) {
        static NSUInteger cnt;
        if (self.length < self.text.length) {
            cnt++;
            if (cnt % 2) {
                [self startAnimation];
            } else {
                [self stopAnimation];
            }
        }
    } else {
        [self drawAllText];
    }
}

- (void)incrementText
{
    self.length++;
    if (self.length >= self.text.length) {
        self.length = self.text.length;
        [self stopAnimation];
    }
    self.textToDraw = [self.text substringWithRange:NSMakeRange(0, self.length)];
    [self setNeedsDisplay];
    NSLog(@"%@", self.textToDraw);
}

- (void)drawAllText
{
    NSLog(@"%s", __func__);
    self.length = self.text.length;
    [self incrementText];
}

- (void)startAnimation
{
    NSLog(@"%s", __func__);
    self.timer = [NSTimer scheduledTimerWithTimeInterval:0.05f target:self selector:@selector(incrementText) userInfo:nil repeats:YES];
    [self.timer fire];
}

- (void)stopAnimation
{
    NSLog(@"%s", __func__);
    [self.timer invalidate];
}

@end
