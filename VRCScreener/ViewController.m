//
//  ViewController.m
//  VRCScreener
//
//  Created by Jarred Alldredge on 1/21/15.
//  Copyright (c) 2015 Vision Research. All rights reserved.
//

#import "ViewController.h"
#import <DBChooser/DBChooser.h>

@interface ViewController ()

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
}

- (void)didPressChoose
{
    [[DBChooser defaultChooser] openChooserForLinkType:DBChooserLinkTypeDirect
                                    fromViewController:self completion:^(NSArray *results)
     {
         if ([results count]) {
             NSArray *arrayR = results;
        } else {
             // User canceled the action
         }
     }];
}

- (IBAction)dbChoose:(id)sender {
    
    [self didPressChoose];
}
@end
