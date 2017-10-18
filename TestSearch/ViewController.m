//
//  ViewController.m
//  TestSearch
//
//  Created by 曾文辉 on 2017/10/13.
//  Copyright © 2017年 曾文辉. All rights reserved.
//

#import "ViewController.h"
#import "ViewController1.h"
#import "ViewTableViewController.h"

@interface ViewController ()<UITableViewDataSource,UITableViewDelegate>
@property(nonatomic,strong)UITableView *mTableview;

@end

@implementation ViewController

- (void)viewDidLoad {
    [super viewDidLoad];
    // Do any additional setup after loading the view, typically from a nib.
    
    self.mTableview = [[UITableView alloc] initWithFrame:CGRectMake(0,0, [UIScreen mainScreen].bounds.size.width,[UIScreen mainScreen].bounds.size.height) style:UITableViewStylePlain];
    self.mTableview.delegate = self;
    self.mTableview.dataSource = self;
    self.mTableview.backgroundColor = [UIColor whiteColor];
    [self.view addSubview:self.mTableview];
    
    
}




- (void)didReceiveMemoryWarning {
    [super didReceiveMemoryWarning];
    // Dispose of any resources that can be recreated.
}

-(NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
    return 2;
}

-(UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
    UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:@"test_cell"];
    if(!cell)
    {
        cell = [[UITableViewCell alloc]initWithStyle:UITableViewCellStyleDefault reuseIdentifier:@"test_cell"];
    }
    cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    if(indexPath.row ==0)
    {
         cell.textLabel.text = @"系统原生uisearchviewcontorller";
    } else
    {
        cell.textLabel.text = @"自定义searchview";
      
    }
    
    cell.backgroundColor = [UIColor whiteColor];
    return cell;
    
}

-(void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath{
    if(indexPath.row ==0){
        ViewController1 *vc = [[ViewController1 alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    } else
    {
        ViewTableViewController *vc = [[ViewTableViewController alloc]init];
        [self.navigationController pushViewController:vc animated:YES];
    }
}


@end
