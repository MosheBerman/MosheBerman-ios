//
//  MBBlogPostData.h
//  Moshe Berman
//
//  Created by Moshe Berman on 4/13/14.
//  Copyright (c) 2014 Moshe Berman. All rights reserved.
//

@import Foundation;

@interface MOSBlogPost : NSObject

/**
 *  A post ID. (Generated by the blogging software I use.)
 */

@property (nonatomic, strong) NSNumber *postID;

/**
 *  The post's slug.
 */

@property (nonatomic, strong) NSString *slug;

/**
 *  The URL of the blog post.
 */

@property (nonatomic, strong) NSURL *URL;

/**
 *  The name of the post.
 */

@property (nonatomic, strong) NSString *title;

/**
 *  The post's content.
 */

@property (nonatomic, strong) NSString *content;

/**
 *  The date the post was published.
 */

@property (nonatomic, strong) NSDate *date;

/**
 *  The names of the tags that the post carries.
 */

@property (nonatomic, strong) NSArray *tags;

/**
 *  The categories that the post is filed under.
 */

@property (nonatomic, strong) NSArray *categories;

@end
