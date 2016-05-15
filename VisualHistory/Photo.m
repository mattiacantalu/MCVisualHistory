//
//  Photo.m
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import "Photo.h"

@implementation Photo

@synthesize thumbnailString = _thumbnailString, date = _date, thumbnail = _thumbnail;

- (id)initWithThumbnailURL:(NSString *)thumbnailString date:(NSDate *)date
{
    self = [super init];
    if (self) {
        _thumbnailString = thumbnailString;
        _date = date;
    }
    return self;
}

+ (Photo *)photoWithURLString:(NSString *)urlString date:(NSDate *)date
{
    return [[Photo alloc] initWithThumbnailURL:urlString date:date];
}

@end
