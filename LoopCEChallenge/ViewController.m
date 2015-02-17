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
@property (strong, nonatomic) NSMutableData *data;
//@property (strong, nonatomic) NSNumber *bytesRead;
@property (strong, nonatomic) AWBitmap *bitmap;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
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
            if(!_data) {
                _data = [[NSMutableData alloc] init];
            }
            
            uint8_t buf[1024];
            long len = 0;
            len = [(NSInputStream *)stream read:buf maxLength:1024];
            
            if(len) {
                
                [self.bitmap appendData:[NSData dataWithBytes:buf length:len]];
                
                //[_data appendBytes:(const void *)buf length:len];
                //self.bytesRead = @([self.bytesRead intValue]+len);
                
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
            
            //self.bitmap = [AWBitmap bitmapWithData:self.data];
            NSLog(@"Bitmap data:\n\n%@", self.bitmap.description);
            
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


@end
