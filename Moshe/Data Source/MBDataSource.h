//
//  MBDataSource.h
//  Moshe
//
//  Created by Moshe Berman on 5/2/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MBDataSource : NSObject

@property (nonatomic, assign) BOOL areAppsReady;
@property (nonatomic, assign) BOOL areBlogPostsReady;
@property (nonatomic, assign) BOOL areReposReady;

@property (nonatomic, strong) NSMutableArray *apps;
@property (nonatomic, strong) NSMutableArray *blogPosts;
@property (nonatomic, strong) NSMutableArray *repos;

- (void)reloadData;


@end
