//
//  ViewController.h
//  LoopCEChallenge
//
//  Created by Marcio Fonseca on 2/16/15.
//  Copyright (c) 2015 Anyware Labs. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface ViewController : UIViewController <NSStreamDelegate, UIScrollViewDelegate>

@property (weak, nonatomic) IBOutlet UIImageView *imageView;
@property (weak, nonatomic) IBOutlet UIScrollView *scrollView;
@property (weak, nonatomic) IBOutlet UILabel *label;
@property (weak, nonatomic) IBOutlet UILabel *scrolldownLabel;

@end

