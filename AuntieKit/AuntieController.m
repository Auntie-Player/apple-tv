//
//    The MIT License (MIT)
//
//    Copyright (c) 2015 Phillip Caudell & Matthew Cheetham
//
//    Permission is hereby granted, free of charge, to any person obtaining a copy
//    of this software and associated documentation files (the "Software"), to deal
//    in the Software without restriction, including without limitation the rights
//    to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//    copies of the Software, and to permit persons to whom the Software is
//    furnished to do so, subject to the following conditions:
//
//    The above copyright notice and this permission notice shall be included in
//    all copies or substantial portions of the Software.
//
//    THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//    IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//    FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//    AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//    LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//    OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//    THE SOFTWARE.
//

#import "AuntieController.h"
#import "Episode.h"
#import "EpisodeVersion.h"
#import "EpisodeCategory.h"
#import "Programme.h"
#import "Channel.h"

@import ThunderRequestTV;

@interface AuntieController ()

@property (nonatomic, strong) TSCRequestController *listingsRequestController;
@property (nonatomic, strong) TSCRequestController *episodeStreamRequestController;
@property (nonatomic, strong) TSCRequestController *searchRequestController;

@end

@implementation AuntieController

+ (AuntieController *)sharedController
{
    static AuntieController *sharedController;
    
    @synchronized(self) {
        if (sharedController == nil) {
            sharedController = [self new];
        }
    }
    
    return sharedController;
}

- (instancetype)init
{
    self = [super init];
    if (self) {
        
        self.listingsRequestController = [[TSCRequestController alloc] initWithBaseAddress:@"https://ibl.api.bbci.co.uk/ibl/v1/"];
        self.episodeStreamRequestController = [[TSCRequestController alloc] initWithBaseAddress:@"http://open.live.bbc.co.uk/mediaselector/5/select/version/2.0/format/json/mediaset/apple-iphone4-hls/vpid/"];
        self.searchRequestController = [[TSCRequestController alloc] initWithBaseAddress:@"http://search-suggest.api.bbci.co.uk/search-suggest/"];
        
    }
    return self;
}

- (void)getFeaturedProgrammesWithCompletion:(ContentCompletion)completion
{
    [self.listingsRequestController get:@"home/highlights" withURLParamDictionary:nil completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSArray *episodesArray = response.dictionary[@"home_highlights"][@"elements"];
        
        NSMutableArray *episodes = [NSMutableArray array];
        for (NSDictionary *episodeItem in episodesArray) {
            
            if ([episodeItem[@"type"] isEqualToString:@"group_large"]) {
                
                NSArray *children = episodeItem[@"initial_children"];
                
                for (NSDictionary *childEpisodeDictionary in children) {
                    
                    Episode *episodeObject = [[Episode alloc] initWithDictionary:childEpisodeDictionary];
                    
                    if (episodeObject.subtitle) {
                        [episodes addObject:episodeObject];
                    }
                    
                }
                
            } else {
                
                Episode *episodeObject = [[Episode alloc] initWithDictionary:episodeItem];
                
                if (episodeObject.subtitle) {
                    [episodes addObject:episodeObject];
                }
                
            }
            
        }
        
        if (completion) {
            completion(episodes, nil);
        }
    }];
}

//- (void)getRelatedEpisodesForEpisode:(Episode *)episode completion:(ContentCompletion)completion
//{
//    
//}
//
- (void)getStreamURLForChannel:(Channel *)channel completion:(ContentURLCompletion)completion
{
    [self.episodeStreamRequestController get:@"(:channelID)/proto/http/" withURLParamDictionary:@{@"channelID":channel.identifier} completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            completion(nil, error);
            return;
        }
        
        NSArray *mediaObjects = response.dictionary[@"media"];
        
        NSString *bestQualityStreamString;
        NSInteger topBitrate = 0;
        
        for (NSDictionary *singleStream in mediaObjects) {
            
            if ([singleStream[@"bitrate"] integerValue] > topBitrate) {
                
                topBitrate = [singleStream[@"bitrate"] integerValue];
                
                NSArray *connectionObjects = singleStream[@"connection"];
                NSDictionary *streamObject = connectionObjects.firstObject;
                bestQualityStreamString = streamObject[@"href"];
                
            }
            
        }
        
        completion([NSURL URLWithString:bestQualityStreamString], nil);
        
    }];
}

- (void)getStreamURLForVersion:(EpisodeVersion *)version completion:(ContentURLCompletion)completion
{
    [self.episodeStreamRequestController get:@"(:episodeID)/proto/http/" withURLParamDictionary:@{@"episodeID":version.identifier} completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            completion(nil, error);
            return;
        }
        
        NSArray *mediaObjects = response.dictionary[@"media"];
    
        NSString *bestQualityStreamString;
        NSInteger topBitrate = 0;
        
        for (NSDictionary *singleStream in mediaObjects) {
            
            if ([singleStream[@"bitrate"] integerValue] > topBitrate) {
                
                topBitrate = [singleStream[@"bitrate"] integerValue];
                
                NSArray *connectionObjects = singleStream[@"connection"];
                NSDictionary *streamObject = connectionObjects.firstObject;
                bestQualityStreamString = streamObject[@"href"];
                
            }
            
        }
        
        completion([NSURL URLWithString:bestQualityStreamString], nil);
        
    }];
}

- (void)getCategoriesWithCompletion:(ContentCompletion)completion
{
    [self.listingsRequestController get:@"categories" completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error) {
            
            completion(nil, error);
            return;
            
        }
        
        NSMutableArray *categoriesArray = [NSMutableArray array];
        
        for (NSDictionary *categoryDictionary in response.dictionary[@"categories"]) {
            
            EpisodeCategory *newCategory = [[EpisodeCategory alloc] initWithDictionary:categoryDictionary];
            [categoriesArray addObject:newCategory];
            
        }
        
        completion(categoriesArray, nil);
        
    }];
}

- (void)getChannelsWithCompletion:(ContentCompletion)completion
{
    [self.listingsRequestController get:@"channels" completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            
            completion(nil, error);
            return;
            
        }
        
        NSMutableArray *channelsArray = [NSMutableArray array];
        
        for (NSDictionary *channelDictionary in response.dictionary[@"channels"]) {
            
            Channel *newChannel = [[Channel alloc] initWithDictionary:channelDictionary];
            [channelsArray addObject:newChannel];
            
        }
        
        completion(channelsArray, nil);
        
    }];
}

- (void)getEpisodesForCategory:(EpisodeCategory *)category completion:(ContentCompletion)completion
{
    [self.listingsRequestController get:@"categories/(:categoryIdentifier)/highlights" withURLParamDictionary:@{@"categoryIdentifier":category.identifier} completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSMutableArray *episodesArray = [NSMutableArray array];
        
        for (NSDictionary *episodeDictionary in response.dictionary[@"category_highlights"][@"elements"]) {
            
            Episode *newEpisode = [[Episode alloc] initWithDictionary:episodeDictionary];
            [episodesArray addObject:newEpisode];
            
        }
        
        completion(episodesArray, nil);
        
    }];
}

- (void)getEpisodesForSearchTerm:(NSString *)searchTerm completion:(ContentCompletion)completion
{
    [self.searchRequestController get:@"suggest?q=(:searchTerm)&scope=iplayer&format=bigscreen-2&mediatype=video&mediaset=apple-iphone4-hls&apikey=x5pfeqccnm6j52mp9c298qdm" withURLParamDictionary:@{@"searchTerm":searchTerm} completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
       
        if (error || !response.array || response.array.count < 1) {
            
            completion(nil, error);
            return;
            
        }
        
        NSArray *resultArray = response.array[1];
        NSMutableArray *programmeIdentifiers = [NSMutableArray array];
        
        for (NSDictionary *searchResultDictionary in resultArray) {
            
            NSArray *tleoArray = searchResultDictionary[@"tleo"];
            NSDictionary *tleoObject = tleoArray.firstObject;
            [programmeIdentifiers addObject:tleoObject[@"pid"]];
            
        }
        
        [self.listingsRequestController get:@"programmes/(:showIdentifiers)?availability=available&initial_child_count=1&lang=en&rights=mobile&api_key=x5pfeqccnm6j52mp9c298qdm" withURLParamDictionary:@{@"showIdentifiers": [programmeIdentifiers componentsJoinedByString:@","]} completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
           
            if (error) {
                
                completion(nil, error);
                return;
                
            }
            
            NSArray *availableProgrammesArray = response.dictionary[@"programmes"];
            
            NSMutableArray *programmeArray = [NSMutableArray array];
            
            for (NSDictionary *episodeDictionary in availableProgrammesArray) {
                
                if ([episodeDictionary[@"tleo_type"] isEqualToString:@"episode"]) {
                    
                    Episode *episodeObject = [[Episode alloc] initWithDictionary:episodeDictionary];
                    [programmeArray addObject:episodeObject];
                    
                } else {
                    Programme *newEpisode = [[Programme alloc] initWithDictionary:episodeDictionary];
                    [programmeArray addObject:newEpisode];
                }
                
            }
            
            completion(programmeArray, nil);
            
        }];
    }];
}

- (void)getEpisodesForProgramme:(Programme *)programme completion:(ContentCompletion)completion
{
    [self.listingsRequestController get:@"programmes/(:programmeIdentifier)/episodes?lang=en&rights=mobile&page=1&per_page=200&availability=available&api_key=x5pfeqccnm6j52mp9c298qdm" withURLParamDictionary:@{@"programmeIdentifier":programme.identifier} completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSArray *episodesArray = response.dictionary[@"programme_episodes"][@"elements"];
        
        NSMutableArray *episodes = [NSMutableArray array];
        for (NSDictionary *episodeItem in episodesArray) {
            
            Episode *episodeObject = [[Episode alloc] initWithDictionary:episodeItem];
            
            if (episodeObject.subtitle) {
                [episodes addObject:episodeObject];
            }
            
        }
        
        if (completion) {
            completion(episodes, nil);
        }
    }];
    
}

- (void)getRelatedEpisodesForEpisode:(Episode *)episode completion:(ContentCompletion)completion
{
    [self.listingsRequestController get:@"episodes/(:episodeIdentifier)/recommendations?lang=en&rights=mobile&page=1&per_page=200&availability=available&api_key=x5pfeqccnm6j52mp9c298qdm" withURLParamDictionary:@{@"episodeIdentifier":episode.identifier} completion:^(TSCRequestResponse * _Nullable response, NSError * _Nullable error) {
        
        if (error) {
            completion(nil, error);
            return;
        }
        
        NSArray *episodesArray = response.dictionary[@"episode_recommendations"][@"elements"];
        
        NSMutableArray *episodes = [NSMutableArray array];
        for (NSDictionary *episodeItem in episodesArray) {
            
            Episode *episodeObject = [[Episode alloc] initWithDictionary:episodeItem];
            
            if (episodeObject.subtitle) {
                [episodes addObject:episodeObject];
            }
            
        }
        
        if (completion) {
            completion(episodes, nil);
        }
        
    }];
}

//- (void)getChannelsWithCompletion:(ContentCompletion)completion
//{
//    
//}
//
//- (void)getEpisodesForProgramme:(ContentCompletion)completion
//{
//    
//}

@end
