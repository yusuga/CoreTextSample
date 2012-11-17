//
//  Sample7.h
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/08.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "CoreTextView.h"

@interface Sample7 : CoreTextView

@property (nonatomic) CTFrameRef ctFrame;
@property (nonatomic) NSMutableAttributedString *attributedString;
@property (nonatomic) UIView *markTextView;
- (void)updateTextMarkViewWithTouches:(NSSet *)touches withEvent:(UIEvent *)event;

@end
