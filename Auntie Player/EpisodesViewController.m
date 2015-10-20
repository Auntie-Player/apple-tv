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

#import "EpisodesViewController.h"
#import "EpisodeDetailViewController.h"
@import AuntieKit;

@interface EpisodesViewController ()

@end

@implementation EpisodesViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        self.title = @"Episodes";
        self.collectionView = [[EpisodeCollectionView alloc] init];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.collectionView.delegate = self;
    [self.view addSubview:self.collectionView];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.collectionView.frame = self.view.bounds;
}

- (void)episodeCollectionView:(EpisodeCollectionView *)view didSelectedEpsiode:(Episode *)episode
{
    if ([episode isMemberOfClass:[Channel class]]) {
        
        [self playChannel:(Channel *)episode];
        
    } else {
        
        EpisodeDetailViewController *viewController = [[EpisodeDetailViewController alloc] initWithEpisode:episode];
        [self presentViewController:viewController animated:YES completion:nil];
        
    }
}

- (void)playChannel:(Channel *)channel
{
    
    UIAlertController *licensingAlert = [UIAlertController alertControllerWithTitle:@"TV Licensing" message:@"Don't forget, to watch live TV online as it's being broadcast, you still need to be covered by a TV Licence" preferredStyle:UIAlertControllerStyleAlert];
    [licensingAlert addAction:[UIAlertAction actionWithTitle:@"Watch Now" style:UIAlertActionStyleDefault handler:^(UIAlertAction * _Nonnull action) {
        
        AVPlayerViewController *viewController = [[AVPlayerViewController alloc] init];
        viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
        [self presentViewController:viewController animated:YES completion:nil];
        
        [[AuntieController sharedController] getStreamURLForChannel:channel completion:^(NSURL *episodeURL, NSError *error) {
            
            if (error) {
                
                [viewController dismissViewControllerAnimated:YES completion:nil];
                
                UIAlertController *alertController = [UIAlertController alertControllerWithTitle:@"Unable to start video playback." message:error.localizedDescription preferredStyle:UIAlertControllerStyleAlert];
                [alertController addAction:[UIAlertAction actionWithTitle:@"Dismiss" style:UIAlertActionStyleCancel handler:nil]];
                [self presentViewController:alertController animated:YES completion:nil];
            }
            
            AVPlayer *player = [[AVPlayer alloc] initWithURL:episodeURL];
            player.closedCaptionDisplayEnabled = true;
            
            viewController.player = player;
            [viewController.player play];
        }];
        
    }]];
    
    [licensingAlert addAction:[UIAlertAction actionWithTitle:@"Cancel" style:UIAlertActionStyleCancel handler:nil]];
    
    [self presentViewController:licensingAlert animated:true completion:nil];


}

@end
