//
//  ResuableView.m
//  CollectionView
//
//  Created by Li Hongjun on 13-5-23.
//  Copyright (c) 2013年 Li Hongjun. All rights reserved.
//

#import "ResuableView.h"

@implementation ResuableView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {

        _searchController = [[UISearchController alloc] initWithSearchResultsController:nil];
        
        _searchController.dimsBackgroundDuringPresentation = NO;
        
        _searchController.hidesNavigationBarDuringPresentation = NO;
        
        _searchController.searchBar.frame = CGRectMake(0, 0, self.width, 44.0);
        
        [self addSubview:_searchController.searchBar];
    }
    return self;
}

@end
