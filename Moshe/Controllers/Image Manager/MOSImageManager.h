//
//  MOSImageManager.h
//  Moshe Berman
//
//  Created by Moshe Berman on 4/13/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

/**
 *  A block that offers access to whatever image is being requested.
 */
typedef void(^MOSImageLookupBlock)(UIImage *image);

@interface MOSImageManager : NSObject

/**
 *  @return The singleton image manager.
 */

+ (MOSImageManager *)sharedManager;

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

- (void)loadImageForKey:(NSString *)key withHandler:(MOSImageLookupBlock)handler;



@end
