//
//  MBRepoData.h
//  Moshe
//
//  Created by Moshe Berman on 5/2/13.
//  Copyright (c) 2013 Moshe Berman. All rights reserved.
//

@import Foundation;

@interface MOSRepo : NSObject

@property (nonatomic, strong) NSString * name;
@property (nonatomic, strong) NSURL * htmlURL;
@property (nonatomic, strong) NSString * repoDescription;

@end


/*
 Sample GitHub Repo:
 
 https://api.github.com/users/mosheberman/repos
 
 {
 "id": 5283215,
 "name": "MBTileParser",
 "full_name": "MosheBerman/MBTileParser",
 "owner": {
 "login": "MosheBerman",
 "id": 427452,
 "avatar_url": "https://secure.gravatar.com/avatar/57f5ee2e1627b45e923de962ab0b0eab?d=https://a248.e.akamai.net/assets.github.com%2Fimages%2Fgravatars%2Fgravatar-user-420.png",
 "gravatar_id": "57f5ee2e1627b45e923de962ab0b0eab",
 "url": "https://api.github.com/users/MosheBerman",
 "html_url": "https://github.com/MosheBerman",
 "followers_url": "https://api.github.com/users/MosheBerman/followers",
 "following_url": "https://api.github.com/users/MosheBerman/following",
 "gists_url": "https://api.github.com/users/MosheBerman/gists{/gist_id}",
 "starred_url": "https://api.github.com/users/MosheBerman/starred{/owner}{/repo}",
 "subscriptions_url": "https://api.github.com/users/MosheBerman/subscriptions",
 "organizations_url": "https://api.github.com/users/MosheBerman/orgs",
 "repos_url": "https://api.github.com/users/MosheBerman/repos",
 "events_url": "https://api.github.com/users/MosheBerman/events{/privacy}",
 "received_events_url": "https://api.github.com/users/MosheBerman/received_events",
 "type": "User"
 },
 "private": false,
 "html_url": "https://github.com/MosheBerman/MBTileParser",
 "description": "MBTileParser is a cocos2d-iphone compatible game engine written using pure UIKit.",
 "fork": false,
 "url": "https://api.github.com/repos/MosheBerman/MBTileParser",
 "forks_url": "https://api.github.com/repos/MosheBerman/MBTileParser/forks",
 "keys_url": "https://api.github.com/repos/MosheBerman/MBTileParser/keys{/key_id}",
 "collaborators_url": "https://api.github.com/repos/MosheBerman/MBTileParser/collaborators{/collaborator}",
 "teams_url": "https://api.github.com/repos/MosheBerman/MBTileParser/teams",
 "hooks_url": "https://api.github.com/repos/MosheBerman/MBTileParser/hooks",
 "issue_events_url": "https://api.github.com/repos/MosheBerman/MBTileParser/issues/events{/number}",
 "events_url": "https://api.github.com/repos/MosheBerman/MBTileParser/events",
 "assignees_url": "https://api.github.com/repos/MosheBerman/MBTileParser/assignees{/user}",
 "branches_url": "https://api.github.com/repos/MosheBerman/MBTileParser/branches{/branch}",
 "tags_url": "https://api.github.com/repos/MosheBerman/MBTileParser/tags",
 "blobs_url": "https://api.github.com/repos/MosheBerman/MBTileParser/git/blobs{/sha}",
 "git_tags_url": "https://api.github.com/repos/MosheBerman/MBTileParser/git/tags{/sha}",
 "git_refs_url": "https://api.github.com/repos/MosheBerman/MBTileParser/git/refs{/sha}",
 "trees_url": "https://api.github.com/repos/MosheBerman/MBTileParser/git/trees{/sha}",
 "statuses_url": "https://api.github.com/repos/MosheBerman/MBTileParser/statuses/{sha}",
 "languages_url": "https://api.github.com/repos/MosheBerman/MBTileParser/languages",
 "stargazers_url": "https://api.github.com/repos/MosheBerman/MBTileParser/stargazers",
 "contributors_url": "https://api.github.com/repos/MosheBerman/MBTileParser/contributors",
 "subscribers_url": "https://api.github.com/repos/MosheBerman/MBTileParser/subscribers",
 "subscription_url": "https://api.github.com/repos/MosheBerman/MBTileParser/subscription",
 "commits_url": "https://api.github.com/repos/MosheBerman/MBTileParser/commits{/sha}",
 "git_commits_url": "https://api.github.com/repos/MosheBerman/MBTileParser/git/commits{/sha}",
 "comments_url": "https://api.github.com/repos/MosheBerman/MBTileParser/comments{/number}",
 "issue_comment_url": "https://api.github.com/repos/MosheBerman/MBTileParser/issues/comments/{number}",
 "contents_url": "https://api.github.com/repos/MosheBerman/MBTileParser/contents/{+path}",
 "compare_url": "https://api.github.com/repos/MosheBerman/MBTileParser/compare/{base}...{head}",
 "merges_url": "https://api.github.com/repos/MosheBerman/MBTileParser/merges",
 "archive_url": "https://api.github.com/repos/MosheBerman/MBTileParser/{archive_format}{/ref}",
 "downloads_url": "https://api.github.com/repos/MosheBerman/MBTileParser/downloads",
 "issues_url": "https://api.github.com/repos/MosheBerman/MBTileParser/issues{/number}",
 "pulls_url": "https://api.github.com/repos/MosheBerman/MBTileParser/pulls{/number}",
 "milestones_url": "https://api.github.com/repos/MosheBerman/MBTileParser/milestones{/number}",
 "notifications_url": "https://api.github.com/repos/MosheBerman/MBTileParser/notifications{?since,all,participating}",
 "labels_url": "https://api.github.com/repos/MosheBerman/MBTileParser/labels{/name}",
 "created_at": "2012-08-03T08:52:52Z",
 "updated_at": "2013-05-01T21:15:46Z",
 "pushed_at": "2013-04-28T23:36:16Z",
 "git_url": "git://github.com/MosheBerman/MBTileParser.git",
 "ssh_url": "git@github.com:MosheBerman/MBTileParser.git",
 "clone_url": "https://github.com/MosheBerman/MBTileParser.git",
 "svn_url": "https://github.com/MosheBerman/MBTileParser",
 "homepage": "",
 "size": 296,
 "watchers_count": 23,
 "language": "Objective-C",
 "has_issues": true,
 "has_downloads": true,
 "has_wiki": true,
 "forks_count": 6,
 "mirror_url": null,
 "open_issues_count": 4,
 "forks": 6,
 "open_issues": 4,
 "watchers": 23,
 "master_branch": "master",
 "default_branch": "master"
 }
 
 */