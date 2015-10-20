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

#import "CategoriesViewController.h"
#import "CategoriesTableViewController.h"
#import "CategoryEpisodesViewController.h"

#import "UIColor+Auntie.h"

@interface CategoriesViewController () <CategoriesTableViewControllerDelegate>

@property (nonatomic, strong) CategoriesTableViewController *categoriesTableViewController;
@property (nonatomic, strong) CategoryEpisodesViewController *episodesViewController;

@end

@implementation CategoriesViewController

- (instancetype)init
{
    if (self = [super init]) {
        
        self.title = @"Categories";
        
        self.episodesViewController = [CategoryEpisodesViewController new];
        self.episodesViewController.collectionView.numberOfEpisodesPerRow = 2;
        
        self.categoriesTableViewController = [CategoriesTableViewController new];
        self.categoriesTableViewController.delegate = self;
        
        self.viewControllers = @[self.categoriesTableViewController, self.episodesViewController];
    }
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    self.view.backgroundColor = [UIColor auntieDarkGrayColor];
}

- (void)categoriesTableViewController:(CategoriesTableViewController *)controller didSelectCategory:(EpisodeCategory *)category
{
    [self.episodesViewController refreshWithEpisodeCategory:category];
}

@end
