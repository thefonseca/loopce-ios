//
//  AWBitmap.h
//  LoopCEChallenge
//
//  Created by Marcio Fonseca on 2/16/15.
//  Copyright (c) 2015 Anyware Labs. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "AWBitmapHeader.h"

@interface AWBitmap : NSObject

@property (strong, nonatomic) AWBitmapHeader *header;
@property (strong, nonatomic) NSMutableString *message;

-(void)appendData:(NSData*)data;

@end
