//
//  ViewController.m
//  Refrsh
//
//  Created by HGDQ on 15/10/27.
//  Copyright (c) 2015年 HGDQ. All rights reserved.
//

#import "ViewController.h"

@interface ViewController ()<UITableViewDelegate,UITableViewDataSource>
@property (weak, nonatomic) IBOutlet UITableView *tabelView;
@property (nonatomic,strong)NSMutableArray *dataArray;
@property (nonatomic,assign)CGFloat conoffSet;

@end

@implementation ViewController

- (void)viewDidLoad {
	[super viewDidLoad];
	[self makeData:30];
	self.tabelView.delegate = self;
	self.tabelView.dataSource = self;
	
	[self setHeadLabel];
	
	NSLog(@"contentOffset = %f",self.tabelView.contentOffset.y);
	NSLog(@"contentSize = %f",self.tabelView.contentSize.height);
	// Do any additional setup after loading the view, typically from a nib.
}
- (void)makeData:(NSInteger)num{
	self.dataArray = [NSMutableArray array];
	for (int i = 0;i < num;i ++) {
		[self.dataArray addObject:[NSString stringWithFormat:@"%d",i]];
	}
}
- (void)setHeadLabel{
	UILabel *refresh = [[UILabel alloc] init];
	refresh.frame = CGRectMake(0, -64, 100, 64);
	refresh.text = @"刷新";
	refresh.textAlignment = NSTextAlignmentCenter;
	refresh.textColor = [UIColor orangeColor];
	[self.tabelView addSubview:refresh];
	
	UIActivityIndicatorView * myAct = [[UIActivityIndicatorView alloc] initWithActivityIndicatorStyle:UIActivityIndicatorViewStyleGray];
	myAct.frame = CGRectMake(0, -64, 220, 64);
	[myAct startAnimating];
	[self.tabelView addSubview:myAct];
}
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView{
	return 1;
}
- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section{
	return self.dataArray.count;
}
- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath{
	static NSString *identify = @"Cell";
	UITableViewCell *cell = [tableView dequeueReusableCellWithIdentifier:identify];
	if (cell == nil) {
		cell = [[UITableViewCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:identify];
	}
	cell.textLabel.text = [NSString stringWithFormat:@"%ld",(long)indexPath.row];
	return cell;
}

- (void)scrollViewDidEndDecelerating:(UIScrollView *)scrollView{
	NSLog(@"%s:%d", __func__, __LINE__);
	NSLog(@"Decelerating_contentOffset = %f",self.tabelView.contentOffset.y);
	NSLog(@"Decelerating_contentSize = %f",self.tabelView.contentSize.height);
	NSLog(@"*******************************************");
}

- (void)scrollViewWillBeginDragging:(UIScrollView *)scrollView{
	NSLog(@"%s:%d", __func__, __LINE__);
	NSLog(@"Dragging_contentOffset = %f",self.tabelView.contentOffset.y);
	NSLog(@"Dragging_contentSize = %f",self.tabelView.contentSize.height);
	self.conoffSet = self.tabelView.contentOffset.y;
	NSLog(@"*******************************************");
}
- (void)scrollViewDidScroll:(UIScrollView *)scrollView{
	NSLog(@"%s:%d", __func__, __LINE__);
	NSLog(@"S_contentOffset = %f",self.tabelView.contentOffset.y);
	NSLog(@"S_contentSize = %f",self.tabelView.contentSize.height);
	if (self.tabelView.contentOffset.y <= -120) {
		[UIView animateWithDuration:5 animations:^{
			NSLog(@"下拉刷新");
			[self.tabelView setContentInset:UIEdgeInsetsMake(200, 0, 0, 0)];
			[self performSelector:@selector(huifu) withObject:nil afterDelay:2];
		}];
	}
	
	if ((self.tabelView.contentSize.height - self.tabelView.contentOffset.y) <= 420) {
		[UIView animateWithDuration:5 animations:^{
			NSLog(@"上拉加载更多");
			[self.tabelView setContentInset:UIEdgeInsetsMake(64, 0, 200, 0)];
			[self performSelector:@selector(shangla) withObject:nil afterDelay:2];
		}];
	}
	NSLog(@"*******************************************");
}
- (void)huifu{
	[UIView animateWithDuration:2 animations:^{
		NSLog(@"恢复");
		[self.tabelView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
	}];
}
- (void)shangla{
	[UIView animateWithDuration:2 animations:^{
		[self.tabelView setContentInset:UIEdgeInsetsMake(64, 0, 0, 0)];
	} completion:^(BOOL finished) {
		[self makeData:50];
		[self.tabelView reloadData];
	}];
}

- (void)didReceiveMemoryWarning {
	[super didReceiveMemoryWarning];
	// Dispose of any resources that can be recreated.
}

@end


































