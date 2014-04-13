//
//  MBDataSource.h
//  Moshe
//
//  Created by Moshe Berman on 5/2/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import Foundation;

typedef void(^MBDataSourceCompletionBlock)(void);

@interface MBDataSource : NSObject

@property (nonatomic, strong) NSMutableArray *apps;
@property (nonatomic, strong) NSMutableArray *blogPosts;
@property (nonatomic, strong) NSMutableArray *repos;

@property (nonatomic, strong) NSMutableArray *banners;

/**
 *  Reloads the table data and calls the completion block for *each* request that is completed.
 *
 *  @param completion A completion block that gets called after each category loads.
 */

- (void)reloadDataWithCompletion:(MBDataSourceCompletionBlock)completion;

/**
 *  This method downloads the banners.
 *
 *  @param completion A completion block that gets called when the data gets loaded.
 */

- (void)loadBannersWithCompletion:(MBDataSourceCompletionBlock)completion;

@end
