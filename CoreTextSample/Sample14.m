//
//  Sample14.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 2012/11/11.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample14.h"

@interface Sample14 ()

@property (nonatomic) CTFontRef ctFont;

@end

@implementation Sample14

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        self.backgroundColor = [[UIColor blueColor] colorWithAlphaComponent:0.4];
        CGFloat fontSize = 50.f;

        self.text = @"ygPGあア唖";
//        self.text = @"ygPGあア唖\nygPGあア唖";
        
        self.ctFont = CTFontCreateWithName(CFSTR("HiraKakuProN-W3"), fontSize, NULL);

        NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                                  (__bridge id)self.ctFont, kCTFontAttributeName, //nil];
                                  (__bridge id)self.ctParagraphStyle, kCTParagraphStyleAttributeName, nil];
        
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text attributes:attrDict];
        
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
        CGSize contentSize = CTFramesetterSuggestFrameSizeWithConstraints(
                                                                          framesetter,
                                                                          CFRangeMake(0, attrStr.length),
                                                                          nil,
                                                                          CGSizeMake(self.bounds.size.width, CGFLOAT_MAX),
                                                                          nil);
        CFRelease(framesetter);
        NSLog(@"size[%@]", NSStringFromCGSize(contentSize));
        
        /* descent1つ分足りない */
        self.frame = CGRectMake(0.f, 0.f, contentSize.width, contentSize.height);
        /* 正確な高さ取得 */
//        self.frame = CGRectMake(0.f, 0.f, ceilf(contentSize.width), contentSize.height + ceilf(CTFontGetDescent(self.ctFont)));
        
        CGFloat markWidth = 30.f;
        CGFloat markViewX = self.bounds.size.width/2.f - markWidth/2.f;
        UIView *asentView = [[UIView alloc] initWithFrame:CGRectMake(markViewX, 0.f, markWidth, ceilf(CTFontGetAscent(self.ctFont)))];
        NSLog(@"asView %@", NSStringFromCGRect(asentView.frame));
        asentView.backgroundColor = [[UIColor redColor] colorWithAlphaComponent:0.3f];
        [self addSubview:asentView];
        
        UIView *desentView = [[UIView alloc] initWithFrame:CGRectMake(markViewX, asentView.bounds.size.height, markWidth, ceilf(CTFontGetDescent(self.ctFont)))];
        NSLog(@"desView %@", NSStringFromCGRect(desentView.frame));
        desentView.backgroundColor = [[UIColor yellowColor] colorWithAlphaComponent:0.8f];
        [self addSubview:desentView];
        
        UIView *adjustView = [[UIView alloc] initWithFrame:CGRectMake(markViewX, contentSize.height, markWidth, ceilf(CTFontGetDescent(self.ctFont)))];
        NSLog(@"adjustView %@", NSStringFromCGRect(adjustView.frame));
        adjustView.backgroundColor = [[UIColor blackColor] colorWithAlphaComponent:0.6f];
        [self addSubview:adjustView];
    }
    return self;
}

/* 以下は使用する場合はCTParagraphStyleSettingで設定したleadingを毎行足せば多分高さが求まる
    [注意] CTLineGetTypographicBounds() はCTParagraphStyleSettingが考慮されず値が返る */
// http://stackoverflow.com/questions/2707710/core-texts-ctframesettersuggestframesizewithconstraints-returns-incorrect-siz
+(CGFloat)heightForAttributedString:(NSAttributedString *)attrString forWidth:(CGFloat)inWidth
{
    CGFloat H = 0;
    
    // Create the framesetter with the attributed string.
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString( (__bridge CFMutableAttributedStringRef) attrString);
    
    CGRect box = CGRectMake(0,0, inWidth, CGFLOAT_MAX);
    
    CFIndex startIndex = 0;
    
    CGMutablePathRef path = CGPathCreateMutable();
    CGPathAddRect(path, NULL, box);
    
    // Create a frame for this column and draw it.
    CTFrameRef frame = CTFramesetterCreateFrame(framesetter, CFRangeMake(startIndex, 0), path, NULL);
    
    // Start the next frame at the first character not visible in this frame.
    //CFRange frameRange = CTFrameGetVisibleStringRange(frame);
    //startIndex += frameRange.length;
    
    CFArrayRef lineArray = CTFrameGetLines(frame);
    CFIndex j = 0, lineCount = CFArrayGetCount(lineArray);
    CGFloat h, ascent, descent, leading;
    NSLog(@"start line -> %ld", lineCount);
    for (j=0; j < lineCount; j++)
    {
        CTLineRef currentLine = (CTLineRef)CFArrayGetValueAtIndex(lineArray, j);
        CTLineGetTypographicBounds(currentLine, &ascent, &descent, &leading);
        h = ascent + descent;// + leading;
        NSLog(@"%f %f %f %f", ascent, descent, leading, h);
        H+=h;
    }
    
    CFRelease(frame);
    CFRelease(path);
    CFRelease(framesetter);
    
    
    return H;
}

- (void)drawRect:(CGRect)rect
{
    NSDictionary *attrDict = [NSDictionary dictionaryWithObjectsAndKeys:
                              (__bridge id)self.ctFont, kCTFontAttributeName,
                              (__bridge id)self.ctParagraphStyle, kCTParagraphStyleAttributeName, nil];
    
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text attributes:attrDict];
    
    [self drawCoreTextWithRect:rect attributedString:attrStr];
}

@end
