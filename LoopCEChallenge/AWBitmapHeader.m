//
//  AWBitmapHeader.m
//  LoopCEChallenge
//
//  Created by Marcio Fonseca on 2/16/15.
//  Copyright (c) 2015 Anyware Labs. All rights reserved.
//

#import "AWBitmapHeader.h"

@interface AWBitmapHeader ()

@property (assign, nonatomic) NSUInteger maxLength;
@property (strong, nonatomic) NSMutableData *data;

@end

static NSUInteger const kAWHeaderSize = 14;

@implementation AWBitmapHeader

-(instancetype)init
{
    self = [super init];
    
    if (!self) {
        return nil;
    }
    
    self.maxLength = kAWHeaderSize;
    self.data = [NSMutableData new];
    return self;
}

-(NSUInteger)appendData:(NSData*)data
{
    NSUInteger added = self.maxLength - self.data.length;
    
    if (added > 0) {
        [self.data appendData:[data subdataWithRange:NSMakeRange(0, added)]];
    }
    
    // DIB header data has variable size
    if (self.maxLength == self.data.length && self.pixelArrayOffset > self.maxLength) {
        self.maxLength = self.pixelArrayOffset;
        
        NSUInteger addedDIB = self.maxLength - self.data.length;
        added += addedDIB;
        
        if (addedDIB > 0) {
            [self.data appendData:[data subdataWithRange:NSMakeRange(self.data.length, addedDIB)]];
            
        }
    }
    
    return added;
}

-(BOOL)complete
{
    return self.data.length == self.maxLength && self.pixelArrayOffset >= self.maxLength;
}

-(NSString *)typeId
{
    NSData *subData = [self.data subdataWithRange:NSMakeRange(0, 2)];
    return [[NSString alloc] initWithData:subData encoding:NSASCIIStringEncoding];
}

-(unsigned int)fileSize
{
    return [AWBitmapHeader intFromData:self.data offset:2];
}

-(unsigned short)applicationSpecific1
{
    return [AWBitmapHeader shortFromData:self.data offset:6];
}

-(unsigned short)applicationSpecific2
{
    return [AWBitmapHeader shortFromData:self.data offset:8];
}

-(unsigned int)pixelArrayOffset
{
    if (self.data.length >= kAWHeaderSize) {
        return [AWBitmapHeader intFromData:self.data offset:10];
    }
    
    return 0;
}

-(unsigned int)dibSize
{
    return [AWBitmapHeader intFromData:self.data offset:14];
}

-(unsigned int)height
{
    return [AWBitmapHeader intFromData:self.data offset:18];
}

-(unsigned int)width
{
    return [AWBitmapHeader intFromData:self.data offset:22];
}

-(unsigned short)colorPlanes
{
    return [AWBitmapHeader shortFromData:self.data offset:26];
}

-(unsigned short)bitsPerPixel
{
    return [AWBitmapHeader shortFromData:self.data offset:28];
}

-(unsigned int)compressionMethod
{
    return [AWBitmapHeader intFromData:self.data offset:30];
}

-(unsigned int)rawBitmapSize
{
    return [AWBitmapHeader intFromData:self.data offset:34];
}

-(unsigned int)horizontalResolution
{
    return [AWBitmapHeader intFromData:self.data offset:38];
}

-(unsigned int)verticalResolution
{
    return [AWBitmapHeader intFromData:self.data offset:42];
}

-(unsigned int)colorsInPalette
{
    return [AWBitmapHeader intFromData:self.data offset:46];
}

-(unsigned int)importantColors
{
    return [AWBitmapHeader intFromData:self.data offset:50];
}

+(unsigned int)intFromData:(NSData*)data offset:(int)offset
{
    NSData *subData = [data subdataWithRange:NSMakeRange(offset, 4)];
    return *((unsigned int*)[subData bytes]);
}

+(unsigned int)shortFromData:(NSData*)data offset:(int)offset
{
    NSData *subData = [data subdataWithRange:NSMakeRange(offset, 2)];
    return *((unsigned int*)[subData bytes]);
}

-(NSString *)description
{
    NSMutableString *descriptionString = [NSMutableString stringWithString:@"\nBitmap File Header\n"];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Id: %@\n", self.typeId]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- File size: %d bytes\n", self.fileSize]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Application specific 1: %d\n", self.applicationSpecific1]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Application specific 2: %d\n", self.applicationSpecific2]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Pixel array offset: %d bytes\n", self.pixelArrayOffset]];
    
    [descriptionString appendString:@"\nDIB Header\n"];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- DIB size: %d bytes\n", self.dibSize]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Image width: %d pixels\n", self.width]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Image height: %d pixels\n", self.height]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Color planes: %d pixels\n", self.colorPlanes]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Bits per pixel: %d\n", self.bitsPerPixel]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Compression method: %d\n", self.compressionMethod]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Raw bitmap size: %d bytes\n", self.rawBitmapSize]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Horizontal Resolution: %d\n", self.horizontalResolution]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Vertical Resolution: %d\n", self.verticalResolution]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Number of colors in palette: %d\n", self.colorsInPalette]];
    [descriptionString appendString:[NSMutableString stringWithFormat:@"- Number of important colors: %d\n", self.importantColors]];
    
    
    return descriptionString;
}

@end
