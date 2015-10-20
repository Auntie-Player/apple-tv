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

#import "EpisodeDetailViewController.h"
#import "UIColor+Auntie.h"
#import "PCGroupView.h"
#import "Programme.h"

@import AuntieKit;
@import AVKit;
@import AVFoundation;

@interface EpisodeDetailViewController ()

@property (nonatomic, strong) PCGroupView *groupView;
@property (nonatomic, strong) PCGroupView *buttonsView;

@end

@implementation EpisodeDetailViewController

- (instancetype)initWithEpisode:(Episode *)episode
{
    if (self = [super init]) {
        
        _episode = episode;
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];

    self.backgroundImageView = [AsyncImageView new];
    [self.view addSubview:self.backgroundImageView];

    self.backgroundVisualEffectView = [[UIVisualEffectView alloc] initWithEffect:[UIBlurEffect effectWithStyle:UIBlurEffectStyleDark]];
    [self.view addSubview:self.backgroundVisualEffectView];
    [self.backgroundImageView setImageURL:self.episode.thumbnailURL];
    
    self.titleLabel = [UILabel new];
    self.titleLabel.text = self.episode.title;
    self.titleLabel.font = [UIFont boldSystemFontOfSize:64];
    self.titleLabel.textColor = [UIColor whiteColor];

    self.subtitleLabel = [UILabel new];
    self.subtitleLabel.text = self.episode.subtitle;
    self.subtitleLabel.font = [UIFont systemFontOfSize:48];
    self.subtitleLabel.textColor = [UIColor whiteColor];

    self.infoLabel = [UILabel new];
    self.infoLabel.text = self.episode.originalVersion.duration;
    self.infoLabel.font = [UIFont boldSystemFontOfSize:34];
    self.infoLabel.textColor = [UIColor auntiePinkColor];
    
//    self.descriptionButton = [UIButton buttonWithType:UIButtonTypeSystem];
//    [self.descriptionButton setTitle:self.episode.mediumDescription forState:UIControlStateNormal];
//    self.descriptionButton.titleLabel.numberOfLines = 0;
//    [self.descriptionButton addTarget:self action:@selector(handleDescription:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    self.descriptionLabel = [UILabel new];
    self.descriptionLabel.text = self.episode.mediumDescription;
    self.descriptionLabel.font = [UIFont systemFontOfSize:34];
    self.descriptionLabel.textColor = [UIColor whiteColor];
    self.descriptionLabel.numberOfLines = 0;
    
    self.playButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.playButton setTitle:@"Play" forState:UIControlStateNormal];
    [self.playButton addTarget:self action:@selector(handlePlay:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    self.audioDescribedButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.audioDescribedButton setTitle:@"AD" forState:UIControlStateNormal];
    [self.audioDescribedButton addTarget:self action:@selector(handlePlay:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    self.signedButton = [UIButton buttonWithType:UIButtonTypeSystem];
    [self.signedButton setTitle:@"SL" forState:UIControlStateNormal];
    [self.signedButton addTarget:self action:@selector(handlePlay:) forControlEvents:UIControlEventPrimaryActionTriggered];
    
    self.relatedEpisodeView = [[EpisodeCollectionView alloc] init];
    self.relatedEpisodeView.numberOfEpisodesPerRow = 4;
    self.relatedEpisodeView.collectionLayout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    self.relatedEpisodeView.delegate = self;
//    self.relatedEpisodeView.backgroundColor = [UIColor colorWithWhite:0 alpha:0.3];
    [self.view addSubview:self.relatedEpisodeView];
    
    if ([self.episode isMemberOfClass:[Episode class]]) {
        [[AuntieController sharedController] getRelatedEpisodesForEpisode:self.episode completion:^(NSArray *content, NSError *error) {
        
        self.relatedEpisodeView.episodes = content;
        }];
    }

    if ([self.episode isMemberOfClass:[Programme class]]) {
        
        [[AuntieController sharedController] getEpisodesForProgramme:self.episode completion:^(NSArray *content, NSError *error) {
            
            self.relatedEpisodeView.episodes = content;
        }];
        
    }
    
    NSMutableArray *availableButtons = [NSMutableArray array];
    if (self.episode.originalVersion) {
        [availableButtons addObject:self.playButton];
    }
    
    if (self.episode.audioDescribedVersion) {
        [availableButtons addObject:self.audioDescribedButton];
    }
    
    if (self.episode.signedVersion) {
        [availableButtons addObject:self.signedButton];
    }
    
    self.buttonsView = [PCGroupView groupWithViews:availableButtons];
    self.buttonsView.direction = PCGroupViewDirectionHorizontal;
    self.buttonsView.viewInsets = UIEdgeInsetsMake(0, 30, 0, 0);
    [self.view addSubview:self.buttonsView];
    
    self.groupView = [PCGroupView groupWithViews:@[self.titleLabel, self.subtitleLabel, self.infoLabel, self.descriptionLabel, self.buttonsView]];
    self.groupView.direction = PCGroupViewDirectionVertical;
    self.groupView.viewInsets = UIEdgeInsetsMake(0, 0, 20, 0);
    [self.view addSubview:self.groupView];
    
    self.thumbnailImageView = [AsyncImageView new];
    [self.thumbnailImageView setImageURL:self.episode.thumbnailURL];
    [self.view addSubview:self.thumbnailImageView];
    
    [self.playButton becomeFirstResponder];
}

- (void)viewWillLayoutSubviews
{
    [super viewWillLayoutSubviews];
    
    self.backgroundImageView.frame = self.view.bounds;
    self.backgroundVisualEffectView.frame = self.view.bounds;
    
    CGFloat thumbnailWidth = 700;
    self.thumbnailImageView.frame = CGRectMake(0, 0, thumbnailWidth, thumbnailWidth / 16*9);
    
    [self.thumbnailImageView positionInSuperviewX:PCGroupViewPositionRight y:PCGroupViewPositionTop offset:UIEdgeInsetsMake(100, 0, 0, 100)];
    
    self.buttonsView.constraintSize = CGSizeMake(800, MAXFLOAT);
    [self.buttonsView sizeToFit];
    [self.buttonsView positionInSuperviewX:PCGroupViewPositionLeft y:PCGroupViewPositionTop offset:UIEdgeInsetsMake(0, 0, 0, 0)];
    
    self.groupView.constraintSize = CGSizeMake(800, MAXFLOAT);
    [self.groupView sizeToFit];
    [self.groupView positionInSuperviewX:PCGroupViewPositionLeft y:PCGroupViewPositionTop offset:UIEdgeInsetsMake(50, 80, 0, 0)];

    
    self.relatedEpisodeView.frame = CGRectMake(0, self.view.bounds.size.height - 400, self.view.bounds.size.width, 400);
}

#pragma mark - Actions

- (void)handlePlay:(id)sender
{
    EpisodeVersion *selectedVersion;
    if (sender == self.playButton) {
        
        selectedVersion = self.episode.originalVersion;
        
    } else if (sender == self.audioDescribedButton) {
        
        selectedVersion = self.episode.audioDescribedVersion;
        
    } else if (sender == self.signedButton) {
        
        selectedVersion = self.episode.signedVersion;
        
    }
    AVPlayerViewController *viewController = [[AVPlayerViewController alloc] init];
    viewController.modalTransitionStyle = UIModalTransitionStyleCrossDissolve;
    [self presentViewController:viewController animated:YES completion:nil];
    
    [[AuntieController sharedController] getStreamURLForVersion:selectedVersion completion:^(NSURL *episodeURL, NSError *error) {
        
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
}

- (void)handleDescription:(id)sender
{
    UIAlertController *alertController = [UIAlertController alertControllerWithTitle:self.episode.title message:self.episode.longDescription preferredStyle:UIAlertControllerStyleAlert];
    [alertController addAction:[UIAlertAction actionWithTitle:@"Done" style:UIAlertActionStyleCancel handler:nil]];
    [self presentViewController:alertController animated:YES completion:nil];
}

- (void)episodeCollectionView:(EpisodeCollectionView *)view didSelectedEpsiode:(Episode *)episode
{
    EpisodeDetailViewController *viewController = [[EpisodeDetailViewController alloc] initWithEpisode:episode];
    [self presentViewController:viewController animated:YES completion:nil];
}


@end
