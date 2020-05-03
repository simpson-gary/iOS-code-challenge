//
//  NXTDataSource.m
//  ios-code-challenge
//
//  Created by Dustin Lange on 1/20/18.
//  Copyright © 2018 Dustin Lange. All rights reserved.
//

#import "NXTDataSource.h"
#import "NXTCellForObjectDelegate.h"
#import "NXTBindingDataForObjectDelegate.h"
#import <ios_code_challenge-Swift.h>

@interface NXTDataSource()

@property (nonatomic, strong) NSMutableArray *mutableObjects;
@property (nonatomic, strong) MasterViewController *masterView;

@end

@implementation NXTDataSource

- (instancetype)initWithObjects:(NSArray *)objects
{
  if(self = [super init]) {
    _mutableObjects = [NSMutableArray arrayWithArray:objects];
  }
  
  return self;
}

#pragma mark - UITableViewDataSource
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView
{
  return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section
{
  return [self.mutableObjects count];
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  id<NXTCellForObjectDelegate> object = self.mutableObjects[indexPath.row];
  return [object estimatedCellHeightForObjectForTableView:tableView];
}

- (CGFloat)tableView:(UITableView *)tableView estimatedHeightForRowAtIndexPath:(NSIndexPath *)indexPath
{
  id<NXTCellForObjectDelegate> object = self.mutableObjects[indexPath.row];
  return [object estimatedCellHeightForObjectForTableView:tableView];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath
{
  id<NXTCellForObjectDelegate> object = self.mutableObjects[indexPath.row];
  id<NXTBindingDataForObjectDelegate> cell = [object cellForObjectForTableView:tableView];
  
  [cell bindingDataForObject:object];
  
  return (UITableViewCell *)cell;
}

#pragma mark - UITableViewDelegate
- (void)tableView:(UITableView *)tableView willDisplayCell:(id<NXTBindingDataForObjectDelegate>)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  if([cell respondsToSelector:@selector(willDisplayCellForObject:)]) {
    id<NXTCellForObjectDelegate> object = self.mutableObjects[indexPath.row];
    
    [cell willDisplayCellForObject:object];
  }
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NSLog(@"tableView::  didSelectRowAtIndexPath");
//  id object = self.mutableObjects[indexPath.row];
//  //if(self.tableViewDidSelectCell) {
//    //self.tableViewDidSelectCell(object);
//  UISplitViewController *splitViewController = _masterView.splitViewController;
//    DetailViewController *toViewController = _masterView.splitViewController.viewControllers[1];
//    NXTBusinessTableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
  //NSLog(@"business is %@", cell.business);
  
//  YLPBusiness *business = cell.business;
  
//  //Build a segue string based on the selected cell
//  NSString *segueString = [NSString stringWithFormat:@"%@showDetail",
//                          [contentArray objectAtIndex:indexPath.row]];
  
  //Perform a segue.
  [_masterView performSegueWithIdentifier:@"showDetail" sender:nil];
  //[toViewController setBusiness: business];

  //toViewController.business = cell.business;

//  if (splitViewController.isCollapsed == false ) {
//    UINavigationController *navController = toViewController.navigationController;
//    [splitViewController showDetailViewController: navController sender: self];
//  }
  
//  _masterView.splitViewController.storyboard.segu
//    UIStoryboardSegue *segue = [[UIStoryboardSegue alloc] initWithIdentifier:@"showDetail" source:_masterView destination: toViewController];
//    [_masterView prepareForSegue:segue sender:_masterView];
//    [segue perform];
  //[_masterView performSegueWithIdentifier:@"showDetail" sender:self];
//  [_masterView.splitViewController showDetailViewController:toViewController sender: self];
  
  //[segue perform];
//  [_masterView.navigationController pushViewController: toViewController animated:YES];
  //}
  
  //[tableView deselectRowAtIndexPath:indexPath animated:YES];
}

- (void)tableView:(UITableView *)tableView accessoryButtonTappedForRowWithIndexPath:(NSIndexPath *)indexPath
{
  id object = self.mutableObjects[indexPath.row];
  
  if(self.tableViewDidSelectAccessoryView) {
    self.tableViewDidSelectAccessoryView(object);
  }
}

#pragma mark - UIScrollViewDelegate
- (void)scrollViewDidScroll:(UIScrollView *)scrollView
{
  if(self.tableViewDidScroll) {
    self.tableViewDidScroll();
  }
}

#pragma mark - Getters & Setters
- (void)setDetailView:(MasterViewController *)viewController
{
  self.masterView = viewController;
}

- (void)setObjects:(NSArray *)objects
{
  [self.mutableObjects setArray:objects];
}

- (void)appendObjects:(NSArray *)objects
{
  [self.mutableObjects addObjectsFromArray:objects];
  
  if(self.tableViewDidReceiveData) {
    self.tableViewDidReceiveData();
  }
}

- (void)insertObject:(id)object atIndex:(NSUInteger)index
{
  [self.mutableObjects insertObject:object atIndex:index];
}

- (void)removeAllObjects
{
  [self.mutableObjects removeAllObjects];
  
  if(self.tableViewDidReceiveData) {
    self.tableViewDidReceiveData();
  }
}

- (void)removeObject:(id)object
{
  [self.mutableObjects removeObject:object];
}

- (NSArray *)objects
{
  return self.mutableObjects;
}

#pragma mark - Properties
- (NSMutableArray *)mutableObjects
{
  if(_mutableObjects == nil) {
    _mutableObjects = [NSMutableArray array];
  }
  
  return _mutableObjects;
}

@end
