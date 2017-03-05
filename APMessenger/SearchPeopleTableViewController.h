//
//  SearchPeopleTableViewController.h
//  APMessenger
//
//  Created by Admir Sahbaz on 2/25/17.
//  Copyright © 2017 Authority Partners. All rights reserved.
//

#import <UIKit/UIKit.h>

@interface SearchPeopleTableViewController : UITableViewController<UISearchControllerDelegate, UISearchBarDelegate, UISearchResultsUpdating>

@property (strong, nonatomic) UISearchController *searchController;
@property (strong, nonatomic) NSMutableArray *people;

@end
