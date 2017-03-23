//
//  DynamicMode.h
//  Shitan
//
//  Created by 刘敏 on 15/2/8.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import <Foundation/Foundation.h>
#import <CoreData/CoreData.h>

@class CommentModel, PraiseModel, ShopModel, TipModel;

@interface DynamicMode : NSManagedObject

@property (nonatomic, retain) NSString * city;
@property (nonatomic, retain) NSNumber * commentCount;
@property (nonatomic, retain) NSString * createTime;
@property (nonatomic, retain) NSNumber * hasFollowTheAuthor;
@property (nonatomic, retain) NSNumber * hasPraiseTheImg;
@property (nonatomic, retain) NSNumber * m_Id;
@property (nonatomic, retain) NSString * imgCategory;
@property (nonatomic, retain) NSString * imgDesc;
@property (nonatomic, retain) NSNumber * imgHeight;
@property (nonatomic, retain) NSString * imgId;
@property (nonatomic, retain) NSString * imgUrl;
@property (nonatomic, retain) NSNumber * imgWidth;
@property (nonatomic, retain) NSNumber * latitude;
@property (nonatomic, retain) NSNumber * longitude;
@property (nonatomic, retain) NSString * nickname;
@property (nonatomic, retain) NSString * portraitUrl;
@property (nonatomic, retain) NSNumber * praiseCount;
@property (nonatomic, retain) NSNumber * score;
@property (nonatomic, retain) NSString * snsPlatform;
@property (nonatomic, retain) NSNumber * status;
@property (nonatomic, retain) NSString * userId;
@property (nonatomic, retain) NSString * addressId;
@property (nonatomic, retain) NSString * userType;

@property (nonatomic, retain) ShopModel *shopInfo;

@property (nonatomic, retain) NSSet *commenters;
@property (nonatomic, retain) NSSet *praisers;
@property (nonatomic, retain) NSSet *tags;

@end

@interface DynamicMode (CoreDataGeneratedAccessors)


- (void)addCommentersObject:(CommentModel *)value;
- (void)removeCommentersObject:(CommentModel *)value;
- (void)addCommenters:(NSSet *)values;
- (void)removeCommenters:(NSSet *)values;

- (void)addPraisersObject:(PraiseModel *)value;
- (void)removePraisersObject:(PraiseModel *)value;
- (void)addPraisers:(NSSet *)values;
- (void)removePraisers:(NSSet *)values;

- (void)addTagsObject:(TipModel *)value;
- (void)removeTagsObject:(TipModel *)value;
- (void)addTags:(NSSet *)values;
- (void)removeTags:(NSSet *)values;

@end
