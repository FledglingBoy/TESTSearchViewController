//
//  ViewTableViewController.m
//  TestSearch
//
//  Created by 曾文辉 on 2017/10/13.
//  Copyright © 2017年 曾文辉. All rights reserved.
//

#import "ViewTableViewController.h"
#import "AJSearchViewController.h"
#import "AJHYSearchViewController.h"
#import "MJRefresh.h"
#import "AJHYSearchTransitionAnimator.h"

@interface ViewTableViewController ()<UITableViewDelegate,UITableViewDataSource,UIViewControllerTransitioningDelegate,AJSearchViewControllerDelegate,AJSearchViewDataSource>

@property(nonatomic,strong)UITableView *mTableView;
@property(nonatomic,strong)NSMutableArray *array;
@property(nonatomic,strong)NSMutableArray *searchArray;
@property(nonatomic,assign)NSInteger searchPageNo;
@property(nonatomic,strong)UINavigationController *searchNav;
@property(nonatomic,strong)AJHYSearchViewController *searchVc;
@property(nonatomic,assign)NSInteger pageNo;
@property(nonatomic,strong)UISearchBar *searchBar;

@end

@implementation ViewTableViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    self.title = @"列表";
    UIButton *headerBtn = [[UIButton alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    [headerBtn setBackgroundColor:[UIColor clearColor]];
    [headerBtn addTarget:self action:@selector(didSelectSearch) forControlEvents:UIControlEventTouchUpInside];
    UISearchBar *searchBar = [[UISearchBar alloc]initWithFrame:CGRectMake(0, 0, SCREEN_WIDTH, 44)];
    //    searchBar.backgroundImage = [UIImage imageNamed:@"aj_clearImage"];
    searchBar.placeholder = @"搜索";
    searchBar.backgroundImage = [[UIImage alloc] init];
    searchBar.backgroundColor = UIColorFromRGB(0xf2f2f2);
    searchBar.barTintColor = UIColorFromRGB(0xf2f2f2);
    //    searchBar.showsCancelButton = NO;
    searchBar.userInteractionEnabled = NO;
    [self.view addSubview:searchBar];
    self.searchBar = searchBar;
    [headerBtn addSubview:searchBar];
    self.array = [[NSMutableArray alloc]init];
    self.searchArray = [[NSMutableArray alloc]init];
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.tableHeaderView = headerBtn;
    _mTableView.backgroundColor = UIColorFromRGB(0xf2f2f2);
    _mTableView.scrollIndicatorInsets = UIEdgeInsetsMake(0, 0, 0, 0);
    __weak __typeof(self) weakSelf = self;
    
    // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
    self.mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        weakSelf.pageNo = 1;
        [weakSelf reqData];
    }];
    
    // 马上进入刷新状态
    [self.mTableView.mj_header beginRefreshing];
    // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
    self.mTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
        weakSelf.pageNo++;
        [weakSelf reqData];
    }];
    // 设置了底部inset
    self.mTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
    // 忽略掉底部inset
    self.mTableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
    
    [self.view addSubview:_mTableView];
    
    
}

-(void)didSelectSearch
{
    __weak typeof(self) weakSelf = self;
    AJHYSearchViewController *searchViewController = [[AJHYSearchViewController alloc]init];
    searchViewController.didSearchBlock = ^(NSString *searchText)
    {
        searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
        weakSelf.searchPageNo = 1;
        [weakSelf reqSearchData];
    };
    searchViewController.didSearchMoreBlock = ^(NSString *searchText){
        searchText = [searchText stringByReplacingOccurrencesOfString:@" " withString:@""];
        weakSelf.searchPageNo++;
        [weakSelf reqSearchData];
    };
    searchViewController.delegate = self;
    searchViewController.dataSource = self;
    self.searchVc = searchViewController;
    // 5. 跳转到搜索控制器
    UINavigationController *nav = [[UINavigationController alloc] initWithRootViewController:searchViewController];
    self.searchNav = nav;
    nav.modalPresentationStyle = UIModalPresentationFullScreen;
    nav.transitioningDelegate = self;
    [self presentViewController:nav animated:YES completion:nil];
    
    //    [self.navigationController pushViewController:searchViewController animated:YES];
    
}


-(void)reqData{
    [self.mTableView.mj_header endRefreshing];
    [self.mTableView.mj_footer endRefreshing];
    
    for(int i=0;i<10;i++){
        [self.array addObject:[NSString stringWithFormat:@"第%d个",i]];
    }
    [self.mTableView reloadData];
    
}

-(void)reqSearchData{
    
    
    for(int i=0;i<10;i++){
        [self.searchArray addObject:[NSString stringWithFormat:@"第%d个",i]];
    }
    [self.searchVc refreshTableView];
    
}

- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - Table view data source

- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return 5;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test_cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test_cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}

//searchdelegate

-(UITableViewCell *)searchView:(UITableView *)searchView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [searchView dequeueReusableCellWithIdentifier:@"test_cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test_cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    cell.textLabel.text = [NSString stringWithFormat:@"cell%ld",indexPath.row];
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
}


-(NSInteger)searchView:(UITableView *)searchView numberOfRowsInSection:(NSInteger)section
{
    return self.searchArray.count;
}


-(CGFloat)searchView:(UITableView *)searchView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    return AUTO(62);
}


-(void)didSelectSearchAtIndexPath:(NSIndexPath *)indexPath
{
    
}



- (void)searchViewController:(AJHYSearchViewController *)searchViewController searchTextDidChange:(UISearchBar *)seachBar searchText:(NSString *)searchText
{
    searchViewController.searchSuggestions = [NSMutableArray array];
}



-(void)didClickCancel:(AJHYSearchViewController *)searchViewController
{
    [self.searchArray removeAllObjects];
    [self.searchVc refreshTableView];
    //    [self.searchNav dismissViewControllerAnimated:YES completion:nil];
    [searchViewController dismissViewControllerAnimated:YES completion:nil];
}




#pragma mark -
#pragma mark UIViewControllerTransitioningDelegate

//| ----------------------------------------------------------------------------
//  The system calls this method on the presented view controller's
//  transitioningDelegate to retrieve the animator object used for animating
//  the presentation of the incoming view controller.  Your implementation is
//  expected to return an object that conforms to the
//  UIViewControllerAnimatedTransitioning protocol, or nil if the default
//  presentation animation should be used.
//
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForPresentedController:(UIViewController *)presented presentingController:(UIViewController *)presenting sourceController:(UIViewController *)source
{
    AJHYSearchTransitionAnimator *transitionAnimator = [AJHYSearchTransitionAnimator new];
    transitionAnimator.isFromeSearch = NO;
    return transitionAnimator;
}


//| ----------------------------------------------------------------------------
//  The system calls this method on the presented view controller's
//  transitioningDelegate to retrieve the animator object used for animating
//  the dismissal of the presented view controller.  Your implementation is
//  expected to return an object that conforms to the
//  UIViewControllerAnimatedTransitioning protocol, or nil if the default
//  dismissal animation should be used.
//
- (id<UIViewControllerAnimatedTransitioning>)animationControllerForDismissedController:(UIViewController *)dismissed
{
    AJHYSearchTransitionAnimator *transitionAnimator = [AJHYSearchTransitionAnimator new];
    transitionAnimator.isFromeSearch = YES;
    return transitionAnimator;
}




@end
