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

#import "AppDelegate.h"
#import "EpisodesViewController.h"
#import "CategoriesViewController.h"
#import "FeaturedEpisodesViewController.h"
#import "SearchEpisodesViewController.h"
#import "UIColor+Auntie.h"
#import "LiveChannelsViewController.h"

@import AuntieKit;

@interface AppDelegate ()

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions
{
    FeaturedEpisodesViewController *featuredViewController = [FeaturedEpisodesViewController new];

    CategoriesViewController *categoriesViewController = [CategoriesViewController new];
    SearchEpisodesViewController *searchViewController = [SearchEpisodesViewController new];
    LiveChannelsViewController *channelsViewController = [LiveChannelsViewController new];
    
    //Create Search controller
    UISearchController *searchController = [[UISearchController alloc] initWithSearchResultsController:searchViewController];
    searchController.searchResultsUpdater = searchViewController;
    searchController.hidesNavigationBarDuringPresentation = true;
    searchController.title = @"Search";
    searchController.searchBar.placeholder = @"Programme Name";
    searchController.view.backgroundColor = [UIColor auntieDarkGrayColor];
    searchController.searchBar.keyboardAppearance = UIKeyboardAppearanceDark;
    
    //Create container to embed in tab bar
    UISearchContainerViewController *searchContainerViewController = [[UISearchContainerViewController alloc] initWithSearchController:searchController];
    [searchContainerViewController setTitle:@"Search"];
    searchContainerViewController.view.backgroundColor = [UIColor auntieDarkGrayColor];
    
    //Create tab bar to put in navigation bar to embed view successfully
    UINavigationController *searchNavController = [[UINavigationController alloc] initWithRootViewController:searchContainerViewController];
    
    //Setup Tab Bar
    UITabBarController *tabBarController = [[UITabBarController alloc] init];
    tabBarController.viewControllers = @[featuredViewController, categoriesViewController, channelsViewController, searchNavController];

    UITabBar *tabBar = [UITabBar appearance];
    tabBar.barTintColor = [UIColor blackColor];
    
    UITabBarItem *tabBarItem = [UITabBarItem appearance];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor whiteColor]} forState:UIControlStateNormal];
    [tabBarItem setTitleTextAttributes:@{NSForegroundColorAttributeName: [UIColor auntiePinkColor]} forState:UIControlStateSelected];

    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.rootViewController = tabBarController;
    [self.window makeKeyAndVisible];
    
    return YES;
}

- (void)applicationWillResignActive:(UIApplication *)application {
    // Sent when the application is about to move from active to inactive state. This can occur for certain types of temporary interruptions (such as an incoming phone call or SMS message) or when the user quits the application and it begins the transition to the background state.
    // Use this method to pause ongoing tasks, disable timers, and throttle down OpenGL ES frame rates. Games should use this method to pause the game.
}

- (void)applicationDidEnterBackground:(UIApplication *)application {
    // Use this method to release shared resources, save user data, invalidate timers, and store enough application state information to restore your application to its current state in case it is terminated later.
    // If your application supports background execution, this method is called instead of applicationWillTerminate: when the user quits.
}

- (void)applicationWillEnterForeground:(UIApplication *)application {
    // Called as part of the transition from the background to the inactive state; here you can undo many of the changes made on entering the background.
}

- (void)applicationDidBecomeActive:(UIApplication *)application {
    // Restart any tasks that were paused (or not yet started) while the application was inactive. If the application was previously in the background, optionally refresh the user interface.
}

- (void)applicationWillTerminate:(UIApplication *)application {
    // Called when the application is about to terminate. Save data if appropriate. See also applicationDidEnterBackground:.
}

@end
