//
//  Sample5.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/08.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample5.h"

@implementation Sample5

- (void)drawRect:(CGRect)rect
{
    NSMutableAttributedString *attrStr = [[NSMutableAttributedString alloc] initWithString:self.text];
    
    // 正規表現でアルファベットを探し設定。
    NSError *error;
    NSRegularExpression *regexp = [NSRegularExpression regularExpressionWithPattern:@"([a-zA-Z]*)" options:0 error:&error];
    if (!error) {
        NSArray *arr = [regexp matchesInString:self.text options:0 range:NSMakeRange(0, self.text.length)];
        for (NSTextCheckingResult *match in arr) {
            [attrStr addAttribute:(NSString*)kCTForegroundColorAttributeName value:(id)[UIColor blueColor].CGColor range:[match rangeAtIndex:1]];
        }
    }
    
    [self drawCoreTextWithRect:rect attributedString:attrStr];
}

@end
