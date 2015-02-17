//
//  AWBitmap.m
//  LoopCEChallenge
//
//  Created by Marcio Fonseca on 2/16/15.
//  Copyright (c) 2015 Anyware Labs. All rights reserved.
//

#import "AWBitmap.h"

@interface AWBitmap ()

@property (assign, nonatomic) NSUInteger currentByteWithPadding;
@property (assign, nonatomic) NSUInteger currentByte;
@property (assign, nonatomic) uint8_t character;

@end

@implementation AWBitmap

-(instancetype)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.header = [AWBitmapHeader new];
    self.message = [NSMutableString new];
    return self;
}

+(AWBitmap*)bitmapWithData:(NSData*)data
{
    AWBitmap *bitmap = [AWBitmap new];
    [bitmap appendData:data];
    return bitmap;
}

-(void)appendData:(NSData*)data
{
    
    NSUInteger addedInHeader = 0;
    
    if(!self.header.complete) {
        addedInHeader = [self.header appendData:data];
    }
    
    if (addedInHeader < data.length) {
        NSData *pixels = [data subdataWithRange:NSMakeRange(addedInHeader, data.length - addedInHeader)];
        [self addPixels:pixels];
    }
}

-(void)addPixels:(NSData *)pixels
{
    [pixels enumerateByteRangesUsingBlock:^(const void *bytes,
                                          NSRange byteRange,
                                          BOOL *stop) {
        
        for (NSUInteger i = 0; i < byteRange.length; i++) {
           
            uint8_t byte = ((uint8_t*)bytes)[i];
            
            // discard padding
            if (self.currentByteWithPadding++ % [self rowLengthWithPadding] >= [self rowLength]) {
                continue;
            }
            
            if (byte & 1) {
                self.character |= (1 << (self.currentByte % 8));
            }
            
            if ((++self.currentByte) % 8 == 0) {
                
                //NSLog(@"%c", self.character);
                //NSLog(@"Character: %@", [self stringWithBits:self.character]);
                [self.message appendString:[NSString stringWithFormat:@"%c", self.character]];
                self.character = 0;
            }
        }
    }];
}

-(NSUInteger)rowLength
{
    NSUInteger rowLength =  self.header.width * self.header.bitsPerPixel/8 + 2;
    return rowLength;
}

-(NSUInteger)rowLengthWithPadding
{
    return [self rowLength] + [self padding];
}

-(NSUInteger)padding
{
    return ((4 - ([self rowLength] % 4)) % 4);
}

-(NSString *)description
{
    NSMutableString *descriptionString = [NSMutableString stringWithFormat:@"%@", self.header];
    
    if (self.message && self.message.length) {
        [descriptionString appendString:[NSMutableString stringWithFormat:@"\nMessage:\n%@", self.message]];
    }
    
    return descriptionString;
}

// just for debugging
-(NSString*) stringWithBits:(int8_t)mask {
    NSMutableString *mutableStringWithBits = [NSMutableString new];
    for (int8_t bitIndex = 0; bitIndex < sizeof(mask) * 8; bitIndex++) {
        [mutableStringWithBits insertString:mask & 1 ? @"1" : @"0" atIndex:0];
        mask >>= 1;
    }
    return [mutableStringWithBits copy];
}


@end
