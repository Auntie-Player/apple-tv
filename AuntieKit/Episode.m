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

#import "Episode.h"
#import "NSDate+Tools.h"
#import "EpisodeVersion.h"

@implementation Episode

- (instancetype)initWithDictionary:(NSDictionary *)dictionary
{
    self = [super init];
    if (self) {
        
        if ([dictionary isKindOfClass:[NSDictionary class]]) {
            
            if (dictionary[@"id"] && [dictionary[@"id"] isKindOfClass:[NSString class]]) {
                
                self.identifier = dictionary[@"id"];
                
            }
            
            if (dictionary[@"title"] && [dictionary[@"title"] isKindOfClass:[NSString class]]) {
                
                self.title = dictionary[@"title"];
                
            }
            
            if (dictionary[@"subtitle"] && [dictionary[@"subtitle"] isKindOfClass:[NSString class]]) {
                
                self.subtitle = dictionary[@"subtitle"];
                
            }
            
            if (dictionary[@"images"] && [dictionary[@"images"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *imageDictionary = dictionary[@"images"];
                
                if (imageDictionary[@"standard"] && [imageDictionary[@"standard"] isKindOfClass:[NSString class]]) {
                    
                    NSString *urlString = [imageDictionary[@"standard"] stringByReplacingOccurrencesOfString:@"{recipe}" withString:@"1344x756"];
                    self.thumbnailURL = [NSURL URLWithString:urlString];
                    
                }
                
            }
            
            if (dictionary[@"synopses"] && [dictionary[@"synopses"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *synopsesDictionary = dictionary[@"synopses"];
                
                if (synopsesDictionary[@"small"] && [synopsesDictionary[@"small"] isKindOfClass:[NSString class]]) {
                    
                    self.shortDescription = synopsesDictionary[@"small"];
                    
                }
                
            }
            
            if (dictionary[@"synopses"] && [dictionary[@"synopses"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *synopsesDictionary = dictionary[@"synopses"];
                
                if (synopsesDictionary[@"medium"] && [synopsesDictionary[@"medium"] isKindOfClass:[NSString class]]) {
                    
                    self.mediumDescription = synopsesDictionary[@"medium"];
                    
                }
                
            }
            
            if (dictionary[@"synopses"] && [dictionary[@"synopses"] isKindOfClass:[NSDictionary class]]) {
                
                NSDictionary *synopsesDictionary = dictionary[@"synopses"];
                
                if (synopsesDictionary[@"large"] && [synopsesDictionary[@"large"] isKindOfClass:[NSString class]]) {
                    
                    self.longDescription = synopsesDictionary[@"large"];
                    
                }
                
            }
            
            if (dictionary[@"release_date_time"] && [dictionary[@"release_date_time"] isKindOfClass:[NSString class]]) {
                
                self.releaseDate = [NSDate dateWithISO86SomethingString:dictionary[@"release_date_time"]];
                
            }
            
            if (dictionary[@"versions"] && [dictionary[@"versions"] isKindOfClass:[NSArray class]]) {
                
                NSMutableArray *versionArray = [NSMutableArray array];
                
                for (NSDictionary *versionDictionary in dictionary[@"versions"]) {
                    
                    EpisodeVersion *aVersion = [[EpisodeVersion alloc] initWithDictionary:versionDictionary];
                    [versionArray addObject:aVersion];
                    
                }
                
                self.versions = versionArray;
                
            }
            
            if (dictionary[@"initial_children"] && [dictionary[@"initial_children"] isKindOfClass:[NSArray class]]) {
                
                NSArray *children = dictionary[@"initial_children"];
                NSDictionary *episodeInfo = children.firstObject;
                
                if (episodeInfo) {
                    
                    NSMutableArray *versionArray = [NSMutableArray array];
                    
                    for (NSDictionary *versionDictionary in episodeInfo[@"versions"]) {
                        
                        EpisodeVersion *aVersion = [[EpisodeVersion alloc] initWithDictionary:versionDictionary];
                        [versionArray addObject:aVersion];
                        
                    }
                    
                    self.versions = versionArray;
                    
                }
                
            }
            
            
        }

        
    }
    return self;
}

- (EpisodeVersion *)originalVersion
{
    for (EpisodeVersion *version in self.versions) {
        
        if ([version.kind isEqualToString:@"original"]) {
            
            return version;
            
        }
        
    }
    
    for (EpisodeVersion *version in self.versions) {
        
        if ([version.kind isEqualToString:@"editorial"]) {
            
            return version;
            
        }
        
    }
    
    for (EpisodeVersion *version in self.versions) {
        
        if ([version.kind isEqualToString:@"iplayer-version"]) {
            
            return version;
            
        }
        
    }
    
    return nil;
}

- (EpisodeVersion *)audioDescribedVersion
{
    for (EpisodeVersion *version in self.versions) {
        
        if ([version.kind isEqualToString:@"audio-described"]) {
            
            return version;
            
        }
        
    }
    
    return nil;
}

- (EpisodeVersion *)signedVersion
{
    for (EpisodeVersion *version in self.versions) {
        
        if ([version.kind isEqualToString:@"signed"]) {
            
            return version;
            
        }
        
    }
    
    return nil;
}

@end
