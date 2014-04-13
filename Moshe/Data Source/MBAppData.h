//
//  MBAppData.h
//  Moshe
//
//  Created by Moshe Berman on 5/2/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import Foundation;

/*

 This class pulls data from an endpoint on MosheBerman.com
 
 A sample response:
 
 "app_description": "Uncle Fred is my first app. He tells eyeball jokes.",
 "app_id":"3",
 "app_image_link": "1302766787.png",
 "app_link": "http:\/\/itunes.apple.com\/us\/app\/uncle-fred\/id363988296?mt=8",
 "app_name": "Uncle Fred",
 "app_version": "1.5"
 }
 
 */

@interface MBAppData : NSObject

/**
 *  The app's description.
 */

@property (nonatomic, strong) NSString * appDescription;

/**
 *  This is not the iTunes Connect app ID, but a custom zero based ID.
 */

@property (nonatomic, strong) NSString * appID;

/**
 *  The URL to an app icon stored on my server.
 */

@property (nonatomic, strong) NSString * imageURL;

/**
 *  The URL to the app on the iTunes app store.
 */

@property (nonatomic, strong) NSURL * appURL;

/**
 *  The name of the app.
 */

@property (nonatomic, strong) NSString * name;

/**
 *  The latest app version, as per my database.
 */

@property (nonatomic, strong) NSString * version;

@end
