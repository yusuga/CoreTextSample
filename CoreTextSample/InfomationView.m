//
//  InfomationView.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/09.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "InfomationView.h"

@implementation InfomationView

@synthesize touchPoint, ascent, descent, leading, lineFrame, touchRange, touchIndex, touchText, attributedDictionary;

- (void)redraw
{
    self.text = [NSString stringWithFormat:@"タッチ座標: %@\nascent: %f\ndescent: %f\nleading: %f\n行のframe: %@\n属性文字列の範囲: %@\n文字の位置: %ld\n属性辞書: %@\nタッチした文字列: %@", NSStringFromCGPoint(self.touchPoint), self.ascent, self.descent, self.leading, NSStringFromCGRect(self.lineFrame), NSStringFromRange(self.touchRange), self.touchIndex, self.attributedDictionary, self.touchText];
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        self.backgroundColor = [UIColor colorWithWhite:0.7f alpha:1.f];
        self.font = [UIFont systemFontOfSize:12.f];
        self.numberOfLines = 0;
    }
    return self;
}

@end
