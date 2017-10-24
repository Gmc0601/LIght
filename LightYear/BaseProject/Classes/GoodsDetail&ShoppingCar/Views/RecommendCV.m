//
//  RecommendCV.m
//  BaseProject
//
//  Created by LeoGeng on 13/09/2017.
//  Copyright © 2017 cc. All rights reserved.
//

#import "RecommendCV.h"
#import "RecommendCell.h"
#import <Masonry/Masonry.h>

@interface RecommendCV()<UICollectionViewDelegate,UICollectionViewDataSource>
@property(retain,atomic) NSArray *datasource;
@property(retain,atomic) UICollectionView *cv;
@end

@implementation RecommendCV

- (instancetype)init
{
    self = [super init];
    if (self) {
        [self addCV];
    }
    return self;
}

-(void) setDataSource:(NSArray *) dataSource{
    _datasource = dataSource;
    [_cv reloadData];
}

-(void) addCV{
    CGFloat height = SizeHeigh(250);
    UICollectionViewFlowLayout *layout = [[UICollectionViewFlowLayout alloc] init];
    layout.itemSize = CGSizeMake(SizeWidth(284/2), height);
    layout.minimumLineSpacing  = SizeWidth(32/2);
    layout.scrollDirection = UICollectionViewScrollDirectionHorizontal;
    
    _cv = [[UICollectionView alloc] initWithFrame:self.bounds collectionViewLayout:layout];
    _cv.delegate = self;
    _cv.dataSource = self;
    _cv.backgroundColor = [UIColor whiteColor];

    [_cv registerClass:[RecommendCell class] forCellWithReuseIdentifier:@"cell"];
    [self addSubview:_cv];
    
    [_cv mas_makeConstraints:^(MASConstraintMaker *make) {
        make.top.equalTo(self);
        make.left.equalTo(self);
        make.right.equalTo(self);
        make.height.equalTo(@(height));
    }];
}

-(NSInteger) numberOfSectionsInCollectionView:(UICollectionView *)collectionView{
    return 1;
}

- (NSInteger)collectionView:(UICollectionView *)collectionView numberOfItemsInSection:(NSInteger)section{
    return _datasource.count;
}

-(UICollectionViewCell *)collectionView:(UICollectionView *)collectionView cellForItemAtIndexPath:(NSIndexPath *)indexPath{
    RecommendCell *cell = (RecommendCell *)[collectionView dequeueReusableCellWithReuseIdentifier:@"cell" forIndexPath:indexPath];
    cell.model = (GoodsModel *) _datasource[indexPath.row];
    return  cell;
}
- (void)collectionView:(UICollectionView *)collectionView didSelectItemAtIndexPath:(NSIndexPath *)indexPath{
}

-(void)reload{
    [_cv reloadData];
}

@end
