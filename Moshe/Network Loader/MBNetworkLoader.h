//
//  MBNetworkLoader.h
//  Moshe
//
//  Created by Moshe Berman on 5/2/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

#import <Foundation/Foundation.h>

// Can return YES on save operations and such...
typedef void(^MBDataLoaderCompletion)(NSData *data);

@interface MBNetworkLoader : NSObject

- (id)initWithURL:(NSURL *)url completion:(MBDataLoaderCompletion)completion;

- (void)start;
- (double)progress;
- (void)cancelCompletion;

@end
