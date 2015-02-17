//
//  AWBitmapHeader.h
//  LoopCEChallenge
//
//  Created by Marcio Fonseca on 2/16/15.
//  Copyright (c) 2015 Anyware Labs. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface AWBitmapHeader : NSObject

// BMP Header
@property (strong, nonatomic) NSString *typeId;
@property (assign, nonatomic) unsigned int fileSize;
@property (assign, nonatomic) unsigned short applicationSpecific1;
@property (assign, nonatomic) unsigned short applicationSpecific2;
@property (assign, nonatomic) unsigned int pixelArrayOffset;

// DIB Header
@property (assign, nonatomic) unsigned int dibSize;
@property (assign, nonatomic) unsigned int height;
@property (assign, nonatomic) unsigned int width;
@property (assign, nonatomic) unsigned short colorPlanes;
@property (assign, nonatomic) unsigned short bitsPerPixel;
@property (assign, nonatomic) unsigned int compressionMethod;
@property (assign, nonatomic) unsigned int rawBitmapSize;
@property (assign, nonatomic) unsigned int horizontalResolution;
@property (assign, nonatomic) unsigned int verticalResolution;
@property (assign, nonatomic) unsigned int colorsInPalette;
@property (assign, nonatomic) unsigned int importantColors;

//+(AWBitmapHeader*)headerWithData:(NSData*)data;
-(NSUInteger)appendData:(NSData*)data;
-(BOOL)complete;

@end
