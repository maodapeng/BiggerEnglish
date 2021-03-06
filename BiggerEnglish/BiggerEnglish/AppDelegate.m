//
//  AppDelegate.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/12.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//

#import "AppDelegate.h"
#import "WordBookModel.h"
#import "WordModel.h"
#import "HistoryWordBookModel.h"

@interface AppDelegate () <UISplitViewControllerDelegate>

@end

@implementation AppDelegate


- (BOOL)application:(UIApplication *)application didFinishLaunchingWithOptions:(NSDictionary *)launchOptions {
 
    self.window = [[UIWindow alloc] initWithFrame:[[UIScreen mainScreen] bounds]];
    self.window.backgroundColor = [UIColor grayColor];
    self.rootViewController = [[BERootViewController alloc] init];
    UINavigationController *navigation = [[UINavigationController alloc] initWithRootViewController:self.rootViewController];
    navigation.navigationBarHidden = YES;
    self.window.rootViewController = navigation;
    [self.window makeKeyAndVisible];
 
    [self initAppearance];
    
    if ([self isFirstStart]) {
        NSLog(@"first start");
        [self initDefaultWordBook];
    } else {
        NSLog(@"not first start");
    }
    
    return YES;
}

- (BOOL)isFirstStart {
    NSUserDefaults * settings = [NSUserDefaults standardUserDefaults];
    NSString * str = [settings stringForKey:@"isFirstStart"];
    if ([str isEqualToString:@"Start"]) {
        return FALSE;
    }
    else //first
    {
        [settings setObject:@"Start" forKey:@"isFirstStart"];
        [[NSUserDefaults standardUserDefaults] synchronize];
        return YES;
    }
}

- (void)initDefaultWordBook {
    WordBookModel *wordBookModel = [NSEntityDescription insertNewObjectForEntityForName:@"WordBookModel" inManagedObjectContext:self.managedObjectContext];
    wordBookModel.title = @"我的生词本";
    wordBookModel.defaulted = @"1";
    if (![self.managedObjectContext save:nil]) {
        NSLog(@"init wordbook error!");
    } else {
        NSLog(@"init wordbook ok.");
    }
    
    HistoryWordBookModel *historyWordBookModel = [NSEntityDescription insertNewObjectForEntityForName:@"HistoryWordBookModel" inManagedObjectContext:self.managedObjectContext];
    historyWordBookModel.title = @"历史纪录";
    if (![self.managedObjectContext save:nil]) {
        NSLog(@"init wordbook error!");
    } else {
        NSLog(@"init wordbook ok.");
    }

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
    // Saves changes in the application's managed object context before the application terminates.
    [self saveContext];
}

//初始化全局样式
- (void) initAppearance {
    //导航条颜色
    [[UINavigationBar appearance] setBarTintColor:[UIColor whiteColor]];
    //导航条是否透明
    //[[UINavigationBar appearance] setTranslucent:NO];

    ////导航条标题颜色
    //[[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObject:[UIColor whiteColor] forKey:NSForegroundColorAttributeName]];
    ////导航条左右按钮颜色
    //[[UINavigationBar appearance] setTintColor:[UIColor whiteColor]];

    //导航返回按钮背景图
    [[UIBarButtonItem appearance] setBackButtonBackgroundImage:[UIImage imageNamed:@"navi_back"]  forState:UIControlStateNormal barMetrics:UIBarMetricsDefault];
    //[[UIBarButtonItem appearance] setBackButtonBackgroundImage:[[UIImage imageNamed:@"navi_back"] imageWithTintColor:[UIColor BEHighLightFontColor]] forState:UIControlStateHighlighted barMetrics:UIBarMetricsDefault];

    //隐藏文字
    [[UIBarButtonItem appearance] setBackButtonTitlePositionAdjustment:UIOffsetMake(-500, 0)
                                                         forBarMetrics:UIBarMetricsDefault];
    //导航栏标题颜色
    [[UINavigationBar appearance] setTitleTextAttributes:[NSDictionary dictionaryWithObjectsAndKeys:
                                                                     [UIColor BEDeepFontColor], NSForegroundColorAttributeName,
                                                                     nil]];
}

#pragma mark - Split view

//- (BOOL)splitViewController:(UISplitViewController *)splitViewController collapseSecondaryViewController:(UIViewController *)secondaryViewController ontoPrimaryViewController:(UIViewController *)primaryViewController {
//    if ([secondaryViewController isKindOfClass:[UINavigationController class]] && [[(UINavigationController *)secondaryViewController topViewController] isKindOfClass:[DetailViewController class]] && ([(DetailViewController *)[(UINavigationController *)secondaryViewController topViewController] detailItem] == nil)) {
//        // Return YES to indicate that we have handled the collapse by doing nothing; the secondary controller will be discarded.
//        return YES;
//    } else {
//        return NO;
//    }
//}

#pragma mark - Core Data stack

@synthesize managedObjectContext = _managedObjectContext;
@synthesize managedObjectModel = _managedObjectModel;
@synthesize persistentStoreCoordinator = _persistentStoreCoordinator;

- (NSURL *)applicationDocumentsDirectory {
    // The directory the application uses to store the Core Data store file. This code uses a directory named "etonetech.BiggerEnglish" in the application's documents directory.
    return [[[NSFileManager defaultManager] URLsForDirectory:NSDocumentDirectory inDomains:NSUserDomainMask] lastObject];
}

- (NSManagedObjectModel *)managedObjectModel {
    // The managed object model for the application. It is a fatal error for the application not to be able to find and load its model.
    if (_managedObjectModel != nil) {
        return _managedObjectModel;
    }
    NSURL *modelURL = [[NSBundle mainBundle] URLForResource:@"BiggerEnglish" withExtension:@"momd"];
    _managedObjectModel = [[NSManagedObjectModel alloc] initWithContentsOfURL:modelURL];
    return _managedObjectModel;
}

- (NSPersistentStoreCoordinator *)persistentStoreCoordinator {
    // The persistent store coordinator for the application. This implementation creates and return a coordinator, having added the store for the application to it.
    if (_persistentStoreCoordinator != nil) {
        return _persistentStoreCoordinator;
    }
    
    // Create the coordinator and store
    
    _persistentStoreCoordinator = [[NSPersistentStoreCoordinator alloc] initWithManagedObjectModel:[self managedObjectModel]];
    NSURL *storeURL = [[self applicationDocumentsDirectory] URLByAppendingPathComponent:@"BiggerEnglish.sqlite"];
    NSError *error = nil;
    NSString *failureReason = @"There was an error creating or loading the application's saved data.";
    if (![_persistentStoreCoordinator addPersistentStoreWithType:NSSQLiteStoreType configuration:nil URL:storeURL options:nil error:&error]) {
        // Report any error we got.
        NSMutableDictionary *dict = [NSMutableDictionary dictionary];
        dict[NSLocalizedDescriptionKey] = @"Failed to initialize the application's saved data";
        dict[NSLocalizedFailureReasonErrorKey] = failureReason;
        dict[NSUnderlyingErrorKey] = error;
        error = [NSError errorWithDomain:@"YOUR_ERROR_DOMAIN" code:9999 userInfo:dict];
        // Replace this with code to handle the error appropriately.
        // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
        NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
        abort();
    }
    
    return _persistentStoreCoordinator;
}


- (NSManagedObjectContext *)managedObjectContext {
    // Returns the managed object context for the application (which is already bound to the persistent store coordinator for the application.)
    if (_managedObjectContext != nil) {
        return _managedObjectContext;
    }
    
    NSPersistentStoreCoordinator *coordinator = [self persistentStoreCoordinator];
    if (!coordinator) {
        return nil;
    }
    _managedObjectContext = [[NSManagedObjectContext alloc] init];
    [_managedObjectContext setPersistentStoreCoordinator:coordinator];
    return _managedObjectContext;
}

#pragma mark - Core Data Saving support

- (void)saveContext {
    NSManagedObjectContext *managedObjectContext = self.managedObjectContext;
    if (managedObjectContext != nil) {
        NSError *error = nil;
        if ([managedObjectContext hasChanges] && ![managedObjectContext save:&error]) {
            // Replace this implementation with code to handle the error appropriately.
            // abort() causes the application to generate a crash log and terminate. You should not use this function in a shipping application, although it may be useful during development.
            NSLog(@"Unresolved error %@, %@", error, [error userInfo]);
            abort();
        }
    }
}

@end
