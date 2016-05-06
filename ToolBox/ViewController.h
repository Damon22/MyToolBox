//
//  ViewController.h
//  ToolBox
//
//  Created by 高继鹏 on 16/5/3.
//  Copyright © 2016年 GaoJipeng. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController

@property (weak, nonatomic) IBOutlet UIView *scanView;

@property (weak, nonatomic) IBOutlet UITextView *showURLTV;

@property (weak, nonatomic) IBOutlet UIButton *lightningBtn;

- (IBAction)startScan:(id)sender;

- (IBAction)goLink:(id)sender;

@end

