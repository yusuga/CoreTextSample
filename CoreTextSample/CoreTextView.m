//
//  CoreTextView.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/08.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "CoreTextView.h"

@implementation CoreTextView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Text" ofType:@"txt"];
        self.text = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        self.backgroundColor = [UIColor whiteColor];
        
        
        /* http://novis.jimdo.com/2011/07/02/coretextの日本語行間の問題-解決/ */
        CTParagraphStyleSetting setting[10];
        CGFloat floatValue[10];
        
        floatValue[0] = 0.0; // Deprecated (see header file)
        floatValue[1] = 0.0;
        floatValue[2] = 0.0;
        floatValue[3] = 0.0;
        floatValue[4] = 5.0; // Line spacing (必要に応じて行間調整)
        floatValue[5] = floatValue[4]; // Same as kCTParagraphStyleSpecifierMinimumLineSpacing
        
        setting[0].spec = kCTParagraphStyleSpecifierLineSpacing; // Deprecated (see header file)
        setting[0].valueSize = sizeof(CGFloat);
        setting[0].value = &floatValue[0];
        
        setting[1].spec = kCTParagraphStyleSpecifierParagraphSpacing;
        setting[1].valueSize = sizeof(CGFloat);
        setting[1].value = &floatValue[1];
        
        setting[2].spec = kCTParagraphStyleSpecifierMaximumLineHeight;
        setting[2].valueSize = sizeof(CGFloat);
        setting[2].value = &floatValue[2];
        
        setting[3].spec = kCTParagraphStyleSpecifierMinimumLineHeight;
        setting[3].valueSize = sizeof(CGFloat);
        setting[3].value = &floatValue[3];
        
        setting[4].spec = kCTParagraphStyleSpecifierMinimumLineSpacing;
        setting[4].valueSize = sizeof(CGFloat);
        setting[4].value = &floatValue[4];
        
        setting[5].spec = kCTParagraphStyleSpecifierMaximumLineSpacing;
        setting[5].valueSize = sizeof(CGFloat);
        setting[5].value = &floatValue[5];
        
        self.ctParagraphStyle = CTParagraphStyleCreate(setting, 6);
    }
    return self;
}

- (void)dealloc
{
    if (self.ctParagraphStyle) {
        CFRelease(self.ctParagraphStyle);
        self.ctParagraphStyle = NULL;
    }
}

- (void)drawCoreTextWithRect:(CGRect)rect attributedString:(NSAttributedString *)attrStr
{
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
    CGPathRef framePath = [[UIBezierPath bezierPathWithRect:rect] CGPath];
    CTFrameRef frame = CTFramesetterCreateFrame(
                                               framesetter,
                                               CFRangeMake(0.f, attrStr.length),
                                               framePath,
                                               NULL);
    
    [self drawCoreTextWithRect:rect ctFrame:frame];
    CFRelease(frame);
	CFRelease(framesetter);
}

- (void)drawCoreTextWithRect:(CGRect)rect text:(NSString *)text attributedDictionary:(NSDictionary *)attrDict
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:text attributes:attrDict];
    //    CFAttributedStringRef attrStr = CFAttributedStringCreate(
    //                                                             NULL,
    //                                                             (__bridge CFStringRef)self.text,
    //                                                             nil);
    
    CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
    CGPathRef framePath = [[UIBezierPath bezierPathWithRect:rect] CGPath];
    
    CTFrameRef frame = CTFramesetterCreateFrame(
                                                framesetter,
                                                CFRangeMake(0.f, attrStr.length),
                                                framePath,
                                                NULL);
    
    [self drawCoreTextWithRect:rect ctFrame:frame];
    CFRelease(frame);
	CFRelease(framesetter);
    //	CFRelease(attrStr);
}

- (void)drawCoreTextWithRect:(CGRect)rect ctFrame:(CTFrameRef)ctFrame
{
    CGContextRef context = UIGraphicsGetCurrentContext();

    // 座標を上下反転
    CGContextTranslateCTM(context, 0, rect.size.height);
    CGContextScaleCTM(context, 1.0, -1.0);
    
    CGContextSaveGState(context);
    
    // CoreTextの描画
    CTFrameDraw(ctFrame, context);
    
    CGContextRestoreGState(context);
}

@end
