//
//  CoreTextViewController.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/08.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "CoreTextViewController.h"
#import "CoreTextView.h"

@interface CoreTextViewController ()

@property (nonatomic) UIView *coreTextView;

@end

@implementation CoreTextViewController

- (id)initWithContentView:(UIView *)view
{
    if (self = [super init]) {
        self.coreTextView = view;
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    self.view.backgroundColor = [UIColor whiteColor];
	[self.view addSubview:self.coreTextView];
}

- (void)viewDidUnload
{
    [super viewDidUnload];
    _coreTextView = nil;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

@end
