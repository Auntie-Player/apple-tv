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

#import "EpisodeCollectionView.h"
#import "EpisodeCollectionViewCell.h"

@import AuntieKit;

@interface EpisodeCollectionView () <UICollectionViewDataSource, UICollectionViewDelegate, UICollectionViewDelegateFlowLayout>

@end

@implementation EpisodeCollectionView

- (instancetype)init
{
    if (self = [super init]) {
        
        self.collectionLayout = [[UICollectionViewFlowLayout alloc] init];
        
        self.collectionView = [[UICollectionView alloc] initWithFrame:CGRectZero collectionViewLayout:self.collectionLayout];
        self.collectionView.delegate = self;
        self.collectionView.dataSource = self;
        [self.collectionView registerClass:[EpisodeCollectionViewCell class] forCellWithReuseIdentifier:@"Cell"];
        
        [self addSubview:self.collectionView];
        
        self.numberOfEpisodesPerRow = 3;
    }
    
    return self;
}

- (void)layoutSubviews
{
    [super layoutSubviews];
    
    self.collectionView.frame = self.bounds;
}

- (void)setEpisodes:(NSArray *)episodes
{
    [super willChangeValueForKey:@"episodes"];
    _episodes = episodes;

    [UIView animateWithDuration:0.5 animations:^{
        
        self.collectionView.alpha = 0.0;
        
    } completion:^(BOOL finished) {
       
        [self.collectionView reloadData];
        self.collectionView.contentOffset = CGPointZero;
        // HACK: For some reason calling animateCellsIn immediatly after reload doesn't return visiblecells
        [self performSelector:@selector(animateCellsIn) withObject:nil afterDelay:0.000001];
        
    }];
    
    [self didChangeValueForKey:@"episodes"];
}

#pragma mark - Collection view delegate

- (NSInteger)numberOfSectionsInCollectionView:(UICollectionView *)collectionView
{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section
{
    return self.episodes.count;
}

- (UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath
{
    Episode *episode = self.episodes[indexPath.row];
    EpisodeCollectionViewCell *cell = [collectionView dequeueReusableCellWithReuseIdentifier:@"Cell" forIndexPath:indexPath];
    
    cell.textLabel.text = episode.title;
    cell.detailLabel.text = episode.subtitle;
    cell.imageView.image = [UIImage imageNamed:@"episode-thumbnail-placeholder"];
    [cell.imageView setImageURL:episode.thumbnailURL];
    
    return cell;
}

#pragma mark - Collection view flow layout

- (CGSize)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout sizeForItemAtIndexPath:(NSIndexPath *)indexPath
{
    CGFloat width = self.bounds.size.width / self.numberOfEpisodesPerRow;
    CGFloat height = width / 16 * 9;
    
    return CGSizeMake(width, height);
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumInteritemSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (CGFloat)collectionView:(UICollectionView *)collectionView layout:(UICollectionViewLayout *)collectionViewLayout minimumLineSpacingForSectionAtIndex:(NSInteger)section
{
    return 0;
}

- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath
{
    Episode *episode = self.episodes[indexPath.row];
    
    if ([self.delegate respondsToSelector:@selector(episodeCollectionView:didSelectedEpsiode:)]) {
        [self.delegate episodeCollectionView:self didSelectedEpsiode:episode];
    }
}

- (void)animateCellsIn
{
    NSSortDescriptor *sortDescriptor = [NSSortDescriptor sortDescriptorWithKey:@"layer.position.y" ascending:YES];
    NSArray *orderedCells = [self.collectionView.visibleCells sortedArrayUsingDescriptors:@[sortDescriptor]];
    
    // Hide all cells
    [orderedCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        obj.alpha = 0.0;
        obj.transform = CGAffineTransformMakeTranslation(0, 100);
    }];
    
    self.collectionView.alpha = 1.0;
    
    /// ...and like S Club 7, bring it all back...
    [orderedCells enumerateObjectsUsingBlock:^(__kindof UICollectionViewCell * _Nonnull obj, NSUInteger idx, BOOL * _Nonnull stop) {
        
        [UIView animateWithDuration:0.8 delay:0.05 * idx usingSpringWithDamping:0.8 initialSpringVelocity:0.5 options:kNilOptions animations:^{
            
            obj.alpha = 1.0;
            obj.transform = CGAffineTransformMakeTranslation(0, 0);
            
        } completion:nil];
    }];
}


@end
