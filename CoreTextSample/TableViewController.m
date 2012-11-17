//
//  TableViewController.m
//  CoreTextSample
//
//  Created by Yu Sugawara on 12/07/08.
//  Copyright (c) 2012年 Yu Sugawara. All rights reserved.
//

#import "TableViewController.h"
#import "CoreTextViewController.h"

#import "Sample0.h"
#import "Sample1.h"
#import "Sample2.h"
#import "Sample3.h"
#import "Sample4.h"
#import "Sample5.h"
#import "Sample6.h"
#import "Sample7.h"
#import "Sample8.h"
#import "Sample9.h"
#import "Sample10.h"
#import "Sample11.h"
#import "Sample12.h"
#import "Sample13.h"
#import "Sample14.h"

@interface TableViewController ()

@property (nonatomic) NSArray *cellTexts;

@end

@implementation TableViewController

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        self.title = @"CoreText Sample";
        self.cellTexts = [[NSArray alloc] initWithObjects:
                          @"0. 最小限のコードで描画",
                          @"1. 属性の設定1",
                          @"2. 属性の設定2",
                          @"3. 日本語行間問題の一部解決",
                          @"4. 日本語行間問題の解決",
                          @"5. 英語のみ文字色を変更",
                          @"6. タップで情報取得",
                          @"7. タップ範囲を囲う",
                          @"8. タップ範囲を形態素で囲う",
                          @"9. タップで1行ずつ描画",
                          @"10. スクロールビュー",
                          @"11. 10をUITextViewで",
                          @"12. 1文字ずつ描画",
                          @"13. 縦書",
                          @"14. sizeToFit", nil];
    }
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    // Uncomment the following line to preserve selection between presentations.
    // self.clearsSelectionOnViewWillAppear = NO;
 
    // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
    // self.navigationItem.rightBarButtonItem = self.editButtonItem;
}

- (void)viewDidUnload
{
    [super viewDidUnload];
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return [self.cellTexts count];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"Cell";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleSubtitle reuseIdentifier:CellIdentifier];
        cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    }
    cell.textLabel.text = [self.cellTexts objectAtIndex:indexPath.row];
    if (indexPath.row == 3) {
        cell.detailTextLabel.text = @"※まだ日本語のみの描画で行間がつまる";
    } else {
        cell.detailTextLabel.text = nil;
    }
    return cell;
}

#pragma mark - Table view delegate

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    UIView *contentView;
    CGRect frame = self.tableView.frame;
    switch (indexPath.row) {
        case 0:
            contentView = [[Sample0 alloc] initWithFrame:frame];
            break;
        case 1:
            contentView = [[Sample1 alloc] initWithFrame:frame];
            break;
        case 2:
            contentView = [[Sample2 alloc] initWithFrame:frame];
            break;
        case 3:
            contentView = [[Sample3 alloc] initWithFrame:frame];
            break;
        case 4:
            contentView = [[Sample4 alloc] initWithFrame:frame];
            break;
        case 5:
            contentView = [[Sample5 alloc] initWithFrame:frame];
            break;
        case 6:
            contentView = [[Sample6 alloc] initWithFrame:frame];
            break;
        case 7:
            contentView = [[Sample7 alloc] initWithFrame:frame];
            break;
        case 8:
            contentView = [[Sample8 alloc] initWithFrame:frame];
            break;
        case 9:
            contentView = [[Sample9 alloc] initWithFrame:frame];
            break;
        case 10:
            contentView = [[Sample10 alloc] initWithFrame:frame];
            break;
        case 11:
            contentView = [[Sample11 alloc] initWithFrame:frame];
            break;
        case 12:
            contentView = [[Sample12 alloc] initWithFrame:frame];
            break;
        case 13:
            contentView = [[Sample13 alloc] initWithFrame:frame];
            break;
        case 14:
            contentView = [[Sample14 alloc] initWithFrame:frame];
            break;
        default:
            break;
    }
    CoreTextViewController *vc = [[CoreTextViewController alloc] initWithContentView:contentView];
    vc.title = [self.cellTexts objectAtIndex:indexPath.row];
     [self.navigationController pushViewController:vc animated:YES];
}

@end
