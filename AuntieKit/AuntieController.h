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

#import <Foundation/Foundation.h>

@class Episode;
@class EpisodeCategory;
@class Programme;
@class EpisodeVersion;
@class Channel;

@interface AuntieController : NSObject

+ (AuntieController *)sharedController;

typedef void (^ContentCompletion)(NSArray *content, NSError *error);
typedef void (^ContentURLCompletion)(NSURL *episodeURL, NSError *Error);

- (void)getFeaturedProgrammesWithCompletion:(ContentCompletion)completion;

- (void)getRelatedEpisodesForEpisode:(Episode *)episode completion:(ContentCompletion)completion;

- (void)getStreamURLForVersion:(EpisodeVersion *)version completion:(ContentURLCompletion)completion;

- (void)getStreamURLForChannel:(Channel *)channel completion:(ContentURLCompletion)completion;

- (void)getEpisodesForCategory:(EpisodeCategory *)category completion:(ContentCompletion)completion;

//
- (void)getCategoriesWithCompletion:(ContentCompletion)completion;
- (void)getChannelsWithCompletion:(ContentCompletion)completion;

- (void)getEpisodesForSearchTerm:(NSString *)searchTerm completion:(ContentCompletion)completion;

//
//- (void)episodesForCategory:(EpisodeCategory)category completion:(ContentCompletion)completion;
//
//- (void)getChannelsWithCompletion:(ContentCompletion)completion;
//
- (void)getEpisodesForProgramme:(Programme *)programme completion:(ContentCompletion)completion;

@end
