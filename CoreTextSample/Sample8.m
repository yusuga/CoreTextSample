//
//  Sample8.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/09.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample8.h"
#import "InfomationView.h"

@interface Sample8 ()

- (NSString*)cfStringTokenizerTokenTypeDescription:(CFStringTokenizerTokenType)type;

@end

@implementation Sample8

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Sample8" ofType:@"txt"];
        self.text = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        
        self.attributedString = [[NSMutableAttributedString alloc] initWithString:self.text];
        CTFontRef font = CTFontCreateWithName(CFSTR("Helvetica"), 12.f, NULL);
        
        /* 属性付き文字列に形態素の範囲を追加 */
        CFRange range = CFRangeMake(0, [self.text length]);
        CFStringTokenizerRef tokenizer = CFStringTokenizerCreate(
                                            NULL,
                                            (__bridge CFStringRef)self.text,
                                            range,
                                            kCFStringTokenizerUnitWordBoundary,
                                            NULL);
        CFStringTokenizerTokenType tokenType = CFStringTokenizerGoToTokenAtIndex(tokenizer, 0);
        
        NSUInteger cnt = 0;
        while (tokenType != kCFStringTokenizerTokenNone || range.location + range.length < [self.text length]) {
            range = CFStringTokenizerGetCurrentTokenRange(tokenizer);
            if (range.location != kCFNotFound) {
                NSLog(@"%@\n%@", [self.text substringWithRange:NSMakeRange(range.location, range.length)], [self cfStringTokenizerTokenTypeDescription:tokenType]);
                
                /* iOS5では下記が有効*/
                //            [_attributedString addAttribute:(NSString*)kCTFontAttributeName
                //                                      value:(__bridge id)font
                //                                      range:NSMakeRange(range.location, range.length)];
                
                /* iOS6から -attributesAtIndex:effectiveRange: のaRangeが隣接する同じ属性文字辞書はひとまとまりのRangeを返すようになった
                 とりあえず交互に属性文字辞書を設定し回避 */
                if (cnt % 2) {
                    [self.attributedString addAttribute:(NSString*)kCTFontAttributeName
                                              value:(__bridge id)font
                                              range:NSMakeRange(range.location, range.length)];
                }
                cnt++;
                tokenType = CFStringTokenizerAdvanceToNextToken(tokenizer);
            }
        }
        CFRelease(tokenizer);
    }
    return self;
}

- (NSString *)cfStringTokenizerTokenTypeDescription:(CFStringTokenizerTokenType)type
{
    if (type == 0) {
        return @"kCFStringTokenizerTokenNone"; // = 0
    }
    NSArray *typeStrings = [NSArray arrayWithObjects:
                            @"kCFStringTokenizerTokenNormal",  // = 1
                            @"kCFStringTokenizerTokenHasSubTokensMask",  // 1L << 1
                            @"kCFStringTokenizerTokenHasDerivedSubTokensMask",  // 1L << 2
                            @"kCFStringTokenizerTokenHasHasNumbersMask",  // 1L << 3
                            @"kCFStringTokenizerTokenHasNonLettersMask",  // 1L << 4
                            @"kCFStringTokenizerTokenIsCJWordMask", nil]; // 1L << 5
    
    NSMutableString *mStr = [[NSMutableString alloc] initWithString:@"{\n"];
    for (int i = 0; i < [typeStrings count]; i++) {
        if (type % 2 == 1) {
            [mStr appendFormat:@"%@\n", [typeStrings objectAtIndex:i]];
        }
        type >>= 1;
    }
    [mStr appendString:@"}"];
    return [[NSString alloc] initWithString:mStr];
}

@end
