//
//  Sample6.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/08.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample6.h"
#import "InfomationView.h"

@interface Sample6 ()

@property (nonatomic) NSMutableAttributedString *attributedString;
@property (nonatomic) CTFrameRef ctFrame;
@property (nonatomic) InfomationView *infomationView;

@end

@implementation Sample6

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
        
        self.infomationView = [[InfomationView alloc] initWithFrame:CGRectMake(
                                                             0.f, 
                                                             self.bounds.size.height/2.f, 
                                                             self.bounds.size.width, 
                                                             self.bounds.size.height/2.f)];
        [self addSubview:self.infomationView];
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

- (void)touchesEnded:(NSSet *)touches withEvent:(UIEvent *)event
{
    // タッチpointの取得
    UITouch *touch = [touches anyObject];
    CGPoint point = [touch locationInView:self];
    // 座標系が上下逆なのでタッチpoint.yを反転
    point.y = CGRectGetHeight(self.bounds) - point.y;
    
    // CTFrame内の全ての行(CTLineRef)を取得
    NSArray *lines = (__bridge id)CTFrameGetLines(self.ctFrame);
    // 全ての行のベースラインpointを取得
    CGPoint *origins = malloc(sizeof(CGPoint) * [lines count]);
    CTFrameGetLineOrigins(self.ctFrame, CFRangeMake(0, [lines count]), origins);
    
    // 全ての行をループ
    for (int i = 0; i < [lines count]; i++) {
        CTLineRef line = (__bridge CTLineRef)([lines objectAtIndex:i]);
//        CTLineRef line = CFArrayGetValueAtIndex((__bridge CFArrayRef)lines, i);
        
        // 行のベースラインpointを取得
        CGPoint origin = *(origins + i);
        // 行の横幅、ascent, descent, leadingを取得
        float   ascent, descent, leading;
        double  width;
        width = CTLineGetTypographicBounds(line, &ascent, &descent, &leading);
        // 行のframeを計算
        CGRect  lineFrame = CGRectMake(
                                       origin.x,
                                       origin.y - descent, 
                                       width, 
                                       ascent + descent);

        // タッチpointと一致する行か
        if (CGRectContainsPoint(lineFrame, point)) {
            self.infomationView.ascent = ascent;
            self.infomationView.descent = descent;
            self.infomationView.leading = leading;
            self.infomationView.lineFrame = lineFrame;
            self.infomationView.touchPoint = point;
            
            // タッチpointにある文字のindexを取得
            CFIndex touchIndex = CTLineGetStringIndexForPosition(line, point);
            if (touchIndex == kCFNotFound) {
                continue;
            }
            self.infomationView.touchIndex = touchIndex;

            // 文字のindexから属性が設定してあるrangeと属性辞書を取得
            NSRange touchRange;
            self.infomationView.attributedDictionary = [_attributedString attributesAtIndex:touchIndex effectiveRange:&touchRange];
            self.infomationView.touchRange = touchRange;
            self.infomationView.touchText = [self.text substringWithRange:touchRange];
            [self.infomationView redraw];
            break;
        }
    }
    // Release objects
    if (origins) {
        free(origins), origins = NULL;
    }
}

@end
