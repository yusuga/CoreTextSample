//
//  Sample11.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/10.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "Sample11.h"

@implementation Sample11

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        NSString *path = [[NSBundle mainBundle] pathForResource:@"Text" ofType:@"txt"];
        NSString *tmpText = [[NSString alloc] initWithContentsOfFile:path encoding:NSUTF8StringEncoding error:nil];
        NSMutableString *mStr = [NSMutableString string];
        for (int i = 0; i < 50; i++) { 
            [mStr appendString:tmpText];
        }
        self.text = [[NSString alloc] initWithString:mStr];
        NSLog(@"text.length[%d]", self.text.length);
    }
    return self;
}

@end
