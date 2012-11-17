//
//  CoreTextView.h
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/08.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>
#import <CoreText/CoreText.h>

@interface CoreTextView : UIView

@property (nonatomic) NSString *text;
- (void)drawCoreTextWithRect:(CGRect)rect attributedString:(NSAttributedString*)attrStr;
- (void)drawCoreTextWithRect:(CGRect)rect text:(NSString*)text attributedDictionary:(NSDictionary*)attrDict;
- (void)drawCoreTextWithRect:(CGRect)rect ctFrame:(CTFrameRef)ctFrame;

@property (nonatomic) CTParagraphStyleRef ctParagraphStyle;

@end
