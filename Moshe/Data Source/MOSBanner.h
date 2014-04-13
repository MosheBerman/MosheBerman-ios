//
//  MOSBanner.h
//  Moshe Berman
//
//  Created by Moshe Berman on 4/13/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

@interface MOSBanner : NSObject

/**
 *  The URL that the banner points to.
 */

@property (nonatomic, strong) NSURL *url;

/**
 *  The URL pointing to the banner image.
 */

@property (nonatomic, strong) NSURL *imageURL;

/**
 *  The title of the banner.
 */

@property (nonatomic, strong) NSString *title;

@end
