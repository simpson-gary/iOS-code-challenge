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
#import "YLPBusiness.h"
#import <ios_code_challenge-Swift.h>

@interface NXTDataSource()

@property (nonatomic, strong) NSMutableArray *mutableObjects;
@property (nonatomic, strong) TabBarViewController *masterView;

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
  
  if(indexPath.row >= [tableView numberOfRowsInSection:0] - 7) {
    [_masterView executePageQuery];
  }
}

-(void) tableView:(UITableView *)tableView didDisplayCell:(id<NXTBindingDataForObjectDelegate>)cell forRowAtIndexPath:(NSIndexPath *)indexPath
{
  
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath
{
  NXTBusinessTableViewCell *cell = [tableView cellForRowAtIndexPath: indexPath];
  [_masterView transitionDetailViewWithCell:cell];
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
- (void)setDetailAction:(TabBarViewController *)view
{
  self.masterView = view;
}

- (void)setObjects:(NSArray *)objects
{
  NSArray *sortedArray;
  sortedArray = [objects sortedArrayUsingComparator:^NSComparisonResult(id a, id b) {
    NSNumber *first = [(YLPBusiness*)a distance];
    NSNumber *second = [(YLPBusiness*)b distance];
    return [first compare:second];
  }];
  
  [self.mutableObjects setArray:sortedArray];
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
