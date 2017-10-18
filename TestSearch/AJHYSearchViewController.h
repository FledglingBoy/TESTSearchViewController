//
//  AJHYSearchViewController.h
//  Ehome
//
//  Created by 曾文辉 on 2017/10/10.
//  Copyright © 2017年 ajhy. All rights reserved.
//

#import <UIKit/UIKit.h>



@class AJHYSearchViewController;

typedef void(^AJDidSearchBlock)(NSString *searchText);
typedef void(^AJDidSearchMoreBlock)(NSString *searchText);


@protocol AJSearchViewDataSource <NSObject, UITableViewDataSource>

@required
- (UITableViewCell *)searchView:(UITableView *)searchView cellForRowAtIndexPath:(NSIndexPath *)indexPath;
- (NSInteger)searchView:(UITableView *)searchView numberOfRowsInSection:(NSInteger)section;
@optional
- (NSInteger)numberOfSectionsInSearchView:(UITableView *)searchView;
- (CGFloat)searchView:(UITableView *)searchView heightForRowAtIndexPath:(NSIndexPath *)indexPath;

@end

@protocol AJSearchViewControllerDelegate <NSObject, UITableViewDelegate>

@optional

- (void)didSelectSearchAtIndexPath:(NSIndexPath *)indexPath;
- (void)searchViewController:(AJHYSearchViewController *)searchViewController
      didSearchWithSearchBar:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText;
- (void)searchViewController:(AJHYSearchViewController *)searchViewController
         searchTextDidChange:(UISearchBar *)searchBar
                  searchText:(NSString *)searchText;
- (void)searchViewController:(AJHYSearchViewController *)searchViewController didSelectSearchSuggestionAtIndexPath:(NSIndexPath *)indexPath
                   searchBar:(UISearchBar *)searchBar;

- (void)didClickCancel:(AJHYSearchViewController *)searchViewController;
//-(void)didRefreshHeader;
//-(void)didRefreshFooter;

@end

@interface AJHYSearchViewController : UIViewController

@property(nonatomic,strong) NSString *placeholderString;
@property (nonatomic, copy) AJDidSearchBlock didSearchBlock;
@property (nonatomic, copy) AJDidSearchMoreBlock didSearchMoreBlock;

@property (nonatomic, weak) id<AJSearchViewDataSource> dataSource;
@property (nonatomic, weak) id<AJSearchViewControllerDelegate> delegate;

@property (nonatomic, copy) NSArray<NSString *> *searchSuggestions;

-(void)refreshTableViewIndexPath:(NSIndexPath *)indexPath;
-(void)deleteTableViewIndexPath:(NSIndexPath *)indexPath;
-(void)refreshTableView;
-(void)refreshLoadingType:(NSInteger)type;
-(void)endFooterRefresh:(BOOL)hasMore;



@end
