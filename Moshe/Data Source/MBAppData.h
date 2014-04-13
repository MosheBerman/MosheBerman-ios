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

@property (nonatomic, strong) NSString * appDescription;
@property (nonatomic, strong) NSString * appID;
@property (nonatomic, strong) NSString * imageURL;
@property (nonatomic, strong) NSString * appURL;
@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSString * version;

@end
