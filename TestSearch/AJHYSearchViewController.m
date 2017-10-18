//
//  AJHYSearchViewController.m
//  Ehome
//
//  Created by 曾文辉 on 2017/10/10.
//  Copyright © 2017年 ajhy. All rights reserved.
//

#import "AJHYSearchViewController.h"
#import "MJRefresh.h"
#import "AJLoadingView.h"

@interface AJHYSearchViewController ()<UISearchBarDelegate, UITableViewDelegate, UITableViewDataSource>
{
    BOOL isFirstAppear;
    BOOL keyboardShowing;
}

@property (nonatomic, strong) UISearchBar *searchBar;
@property(nonatomic,strong)UITableView *mTableView;
@property(nonatomic,strong)AJLoadingView *loadingView;

@end


@implementation AJHYSearchViewController


-(instancetype)init
{
    if(self = [super init])
    {
        
    }
    return self;
}

- (void)viewDidLoad {
    [super viewDidLoad];
    self.view.backgroundColor  = [UIColor whiteColor];
    // Do any additional setup after loading the view.
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidShow:) name:UIKeyboardDidShowNotification object:nil];
     [[NSNotificationCenter defaultCenter] addObserver:self selector:@selector(keyboardDidHide:) name:UIKeyboardDidHideNotification object:nil];
    self.navigationItem.rightBarButtonItem = [[UIBarButtonItem alloc] initWithTitle:@"取消" style:UIBarButtonItemStyleDone target:self action:@selector(cancelDidClick)];
    UIView *titleView = [[UIView alloc] init];
    //    titleView.backgroundColor = [UIColor whiteColor];
    titleView.x = 10 * 0.5;
    titleView.y = 7;
    titleView.width = self.view.width - 64 - titleView.x * 2;
    titleView.height = 30;
    UISearchBar *searchBar = [[UISearchBar alloc] initWithFrame:titleView.bounds];
    [titleView addSubview:searchBar];
    titleView.autoresizingMask = UIViewAutoresizingFlexibleWidth;
    self.navigationItem.titleView = titleView;
    // close autoresizing
    searchBar.translatesAutoresizingMaskIntoConstraints = NO;
    NSLayoutConstraint *widthCons = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeWidth  relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeWidth multiplier:1.0 constant:0];
    NSLayoutConstraint *heightCons = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeHeight  relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeHeight multiplier:1.0 constant:0];
    NSLayoutConstraint *xCons = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeTop  relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeTop multiplier:1.0 constant:0];
    NSLayoutConstraint *yCons = [NSLayoutConstraint constraintWithItem:searchBar attribute:NSLayoutAttributeLeft  relatedBy:NSLayoutRelationEqual toItem:titleView attribute:NSLayoutAttributeLeft multiplier:1.0 constant:0];
    [titleView addConstraint:widthCons];
    [titleView addConstraint:heightCons];
    [titleView addConstraint:xCons];
    [titleView addConstraint:yCons];
    if(self.placeholderString)
    {
       searchBar.placeholder = self.placeholderString;
    } else {
        searchBar.placeholder = @"搜索";
    }
    
    searchBar.backgroundImage = [UIImage imageNamed:@"aj_clearImage"];
    searchBar.delegate = self;
    self.searchBar = searchBar;
    _mTableView = [[UITableView alloc] initWithFrame:CGRectMake(0,0, SCREEN_WIDTH,SCREEN_HEIGHT) style:UITableViewStylePlain];
    _mTableView.delegate = self;
    _mTableView.dataSource = self;
    _mTableView.backgroundColor = [UIColor clearColor];
    _mTableView.separatorStyle = UITableViewCellSeparatorStyleSingleLine;
    [_mTableView setSeparatorInset:UIEdgeInsetsMake(0, 0, 0, 0)];
    UIView *view = [UIView new];
    view.backgroundColor = [UIColor clearColor];
    [self.mTableView setTableFooterView:view];
    [self.view addSubview:_mTableView];
    
    if(self.didSearchMoreBlock)
    {
        __weak __typeof(self) weakSelf = self;
        // 设置回调（一旦进入刷新状态就会调用这个refreshingBlock）
        //    self.mTableView.mj_header = [MJRefreshNormalHeader headerWithRefreshingBlock:^{
        //
        //    }];
        
        // 马上进入刷新状态
        //    [self.mTableView.mj_header beginRefreshing];
        // 设置回调（一旦进入刷新状态，就调用target的action，也就是调用self的loadMoreData方法）
        self.mTableView.mj_footer = [MJRefreshBackNormalFooter footerWithRefreshingBlock:^{
            weakSelf.didSearchMoreBlock(weakSelf.searchBar.text);
            
        }];
        // 设置了底部inset
        self.mTableView.contentInset = UIEdgeInsetsMake(0, 0, 30, 0);
        // 忽略掉底部inset
        self.mTableView.mj_footer.ignoredScrollViewContentInsetBottom = 30;
    }
    [self.view addSubview:_mTableView];
    
//    UIButton *btn  = [[UIButton alloc]initWithFrame:CGRectMake(0, SCREEN_HEIGHT-AUTO(100), AUTO(100), AUTO(50))];
//    [btn setBackgroundColor:[UIColor redColor]];
//    [btn addTarget:self action:@selector(cancelDidClick) forControlEvents:UIControlEventTouchUpInside];
//    [self.view addSubview:btn];
    
}

-(void)viewWillAppear:(BOOL)animated
{
    [super viewWillAppear:animated];
    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0xf9f9f9);//导航栏颜色
    self.navigationController.navigationBar.tintColor = UIColorFromRGB(0x007aff);//返回按钮颜色
    self.navigationController.navigationBar.barStyle = UIBarStyleDefault;
    
    [self.navigationController.navigationBar setTitleTextAttributes:
     @{NSFontAttributeName:[UIFont systemFontOfSize:AUTO(17)],
       NSForegroundColorAttributeName:[UIColor blueColor]}];
    [self.searchBar becomeFirstResponder];
}

-(void)viewWillDisappear:(BOOL)animated{
    [super viewWillDisappear:animated];
//    self.navigationController.navigationBar.barTintColor = UIColorFromRGB(0x353439);//导航栏颜色
//    self.navigationController.navigationBar.tintColor = WHITECOLOR;//返回按钮颜色
//    self.navigationController.navigationBar.barStyle = UIBarStyleBlack;
//    [self.navigationController.navigationBar setTitleTextAttributes:
//     @{NSFontAttributeName:[UIFont systemFontOfSize:AUTO(17)],
//       NSForegroundColorAttributeName:WHITECOLOR}];
    [self.searchBar resignFirstResponder];
}

-(void)viewDidAppear:(BOOL)animated
{
    [super viewDidAppear:animated];
    if(!isFirstAppear)
    {
        [self.searchBar becomeFirstResponder];
        isFirstAppear = YES;
    }
}

- (void)setSearchSuggestions:(NSArray<NSString *> *)searchSuggestions
{
    _searchSuggestions = [searchSuggestions copy];
    if(searchSuggestions.count>0)
    {
        if(self.loadingView)
        {
            [self.loadingView hidenLoadingView];
        }
    }
    [self.mTableView reloadData];
    
}

-(void)deleteTableViewIndexPath:(NSIndexPath *)indexPath
{
    [self.mTableView deleteRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)refreshTableViewIndexPath:(NSIndexPath *)indexPath
{
    [self.mTableView reloadRowsAtIndexPaths:@[indexPath] withRowAnimation:UITableViewRowAnimationNone];
}

-(void)refreshTableView{
    [self.searchBar resignFirstResponder];
    [self refreshLoadingType:1];
    [self endFooterRefresh:YES];
    [self.mTableView reloadData];
}

-(void)refreshLoadingType:(NSInteger)type
{
    [self.searchBar resignFirstResponder];
    if(!self.loadingView)
    {
        self.loadingView = [[AJLoadingView alloc]initWithFrame:CGRectMake(0, 64, SCREEN_WIDTH, SCREEN_HEIGHT-64)];
    }
    if(type==0)
    {
        [self.loadingView showLoadingView:1 andRootView:self.view];
    } else
    {
        [self.loadingView hidenLoadingView];
    }
}

-(void)endFooterRefresh:(BOOL)hasMore
{
    [self.searchBar resignFirstResponder];
    if(self.mTableView.mj_footer)
    {
        if(hasMore)
        {
            [self.mTableView.mj_footer endRefreshing];
        } else
        {
            [self.mTableView.mj_footer endRefreshingWithNoMoreData];
        }
        
    }
}


-(void)cancelDidClick
{
    [self.searchBar resignFirstResponder];
    if(self.delegate)
    {
        if([self.delegate respondsToSelector:@selector(didClickCancel:)])
            [self.delegate didClickCancel:self];
    }
    //    [self dismissViewControllerAnimated:YES completion:nil];
}

- (void)keyboardDidShow:(NSNotification *)noti
{
    keyboardShowing = YES;
}

- (void)keyboardDidHide:(NSNotification *)noti
{
    keyboardShowing = NO;
}


- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

#pragma mark - UISearchBarDelegate

-(void)searchBarTextDidBeginEditing:(UISearchBar *)searchBar
{
    UITextField *searchBarTextField = nil;
    
    NSArray *views = ([[[UIDevice currentDevice] systemVersion] floatValue] < 7.0) ? searchBar.subviews : [[searchBar.subviews objectAtIndex:0] subviews];
    
    for (UIView *subview in views)
        
    {
        
        if ([subview isKindOfClass:[UITextField class]])
            
        {
            
            searchBarTextField = (UITextField *)subview;
            
            break;
            
        }
        
    }
    
    searchBarTextField.enablesReturnKeyAutomatically = NO;
}

- (void)searchBarSearchButtonClicked:(UISearchBar *)searchBar
{
    if ([self.delegate respondsToSelector:@selector(searchViewController:didSearchWithSearchBar:searchText:)]) {
        [self.searchBar resignFirstResponder];
        [self.delegate searchViewController:self didSearchWithSearchBar:searchBar searchText:searchBar.text];
        return;
    }
    if (self.didSearchBlock)
    {
        [self.mTableView.mj_footer endRefreshing];
        self.didSearchBlock(searchBar.text);
    }
    
}

- (void)searchBar:(UISearchBar *)searchBar textDidChange:(NSString *)searchText
{
    if ([self.delegate respondsToSelector:@selector(searchViewController:searchTextDidChange:searchText:)]) {
        [self.delegate searchViewController:self searchTextDidChange:searchBar searchText:searchText];
    }
}

- (BOOL)searchBarShouldBeginEditing:(UISearchBar *)searchBar
{
    return YES;
}



#pragma mark - Table view data source
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    if ([self.dataSource respondsToSelector:@selector(numberOfSectionsInSearchView::)]) {
        return [self.dataSource numberOfSectionsInSearchView:tableView];
    }
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    if ([self.dataSource respondsToSelector:@selector(searchView:numberOfRowsInSection:)]) {
        return [self.dataSource searchView:tableView numberOfRowsInSection:section];
    }
    
    return self.searchSuggestions?self.searchSuggestions.count:0;
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    if ([self.dataSource respondsToSelector:@selector(searchView:cellForRowAtIndexPath:)]) {
        UITableViewCell *cell= [self.dataSource searchView:tableView cellForRowAtIndexPath:indexPath];
        if (cell) return cell;
    }
    
    static NSString *cellID = @"PYSearchSuggestionCellID";
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:cellID];
    if (!cell) {
        cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:cellID];
        cell.textLabel.textColor = [UIColor darkGrayColor];
        cell.textLabel.font = [UIFont systemFontOfSize:14];
        cell.backgroundColor = [UIColor clearColor];
    }
    cell.imageView.image = [UIImage imageNamed:@"cc_search"];
    cell.textLabel.text = self.searchSuggestions[indexPath.row];
    return cell;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
    if ([self.dataSource respondsToSelector:@selector(searchView:heightForRowAtIndexPath:)]) {
        return [self.dataSource searchView:tableView heightForRowAtIndexPath:indexPath];
    }
    return 44.0;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
    [tableView deselectRowAtIndexPath:indexPath animated:YES];
    if([self.delegate respondsToSelector:@selector(didSelectSearchAtIndexPath:)])
    {
        [self.delegate didSelectSearchAtIndexPath:indexPath];
    } else if([self.delegate respondsToSelector:@selector(searchViewController:didSelectSearchSuggestionAtIndexPath:searchBar:)])
    {
        [self.delegate searchViewController:self didSelectSearchSuggestionAtIndexPath:indexPath searchBar:self.searchBar];
    }
    
}

-(void)scrollViewDidScroll:(UIScrollView *)scrollView
{
    if(keyboardShowing)
    {
        [self.searchBar resignFirstResponder];
    }
}



@end
