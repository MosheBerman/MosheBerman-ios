//
//  MOSImageManager.m
//  Moshe Berman
//
//  Created by Moshe Berman on 4/13/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import "MOSImageManager.h"

@interface MOSImageManager ()

/**
 *  An image cache.
 */

@property (nonatomic, strong) NSCache *cache;

@end

@implementation MOSImageManager

/**
 *  Designated initializer
 */

- (instancetype)init
{
    self = [super init];
    if (self) {
        _cache = [[NSCache alloc] init];
    }
    return self;
}
/**
 *  @return The singleton image manager.
 */

+ (MOSImageManager *)sharedManager
{
    static MOSImageManager *manager = nil;
    
    static dispatch_once_t onceToken;
    dispatch_once(&onceToken, ^{
        manager = [[MOSImageManager alloc] init];
    });
    return manager;
}


/**
 *  This method checks several sources for a keyed image.
 *  The sources, in order, are:
 *
 *  - An in memory cache
 *  - Local disk
 *  - The network
 *
 *  @param key The key for the image.
 *  @param handler A block to handle the loaded image.
 */

- (void)loadImageForKey:(NSString *)key withHandler:(MOSImageLookupBlock)handler
{
    
}

@end
