//
//  Photo.h
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import <Foundation/Foundation.h>
#import "REPhotoObjectProtocol.h"
#import <UIKit/UIKit.h>

@interface Photo : NSObject <REPhotoObjectProtocol>

@property (nonatomic, strong) NSString *thumbnailString;
@property (nonatomic, strong) UIImage *thumbnail;
@property (nonatomic, strong) NSDate *date;

- (id)initWithThumbnailURL:(NSString *)thumbnailString date:(NSDate *)date;
+ (Photo *)photoWithURLString:(NSString *)urlString date:(NSDate *)date;

@end
