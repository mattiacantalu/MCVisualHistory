//
//  ThumbnailView.h
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import "REPhotoThumbnailView.h"
#import "UIImageView+UIActivityIndicatorForSDWebImage.h"

@interface ThumbnailView : REPhotoThumbnailView {
    UIImageView *imageView;
}

- (void)setPhoto:(NSObject <REPhotoObjectProtocol> *)photo;

@end
