//
//  REViewOptionsController.m
//  Shitan
//
//  Created by 刘敏 on 14-11-12.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "REViewOptionsController.h"
#import "RETableViewItem.h"
#import "RETableViewManager.h"


@interface REViewOptionsController ()

@property (strong, readwrite, nonatomic) RETableViewManager *tableViewManager;
@property (strong, readwrite, nonatomic) RETableViewSection *mainSection;

@end

@implementation REViewOptionsController



- (id)initWithItem:(RETableViewItem *)item options:(NSArray *)options multipleChoice:(BOOL)multipleChoice completionHandler:(void(^)(void))completionHandler
{
    if (!self)
        return nil;
    
    self.item = item;
    self.options = options;
    self.title = item.title;
    self.multipleChoice = multipleChoice;
    self.completionHandler = completionHandler;
    
    return self;
}

- (void)viewDidLoad
{
    [super viewDidLoad];
    
    
    CGRect f = CGRectMake(0, 20, self.view.bounds.size.width, self.view.bounds.size.height-20);
    self.tableView = [[UITableView alloc] initWithFrame:f style: UITableViewStyleGrouped];
    [self.view addSubview:self.tableView];
    
    
    
    [self setNavBarTitle:self.title];
    [ResetFrame resetScrollView:self.tableView contentInsetWithNaviBar:YES tabBar:NO iOS7ContentInsetStatusBarHeight:-1 inidcatorInsetStatusBarHeight:-1];

    
    self.tableViewManager = [[RETableViewManager alloc] initWithTableView:self.tableView delegate:self.delegate];
    self.tableViewManager.style.cellHeight = 44.0;
    self.mainSection = [[RETableViewSection alloc] init];
    [self.tableViewManager addSection:self.mainSection];
    
    
    
    if (self.style)
        self.tableViewManager.style = self.style;
    
    __typeof (&*self) __weak weakSelf = self;
    void (^refreshItems)(void) = ^{
        REMultipleChoiceItem * __weak item = (REMultipleChoiceItem *)weakSelf.item;
        NSMutableArray *results = [[NSMutableArray alloc] init];
        for (RETableViewItem *sectionItem in weakSelf.mainSection.items) {
            for (NSString *strValue in item.value) {
                if ([strValue isEqualToString:sectionItem.title])
                    [results addObject:sectionItem.title];
            }
        }
        item.value = results;
    };
    
    void (^addItem)(NSString *title) = ^(NSString *title) {
        UITableViewCellAccessoryType accessoryType = UITableViewCellAccessoryNone;
        if (!weakSelf.multipleChoice) {
            if ([title isEqualToString:self.item.detailLabelText])
                accessoryType = UITableViewCellAccessoryCheckmark;
        } else {
            REMultipleChoiceItem * __weak item = (REMultipleChoiceItem *)weakSelf.item;
            for (NSString *strValue in item.value) {
                if ([strValue isEqualToString:title]) {
                    accessoryType = UITableViewCellAccessoryCheckmark;
                }
            }
        }
        [self.mainSection addItem:[RETableViewItem itemWithTitle:title accessoryType:accessoryType selectionHandler:^(RETableViewItem *selectedItem) {
            UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:selectedItem.indexPath];
            if (!weakSelf.multipleChoice) {
                for (NSIndexPath *indexPath in [weakSelf.tableView indexPathsForVisibleRows]) {
                    UITableViewCell *cell = [weakSelf.tableView cellForRowAtIndexPath:indexPath];
                    cell.accessoryType = UITableViewCellAccessoryNone;
                }
                for (RETableViewItem *item in weakSelf.mainSection.items) {
                    item.accessoryType = UITableViewCellAccessoryNone;
                }
                selectedItem.accessoryType = UITableViewCellAccessoryCheckmark;
                cell.accessoryType = UITableViewCellAccessoryCheckmark;
                RERadioItem * __weak item = (RERadioItem *)weakSelf.item;
                item.value = selectedItem.title;
                if (weakSelf.completionHandler)
                    weakSelf.completionHandler();
            } else { // Multiple choice item
                REMultipleChoiceItem * __weak item = (REMultipleChoiceItem *)weakSelf.item;
                [weakSelf.tableView deselectRowAtIndexPath:selectedItem.indexPath animated:YES];
                if (selectedItem.accessoryType == UITableViewCellAccessoryCheckmark) {
                    selectedItem.accessoryType = UITableViewCellAccessoryNone;
                    cell.accessoryType = UITableViewCellAccessoryNone;
                    NSMutableArray *items = [[NSMutableArray alloc] init];
                    for (NSString *val in item.value) {
                        if (![val isEqualToString:selectedItem.title])
                            [items addObject:val];
                    }
                    
                    item.value = items;
                } else {
                    selectedItem.accessoryType = UITableViewCellAccessoryCheckmark;
                    cell.accessoryType = UITableViewCellAccessoryCheckmark;
                    NSMutableArray *items = [[NSMutableArray alloc] initWithArray:item.value];
                    [items addObject:selectedItem.title];
                    item.value = items;
                    refreshItems();
                }
                if (weakSelf.completionHandler)
                    weakSelf.completionHandler();
            }
        }]];
    };
    
    for (RETableViewItem *item in self.options) {
        addItem([item isKindOfClass:[[RERadioItem item] class]] ? item.title : (NSString *)item);
    }
}

@end
