//
//  AuntieSearchContainerViewController.m
//  Auntie Player
//
//  Created by Phillip Caudell on 17/10/2015.
//  Copyright © 2015 Matt & Phill Collaboration. All rights reserved.
//

#import "AuntieSearchContainerViewController.h"

@interface AuntieSearchContainerViewController ()

@end

@implementation AuntieSearchContainerViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view.
    

    [self recurse:self.searchController.search];
    

}

- (void)recurse:(NSArray *)views
{
    NSLog(@"VIEWS: %@", views);
    for (UIView *v in views) {
        
        if ([v respondsToSelector:@selector(tintColor)]) {
            v.tintColor = [UIColor redColor];
            
            if ([v isKindOfClass:[UIImageView class]]) {
                UIImageView *imageView = v;
                
                imageView.image = [imageView.image imageWithRenderingMode:UIImageRenderingModeAlwaysTemplate];
            }
        }
        
        [self recurse:v.subviews];
    }
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

/*
#pragma mark - Navigation

// In a storyboard-based application, you will often want to do a little preparation before navigation
- (void)prepareForSegue:(UIStoryboardSegue *)segue sender:(id)sender {
    // Get the new view controller using [segue destinationViewController].
    // Pass the selected object to the new view controller.
}
*/

@end
