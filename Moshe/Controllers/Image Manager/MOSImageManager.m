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
 *  @param key The key for the image, also the URL for the remote resource.
 *  @param handler A block to handle the loaded image.
 */

- (void)loadImageForKey:(NSString *)key withHandler:(MOSImageLookupBlock)handler
{
    //  By default, attempt to load from the cache.
    UIImage *image = [[self cache] objectForKey:key];
    
    NSString *filename = [key stringByAddingPercentEncodingWithAllowedCharacters:[NSCharacterSet URLPathAllowedCharacterSet]];
    NSString *path = [[[self applicationCachesDirectory] path] stringByAppendingPathComponent:filename];
    
    if (!image)
    {
        image = [UIImage imageWithContentsOfFile:path];
    }
    
    if (!image) {
        NSData *data = [NSData dataWithContentsOfURL:[NSURL URLWithString:key]];
        image = [[UIImage alloc] initWithData:data];
    }
    
    
    if (image) {
        [[self cache] setObject:image forKey:key];
    }
    
    if (handler) {
        handler(image);
    }
}

- (void)saveImage:(UIImage *)image toPath:(NSString *)path
{
    NSData *data = [[NSData alloc] initWithData:UIImagePNGRepresentation(image)];
    [data writeToFile:path atomically:NO];
}

/** ---
 *  @name   Caches Directory Access
 *  ---
 */

#pragma mark - Application's Documents directory

// Returns the URL to the application's Documents directory.
- (NSURL *)applicationCachesDirectory
{
    return [[[NSFileManager defaultManager] URLsForDirectory:NSCachesDirectory inDomains:NSUserDomainMask] lastObject];
}

@end
