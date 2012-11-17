//
//  InfomationView.h
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/09.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface InfomationView : UILabel

@property (nonatomic) CGPoint touchPoint;
@property (nonatomic) float ascent;
@property (nonatomic) float descent;
@property (nonatomic) float leading;
@property (nonatomic) CGRect lineFrame;
@property (nonatomic) NSRange touchRange;
@property (nonatomic) long touchIndex;
@property (nonatomic, strong) NSDictionary *attributedDictionary;
@property (nonatomic, copy) NSString *touchText;

- (void)redraw;

@end