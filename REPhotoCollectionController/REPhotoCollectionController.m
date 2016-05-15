//
// REPhotoCollectionController.m
// REPhotoCollectionController
//
// Copyright (c) 2012 Roman Efimov (https://github.com/romaonthego)
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

#import "REPhotoCollectionController.h"
#import "REPhotoThumbnailsCell.h"

@interface REPhotoCollectionController () <UIGestureRecognizerDelegate>

@end

@implementation REPhotoCollectionController

@synthesize datasource = _datasource;
@synthesize groupByDate = _groupByDate;
@synthesize thumbnailViewClass = _thumbnailViewClass;

- (void)reloadData
{
    
    NSArray *sorted = [_datasource sortedArrayUsingComparator:^NSComparisonResult(id obj1, id obj2) {
        NSObject <REPhotoObjectProtocol> *photo1 = obj1;
        NSObject <REPhotoObjectProtocol> *photo2 = obj2;
        
        
        if ( [photo1.date compare:photo2.date] == NSOrderedDescending) {
            return NSOrderedDescending;
        }
        else
            return NSOrderedAscending;
    }];
    [_ds removeAllObjects];
    
    sorted = [[sorted reverseObjectEnumerator] allObjects];
    
    if (!_groupByDate) {
        for (NSObject *object in sorted) {
            NSObject <REPhotoObjectProtocol> *photo = (NSObject <REPhotoObjectProtocol> *)object;
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |
                                            NSMonthCalendarUnit | NSYearCalendarUnit fromDate:photo.date];
            NSUInteger month = [components month];
            NSUInteger year = [components year];
            NSUInteger day = [components day];
            REPhotoGroup *group = ^REPhotoGroup *{
                for (REPhotoGroup *group in _ds) {
                    if (group.month == month && group.year == year && group.day == day)
                        return group;
                }
                return nil;
            }();
            if (group == nil) {
                group = [[REPhotoGroup alloc] init];
                group.month = month;
                group.year = year;
                group.day = day;
                [group.items addObject:photo];
                [_ds addObject:group];
            } else {
                [group.items addObject:photo];
            }
        }
    }
    else {
        for (NSObject *object in sorted) {
            NSObject <REPhotoObjectProtocol> *photo = (NSObject <REPhotoObjectProtocol> *)object;
            NSDateComponents *components = [[NSCalendar currentCalendar] components:NSDayCalendarUnit |
                                            NSMonthCalendarUnit | NSYearCalendarUnit fromDate:photo.date];
            NSUInteger month = [components month];
            NSUInteger year = [components year];
            REPhotoGroup *group = ^REPhotoGroup *{
                for (REPhotoGroup *group in _ds) {
                    if (group.month == month && group.year == year)
                        return group;
                }
                return nil;
            }();
            if (group == nil) {
                group = [[REPhotoGroup alloc] init];
                group.month = month;
                group.year = year;
                [group.items addObject:photo];
                [_ds addObject:group];
            } else {
                [group.items addObject:photo];
            }
        }
    }
    
    [self.tableView reloadData];
}

#pragma mark -
#pragma mark UITableViewController functions

- (void)setDatasource:(NSMutableArray *)datasource
{
    _datasource = datasource;
    [self reloadData];
}

- (id)initWithStyle:(UITableViewStyle)style
{
    self = [super initWithStyle:style];
    if (self) {
        _ds = [[NSMutableArray alloc] init];
        self.groupByDate = YES;
        self.tableView.separatorStyle = UITableViewCellSeparatorStyleNone;
        self.defaultTransform = self.view.transform;
    }
    return self;
}

- (id)initWithDatasource:(NSArray *)datasource
{
    self = [self initWithStyle:UITableViewStylePlain];
    if (self) {
        self.datasource = [NSMutableArray arrayWithArray:datasource];
    }
    return self;
}

- (BOOL)shouldAutorotateToInterfaceOrientation:(UIInterfaceOrientation)interfaceOrientation
{
    return (interfaceOrientation == UIInterfaceOrientationPortrait);
}

#pragma mark -
#pragma mark Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
    if ([_ds count] == 0) return 0;
    if (!_ds) return 1;
    
    if ([self tableView:self.tableView numberOfRowsInSection:[_ds count] - 1] == 0) {
        return [_ds count] - 1;
    }
    return [_ds count];
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    REPhotoGroup *group = (REPhotoGroup *)[_ds objectAtIndex:section];
    return ceil([group.items count] / 4.0f);
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    static NSString *CellIdentifier = @"REPhotoThumbnailsCell";
    REPhotoThumbnailsCell *cell = [tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    
    if (cell == nil) {
        cell = [[REPhotoThumbnailsCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier thumbnailViewClass:_thumbnailViewClass];
    }
    
    REPhotoGroup *group = (REPhotoGroup *)[_ds objectAtIndex:indexPath.section];
    
    int startIndex = indexPath.row * 4;
    int endIndex = startIndex + 4;
    if (endIndex > [group.items count])
        endIndex = [group.items count];
    
    [cell removeAllPhotos];
    for (int i = startIndex; i < endIndex; i++) {
        NSObject <REPhotoObjectProtocol> *photo = [group.items objectAtIndex:i];
        [cell addPhoto:photo];
    }
    [cell refresh];
    
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForHeaderInSection:(NSInteger)section
{
    return 44;
}

- (UIView*) tableView:(UITableView *)tableView viewForHeaderInSection:(NSInteger)section {
    
    UIView *header = [[UIView alloc] initWithFrame:CGRectMake(0, 0, self.view.frame.size.width, 44)];
    header.backgroundColor = [UIColor whiteColor];
    header.alpha = 0.7;
    
    UITapGestureRecognizer *tgr = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(handleTap:)];
    tgr.delegate = self;
    [header addGestureRecognizer:tgr];
    
    UILabel *title = [[UILabel alloc] initWithFrame:CGRectMake(20, 0, header.frame.size.width - 40 , 44)];
    
    if (!_groupByDate) {
        REPhotoGroup *group = (REPhotoGroup *)[_ds objectAtIndex:section];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i-%i-%i", group.year, group.month, group.day]];
        
        [dateFormatter setDateFormat:@"dd MMMM yyyy"];
        NSString *resultString = [NSString stringWithFormat:@"< %@", [dateFormatter stringFromDate:date]];
        title.text = resultString;
    }
    else {
        REPhotoGroup *group = (REPhotoGroup *)[_ds objectAtIndex:section];
        
        NSDateFormatter *dateFormatter = [[NSDateFormatter alloc] init];
        [dateFormatter setDateFormat:@"yyyy-MM-dd"];
        NSDate *date = [dateFormatter dateFromString:[NSString stringWithFormat:@"%i-%i-1", group.year, group.month]];
        
        [dateFormatter setDateFormat:@"MMMM yyyy"];
        NSString *resultString = [NSString stringWithFormat:@"%@ >", [dateFormatter stringFromDate:date]];
        title.text = resultString;
    }
    
    [header addSubview:title];
    
    return header;
}

- (UIView *)tableView:(UITableView *)tableView viewForFooterInSection:(NSInteger)section
{
    UIView *view = [[UIView alloc] initWithFrame:CGRectMake(0, 0, 320, 5)];
    return view;
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    REPhotoGroup *group = (REPhotoGroup *)[_ds objectAtIndex:indexPath.section];
    NSObject <REPhotoObjectProtocol> *photo = [group.items objectAtIndex:indexPath.row];

    if (self.groupByDate == YES) {
        self.groupByDate = !self.groupByDate;

        [UIView animateWithDuration:0.5 animations: ^{
            self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5 , 1.5);
        } completion:^(BOOL finished) {
            self.view.transform = _defaultTransform;
            [self reloadData];
        }];
    }
    else {
        UIAlertView *msg = [[UIAlertView alloc] initWithTitle:@"TEST" message:photo.thumbnailString delegate:self cancelButtonTitle:@"OK" otherButtonTitles: nil];
        [msg show];
    }
}

#pragma mark -
#pragma mark Table view delegate

- (CGFloat)tableView:(UITableView *)tableView heightForFooterInSection:(NSInteger)section
{
    return 5;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return 80;
}

#pragma mark - Gesture Recognizer

- (void)handleTap:(UIPinchGestureRecognizer *)gestureRecognizer {
    
    if ([gestureRecognizer state] == UIGestureRecognizerStateEnded) {
        
        self.groupByDate = !self.groupByDate;
        
        [UIView animateWithDuration:0.5 animations: ^{
            if (!self.groupByDate)
                self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 1.5 , 1.5);
            else
                self.view.transform = CGAffineTransformScale(CGAffineTransformIdentity, 0.8 , 0.8);
        } completion:^(BOOL finished) {
            self.view.transform = _defaultTransform;
            [self reloadData];
        }];
    }
}

#pragma mark - UIAnimation

@end
