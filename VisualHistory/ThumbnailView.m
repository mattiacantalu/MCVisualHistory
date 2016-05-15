//
//  ThumbnailView.m
//  REPhotoCollectionControllerExample
//
//  Created by Roman Efimov on 7/27/12.
//  Copyright (c) 2012 Roman Efimov. All rights reserved.
//

#import "ThumbnailView.h"

@implementation ThumbnailView

- (void)setPhoto:(NSObject <REPhotoObjectProtocol> *)photo
{
    if (photo.thumbnailURL) {
        [imageView setImageWithURL:photo.thumbnailURL placeholderImage:[UIImage imageNamed:@"No_image_available.png"] usingActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
    } else {
        [imageView setImage:photo.thumbnail];
    }
}

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        imageView = [[UIImageView alloc] initWithFrame:CGRectMake(1, 1, self.frame.size.width - 2, self.frame.size.height - 2)];
        imageView.contentMode = UIViewContentModeScaleAspectFill;
        [self addSubview:imageView];
    }
    return self;
}

/*
// Only override drawRect: if you perform custom drawing.
// An empty implementation adversely affects performance during animation.
- (void)drawRect:(CGRect)rect
{
    // Drawing code
}
*/

@end
