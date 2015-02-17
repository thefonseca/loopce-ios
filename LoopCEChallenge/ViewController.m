//
//  ViewController.m
//  LoopCEChallenge
//
//  Created by Marcio Fonseca on 2/16/15.
//  Copyright (c) 2015 Anyware Labs. All rights reserved.
//

#import "ViewController.h"
#import "AWBitmap.h"


@interface ViewController ()

@property (strong, nonatomic) NSInputStream *iStream;
@property (strong, nonatomic) AWBitmap *bitmap;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    self.label.alpha = 0;
    
    self.bitmap = [AWBitmap new];
    
    NSString *path = [[NSBundle mainBundle] pathForResource:@"testImage" ofType:@"bmp"];
    [self setUpStreamForFile:path];
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

- (void)setUpStreamForFile:(NSString *)path {
    self.iStream = [[NSInputStream alloc] initWithFileAtPath:path];
    self.iStream.delegate = self;
    [self.iStream scheduleInRunLoop:[NSRunLoop currentRunLoop]
                       forMode:NSDefaultRunLoopMode];
    [self.iStream open];
}

- (void)stream:(NSStream *)stream handleEvent:(NSStreamEvent)eventCode {
    
    switch(eventCode) {
        case NSStreamEventHasBytesAvailable:
        {
            uint8_t buf[1024];
            long len = 0;
            len = [(NSInputStream *)stream read:buf maxLength:1024];
            
            if(len) {
                
                [self.bitmap appendData:[NSData dataWithBytes:buf length:len]];
                
            } else {
                NSLog(@"no buffer!");
            }
            
            break;
        }
            
        case NSStreamEventEndEncountered:
        {
            [stream close];
            [stream removeFromRunLoop:[NSRunLoop currentRunLoop]
                              forMode:NSDefaultRunLoopMode];
            stream = nil;
            
            self.label.text = self.bitmap.message;
            NSLog(@"Bitmap data:\n%@", self.bitmap.description);
            
            break;
        }
        
        case NSStreamEventErrorOccurred:
        {
            NSError *theError = [stream streamError];
            UIAlertView *alertView = [[UIAlertView alloc]
                                      initWithTitle:@"Error reading stream!"
                                      message:[NSString stringWithFormat:@"Error %li: %@",
                                               (long)theError.code, [theError localizedDescription]]
                                      delegate:nil
                                      cancelButtonTitle:NSLocalizedString(@"OK", @"")
                                      otherButtonTitles:nil];
            
            [alertView show];
            [stream close];
            break;
        }
            
        case NSStreamEventOpenCompleted:
            
        case NSStreamEventHasSpaceAvailable:
            
        case NSStreamEventNone:
            
        default: ;
            
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    
    CGFloat scrollOffset = scrollView.contentOffset.y;
    CGFloat scrollOffsetYLimit = -CGRectGetHeight(scrollView.bounds) / 5;
    
    if (scrollOffset < scrollOffsetYLimit) {
        scrollView.contentOffset = CGPointMake(scrollView.contentOffset.x, scrollOffsetYLimit);
        scrollOffset = scrollOffsetYLimit;
    }
    
    CGFloat newHeight = self.imageView.frame.size.height - scrollOffset;
    CGFloat newScale = newHeight/self.imageView.frame.size.height;
    
    if (scrollOffset < 0.0) {
        if (newScale > 1.0 && newScale < 2.0)
        {
            self.imageView.transform = CGAffineTransformMakeScale(newScale, newScale);
            CGFloat xPos = (self.imageView.superview.frame.size.width - self.imageView.frame.size.width)/2;
            [self.imageView setFrame:CGRectMake(xPos, 0, self.imageView.frame.size.width, self.imageView.frame.size.height)];
            
        }
        
        self.imageView.alpha = 1 - scrollOffset/scrollOffsetYLimit;
        self.scrolldownLabel.alpha = 1 - scrollOffset/scrollOffsetYLimit;
        self.label.alpha = scrollOffset/scrollOffsetYLimit;
    }
}


@end
