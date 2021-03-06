//
//  BEMenuSectionView.m
//  BiggerEnglish
//
//  Created by 陈大捷 on 15/5/13.
//  Copyright (c) 2015年 etonetech. All rights reserved.
//



#import "BEMenuSectionView.h"
#import "BEMenuSectionCell.h"

static CGFloat const kAvatarHeight = 70.0f;

@interface BEMenuSectionView () <UITableViewDelegate, UITableViewDataSource>

@property (nonatomic, strong) UIImageView *avatarImageView;
@property (nonatomic, strong) UIButton    *avatarButton;
@property (nonatomic, strong) UIImageView *divideImageView;
@property (nonatomic, strong) UILabel     *usernameLabel;

@property (nonatomic, strong) UIButton    *settingButton;

@property (nonatomic, strong) UITableView *tableView;

@property (nonatomic, strong) NSArray     *sectionImageNameArray;
@property (nonatomic, strong) NSArray     *sectionTitleArray;

@end

@implementation BEMenuSectionView

- (id)initWithFrame:(CGRect)frame
{
    self = [super initWithFrame:frame];
    if (self) {
        
        self.sectionImageNameArray = @[@"section_nodes",@"section_categories", @"section_latest", @"section_categories", @"section_fav"];
        self.sectionTitleArray = @[@"每日一句",@"阅读", @"翻译", @"单词本", @"收藏"];
        
        [self configureTableView];
        [self configureProfileView];
        [self configureBottomView];
        [self configureNotifications];
        
    }
    return self;
}

- (void)dealloc {
    [[NSNotificationCenter defaultCenter] removeObserver:self];
}

- (void)configureTableView {
    
    self.tableView                 = [[UITableView alloc] initWithFrame:CGRectZero];
    self.tableView.backgroundColor = [UIColor clearColor];
    self.tableView.separatorStyle  = UITableViewCellSeparatorStyleNone;
    self.tableView.delegate        = self;
    self.tableView.dataSource      = self;
    self.tableView.bounces = NO;
    //    self.tableView.contentInsetTop = (ScreenHeight - 44 * self.sectionTitleArray.count) / 2;
    self.tableView.contentInsetTop = 120;
    [self addSubview:self.tableView];
}

- (void)configureProfileView {
    
    self.avatarImageView                    = [[UIImageView alloc] initWithImage:[UIImage imageNamed:@"avatar_default"]];
    self.avatarImageView.contentMode        = UIViewContentModeScaleAspectFill;
    self.avatarImageView.clipsToBounds      = YES;
    self.avatarImageView.layer.cornerRadius = kAvatarHeight / 2;
    self.avatarImageView.layer.borderWidth  = 1.0f;
    self.avatarImageView.layer.borderColor  = [UIColor BEHighLightFontColor].CGColor;
    self.avatarImageView.alpha              = 0.8;
    [self addSubview:self.avatarImageView];
    
    self.avatarButton = [UIButton buttonWithType:UIButtonTypeCustom];
    [self.avatarButton addTarget:self action:@selector(showLoginViewController) forControlEvents:UIControlEventTouchUpInside];
    [self addSubview:self.avatarButton];
    
    self.divideImageView = [[UIImageView alloc] init];
    self.divideImageView.backgroundColor = [UIColor BEHighLightFontColor];
    self.divideImageView.contentMode = UIViewContentModeScaleAspectFill;
    self.divideImageView.image = [UIImage imageNamed:@"section_divide"];
    self.divideImageView.clipsToBounds = YES;
    [self addSubview:self.divideImageView];
    
}

- (void)configureBottomView {
    self.settingButton = [UIButton buttonWithType:UIButtonTypeCustom];
    self.settingButton.adjustsImageWhenHighlighted = YES;
    UIImage *image = [UIImage imageNamed:@"icon_setting"];
    [self.settingButton setImage:[image imageWithTintColor:[UIColor BEDeepFontColor]] forState:UIControlStateNormal];
    [self.settingButton setImage:[image imageWithTintColor:[UIColor BEHighLightFontColor]] forState:UIControlStateHighlighted];
    [self.settingButton addTarget:self action:@selector(showSettingViewController) forControlEvents:UIControlEventTouchUpInside];

    [self addSubview:self.settingButton];
}

- (void)showSettingViewController {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowSettingVCNotification object:nil];
}

- (void)showLoginViewController {
    [[NSNotificationCenter defaultCenter] postNotificationName:kShowLoginVCNotification object:nil];
}

- (void)configureNotifications {

}

#pragma mark - Layout

- (void)layoutSubviews {
    
    //    CGFloat spaceHeight = (self.tableView.contentInsetTop - kAvatarHeight) / 3.0;
    self.avatarImageView.frame = (CGRect){30, 30, kAvatarHeight, kAvatarHeight};
//    self.avatarButton.frame = self.avatarImageView.frame;
    
    self.avatarButton.frame = (CGRect){0, 0, self.width, 120};

    
    //    self.divideImageView.frame = (CGRect){80, kAvatarHeight + 50, 80, 0.5};
    self.divideImageView.frame = (CGRect){-self.width, kAvatarHeight + 50, self.width * 2, 0.5};
    self.tableView.frame = (CGRect){0, 0, self.width, self.height};
    self.settingButton.frame = (CGRect){20, ScreenHeight - 40, 25, 25};
    
    [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:0 inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
}

#pragma mark - Setters

- (void)setSelectedIndex:(NSInteger)selectedIndex {
    
    if (selectedIndex < self.sectionTitleArray.count) {
        _selectedIndex = selectedIndex;
        
        [self.tableView selectRowAtIndexPath:[NSIndexPath indexPathForRow:selectedIndex inSection:0] animated:NO scrollPosition:UITableViewScrollPositionNone];
    }
}

- (void)scrollViewDidScroll:(UIScrollView *)scrollView {
    CGFloat offsetY = - scrollView.contentOffsetY;
    
    //    CGFloat spaceHeight = (self.tableView.contentInsetTop - kAvatarHeight) / 3.0;
    
    self.avatarImageView.y = 30 - (scrollView.contentInsetTop - offsetY) / 1.7;
    self.avatarButton.frame = self.avatarImageView.frame;
    
    self.divideImageView.y = self.avatarImageView.y + kAvatarHeight + (offsetY - (self.avatarImageView.y + kAvatarHeight)) / 2.0 + fabsf(offsetY - self.tableView.contentInsetTop)/self.tableView.contentInsetTop * 8.0 + 10;
}

#pragma mark - TableViewDelegate
- (NSInteger)numberOfSectionsInTableView:(UITableView *)tableView {
    return 1;
}

- (NSInteger)tableView:(UITableView *)tableView numberOfRowsInSection:(NSInteger)section {
    return self.sectionTitleArray.count;
}

- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    return [self heightCellForIndexPath:indexPath];
}

- (UITableViewCell *)tableView:(UITableView *)tableView cellForRowAtIndexPath:(NSIndexPath *)indexPath {
    
    static NSString *CellIdentifier = @"CellIdentifier";
    BEMenuSectionCell *cell = (BEMenuSectionCell *)[tableView dequeueReusableCellWithIdentifier:CellIdentifier];
    if (!cell) {
        cell = [[BEMenuSectionCell alloc] initWithStyle:UITableViewCellStyleDefault reuseIdentifier:CellIdentifier];
    }
    
    return [self configureWithCell:cell IndexPath:indexPath];
}

- (void)tableView:(UITableView *)tableView didSelectRowAtIndexPath:(NSIndexPath *)indexPath {
    
    if (self.didSelectedIndexBlock) {
        self.didSelectedIndexBlock(indexPath.row);
    }
}

#pragma mark - Configure TableCell

- (CGFloat)heightCellForIndexPath:(NSIndexPath *)indexPath {
    
    return [BEMenuSectionCell getCellHeight];
}

- (BEMenuSectionCell *)configureWithCell:(BEMenuSectionCell *)cell IndexPath:(NSIndexPath *)indexPath {
    
    cell.imageName = self.sectionImageNameArray[indexPath.row];
    cell.title     = self.sectionTitleArray[indexPath.row];
    cell.badge = nil;
    //cell.accessoryType = UITableViewCellAccessoryDisclosureIndicator;
    return cell;
}

@end