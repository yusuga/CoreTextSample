//
//  Sample9.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/10.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample9.h"

@interface Sample9 ()

@property (nonatomic) NSUInteger lineNum;

@end

@implementation Sample9

- (void)drawRect:(CGRect)rect
{    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text];
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
    
    CGPathRef framePath = [[UIBezierPath bezierPathWithRect:rect] CGPath];
    CTFrameRef frame = CTFramesetterCreateFrame(
                                                framesetter, 
                                                CFRangeMake(0.f, attrStr.length), 
                                                framePath, 
                                                NULL);
    
    NSArray *lines = (__bridge id)CTFrameGetLines(frame);
    
    self.lineNum++;
    if (self.lineNum > [lines count]) {
        self.lineNum = [lines count];
    }
    
    // 全ての行のベースラインpointを取得
    CGPoint *origins = malloc(sizeof(CGPoint) * [lines count]);
    CTFrameGetLineOrigins(frame, CFRangeMake(0, [lines count]), origins);  
    
    CGContextRef context = UIGraphicsGetCurrentContext();
    
    // 座標を上下反転
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSaveGState(context);
    // CoreTextを1行づつ描画
    for (int i = 0; i < self.lineNum; i++) {
        CTLineRef line = (__bridge CTLineRef)[lines objectAtIndex:i];
        // 行のベースラインpointを取得
        CGPoint origin = *(origins + i);
        // 行からdescentを取得
        CGFloat   descent;
        CTLineGetTypographicBounds(line, nil, &descent, nil);
        // originはベースラインなのでdescentを引けば行の原点(その行の左下端)になる(Core Graphicsの座標系)
        CGContextSetTextPosition(context, origin.x, origin.y - descent);
        NSLog(@"%f %f %f", origin.x, origin.y, descent);
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
    [self setNeedsDisplay];
}

@end
