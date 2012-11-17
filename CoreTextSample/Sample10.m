//
//  Sample10.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/10.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample10.h"

@interface Sample10 ()

@property (nonatomic) UIScrollView *scrollView;

@end

@implementation Sample10

- (id)initWithFrame:(CGRect)frame
{
    if (self = [super initWithFrame:frame]) {
        NSMutableString *mStr = [NSMutableString string];
        /* 長い文章だと描画が乱れる。(下記だと i > 21以上すると乱れる) UITextViewのsample11では大丈夫 */
        for (int i = 0; i < 20; i++) {
            [mStr appendString:self.text];
        }
        self.text = [[NSString alloc] initWithString:mStr];
        NSLog(@"text.length[%d]", self.text.length);
        self.scrollView = [[UIScrollView alloc] initWithFrame:frame];
        [self.scrollView addSubview:self];
        NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text];
        CTFramesetterRef framesetter = CTFramesetterCreateWithAttributedString((__bridge CFAttributedStringRef)attrStr);
        
        // 属性付き文字列から描画に必要なサイズを取得
        CGSize contentSize = CGSizeZero;
        contentSize = CTFramesetterSuggestFrameSizeWithConstraints(
                                                                     framesetter, 
                                                                     CFRangeMake(0, attrStr.length), 
                                                                     nil, 
                                                                     CGSizeMake(self.bounds.size.width, CGFLOAT_MAX), nil);
        CFRelease(framesetter);
        
        self.frame = CGRectMake(0.f, 0.f, self.bounds.size.width, contentSize.height);
        [self.scrollView setContentSize:CGSizeMake(self.bounds.size.width, contentSize.height)];
    }
    return (Sample10*)self.scrollView;
}

- (void)drawRect:(CGRect)rect
{
    NSAttributedString *attrStr = [[NSAttributedString alloc] initWithString:self.text];
    [self drawCoreTextWithRect:rect attributedString:attrStr];
}

@end
