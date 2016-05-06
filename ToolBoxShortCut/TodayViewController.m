//
//  TodayViewController.m
//  ToolBoxShortCut
//
//  Created by 高继鹏 on 16/5/4.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

/** 屏幕高度 */
#define SCREEN_HEIGHT       [[UIScreen mainScreen] bounds].size.height
/** 屏幕宽度 */
#define SCREEN_WIDTH        [[UIScreen mainScreen] bounds].size.width

#import "TodayViewController.h"
#import <NotificationCenter/NotificationCenter.h>

@interface TodayViewController () <NCWidgetProviding>

@property (strong, nonatomic) IBOutlet UIView *contentView;

@end

@implementation TodayViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    
    self.contentView.frame = CGRectMake(0, 0, SCREEN_WIDTH, 37);
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (UIEdgeInsets)widgetMarginInsetsForProposedMarginInsets:(UIEdgeInsets)defaultMarginInsets {
    return UIEdgeInsetsZero;
}

- (IBAction)scanQuickAction:(id)sender {
    [self.extensionContext openURL:[NSURL URLWithString:@"iOSWidgetApp://action=beginScan"] completionHandler:^(BOOL success) {
        NSLog(@"open url result:%d",success);
    }];

}

- (void)widgetPerformUpdateWithCompletionHandler:(void (^)(NCUpdateResult))completionHandler {
    // Perform any setup necessary in order to update the view.
    
    // If an error is encountered, use NCUpdateResultFailed
    // If there's no update required, use NCUpdateResultNoData
    // If there's an update, use NCUpdateResultNewData

    completionHandler(NCUpdateResultNewData);
}

@end
