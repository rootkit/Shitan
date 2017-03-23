//
//  BubbleView.m
//  Shitan
//
//  Created by 刘敏 on 14-10-18.
//  Copyright (c) 2014年 深圳食探网络科技有限公司. All rights reserved.
//

#import "BubbleView.h"
#import "UIView+FrameMethods.h"

@interface BubbleView ()

@property (nonatomic, strong) UIImageView *point;
@property (nonatomic, strong) UIImageView *bubuleV;
@property (nonatomic, strong) UILabel *textL;

@property (nonatomic, assign) CGPoint startPoint;
@property (nonatomic, assign) NSInteger m_direction;

@end

@implementation BubbleView


/**
 *  初始化BubbleView 发布时使用
 */
- (void)initializeBubbleView{
    
    self.userInteractionEnabled = YES;
    
    
    UIImage *bubble = _startPoint.x > MAINSCREEN.size.width/2 ? [UIImage imageNamed:@"icon_bubble_right.png"]:[UIImage imageNamed:@"icon_bubble.png"];
    
    CGPoint center = CGPointMake(bubble.size.width / 2.0f, bubble.size.height / 2.0f);
    
    UIEdgeInsets capInsets = UIEdgeInsetsMake(center.y + 10, center.x, center.y - 10, center.x);

    
    CGFloat m_width = [self calculateDesLabelheight:_tipName] > (MAINSCREEN.size.width/2 + 20) ? (MAINSCREEN.size.width/2 + 10):[self calculateDesLabelheight:_tipName];
    
    // 标签图片
    _point = [[UIImageView alloc] init];
    
    // 气泡框
    _bubuleV = [[UIImageView alloc] initWithImage:[bubble resizableImageWithCapInsets:capInsets]];
    
    // 文字
    _textL = [[UILabel alloc] init];
    _textL.text = _tipName;
    _textL.backgroundColor = [UIColor clearColor];
    _textL.textColor = [UIColor whiteColor];
    _textL.font = [UIFont systemFontOfSize:12.0];
    
    if (_startPoint.x > MAINSCREEN.size.width/2) {
        //气泡框在左边
        _bubuleV.frame = CGRectMake(0, 0, m_width+18, 26);
        _textL.frame = CGRectMake(5, 0, m_width, 26);
        _point.frame = CGRectMake(m_width+18, 7, 13, 13);

        if (_tipType == Tip_FoodN) {
            _point.layer.contents = (id)[UIImage imageNamed:@"food_point.png"].CGImage;
        }
        else if (_tipType == Tip_Location){
            _point.layer.contents = (id)[UIImage imageNamed:@"place_point.png"].CGImage;
        }
        else if (_tipType == Tip_Normal)
        {
            _point.layer.contents = (id)[UIImage imageNamed:@"tip_point.png"].CGImage;
        }
        
        
        //左边为YES，右边为NO
        _isLeft = YES;
        
    }
    else{
        /**********************  起泡框在右边  ************************/
        
        _bubuleV.frame = CGRectMake(12, 0, m_width+18, 26);
        _textL.frame = CGRectMake(24, 0, m_width, 26);
        _point.frame = CGRectMake(0, 7, 13, 13);
        
        if (_tipType == Tip_FoodN) {
            _point.layer.contents = (id)[UIImage imageNamed:@"food_point.png"].CGImage;
        }
        else if (_tipType == Tip_Location){
            _point.layer.contents = (id)[UIImage imageNamed:@"place_point.png"].CGImage;
        }
        else if (_tipType == Tip_Normal)
        {
            _point.layer.contents = (id)[UIImage imageNamed:@"tip_point.png"].CGImage;
        }

        _isLeft = NO;
    }
    
    [self addSubview:_bubuleV];
    [self addSubview:_point];
    [self addSubview:_textL];
    
    //脉冲效果
    _halo = [PulsingHaloLayer layer];
    _halo.position = _point.center;
    [self.layer insertSublayer:_halo below:_point.layer];
}



/**
 *  初始化BubbleView 动态详情中使用
 */
- (void)initializeNormalBubbleView{
    
    self.userInteractionEnabled = YES;
    
    UIImage *bubble = _m_direction == 1 ? [UIImage imageNamed:@"icon_bubble_right.png"]:[UIImage imageNamed:@"icon_bubble.png"];
    
    CGPoint center = CGPointMake(bubble.size.width / 2.0f, bubble.size.height / 2.0f);
    UIEdgeInsets capInsets = UIEdgeInsetsMake(center.y + 10, center.x, center.y - 10, center.x);
    
    CGFloat m_width = [self calculateDesLabelheight:_tipName] > (MAINSCREEN.size.width/2 + 20) ? (MAINSCREEN.size.width/2 + 10):[self calculateDesLabelheight:_tipName];
    
    // 标签图片
    _point = [[UIImageView alloc] init];
    
    // 气泡框
    _bubuleV = [[UIImageView alloc] initWithImage:[bubble resizableImageWithCapInsets:capInsets]];
    
    // 文字
    _textL = [[UILabel alloc] init];
    _textL.text = _tipName;
    _textL.backgroundColor = [UIColor clearColor];
    _textL.textColor = [UIColor whiteColor];
    _textL.font = [UIFont systemFontOfSize:12.0];
    
    
    if (_m_direction == 1) {
        //气泡框在左边
        _bubuleV.frame = CGRectMake(0, 0, m_width+18, 26);
        _textL.frame = CGRectMake(5, 0, m_width, 26);
        _point.frame = CGRectMake(m_width+18, 7, 13, 13);
        
        if (_tipType == Tip_FoodN) {
            _point.layer.contents = (id)[UIImage imageNamed:@"food_point.png"].CGImage;
        }
        else if (_tipType == Tip_Location){
            _point.layer.contents = (id)[UIImage imageNamed:@"place_point.png"].CGImage;
        }
        else if (_tipType == Tip_Normal)
        {
            _point.layer.contents = (id)[UIImage imageNamed:@"tip_point.png"].CGImage;
        }
        
    }
    else if (_m_direction == 0){
        /**********************  起泡框在右边  ************************/
        
        _bubuleV.frame = CGRectMake(12, 0, m_width+18, 26);
        _textL.frame = CGRectMake(24, 0, m_width, 26);
        _point.frame = CGRectMake(0, 7, 13, 13);
        
        if (_tipType == Tip_FoodN) {
            _point.layer.contents = (id)[UIImage imageNamed:@"food_point.png"].CGImage;
        }
        else if (_tipType == Tip_Location){
            _point.layer.contents = (id)[UIImage imageNamed:@"place_point.png"].CGImage;
        }
        else if (_tipType == Tip_Normal)
        {
            _point.layer.contents = (id)[UIImage imageNamed:@"tip_point.png"].CGImage;
        }
        
        _isLeft = NO;
    }
    
    
    [self addSubview:_bubuleV];
    [self addSubview:_point];
    [self addSubview:_textL];

    //脉冲效果
    _halo = [PulsingHaloLayer layer];
    _halo.position = _point.center;
    [self.layer insertSublayer:_halo below:_point.layer];
}



/**
 *  创建BubbleView  （发布时使用）
 *
 *  @param frame  位置、大小
 *  @param title  标题
 *  @param mPoint 坐标点
 *  @param isMark 类型（为真为常规标签、否则为地点标签）
 *
 *  @return BubbleView
 */
- (instancetype)initWithFrame:(CGRect)frame initWithTitle:(NSString *)title
         startPoint:(CGPoint)mPoint tipType:(MYTipsType)tipType
{
    self = [super initWithFrame:frame];
    
    _startPoint = mPoint;
    _tipType = tipType;
    _tipName = title;
    _isMove = YES;
    
    if (self) {
       
        [self initializeBubbleView];
        
        /********************************    单击手势    ***********************************/
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(turnAroundTip:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        
        //开启触摸事件响应
        [self addGestureRecognizer:tapGesture];
        
        
        /********************************    长按手势    ***********************************/
        //实例化长按手势监听
        UILongPressGestureRecognizer *longPress =
        [[UILongPressGestureRecognizer alloc] initWithTarget:self
                                                      action:@selector(handleTableviewCellLongPressed:)];
        
        longPress.minimumPressDuration = 0.8;
        //将长按手势添加到需要实现长按操作的视图里
        [self addGestureRecognizer:longPress];
        
        //坐标校正
        [self refreshSubviews];
        
    }
    return self;
}

/**
 *  创建BubbleView   (动态时使用)
 *
 *  @param frame  位置、大小
 *  @param info   标签信息
 *  @param mPoint 修正后的坐标
 *
 *  @return BubbleView
 */
- (instancetype)initWithFrame:(CGRect)frame initWithInfo:(TipInfo *)info
{
    self = [super initWithFrame:frame];
    
    _startPoint = CGPointMake(frame.origin.x, frame.origin.y);
    _tipType = info.tipType;
    _tipName = info.title;
    _m_direction = info.isLeft;
    _tipID = info.tagId;
    
    _isMove = NO;
    
    self.userInteractionEnabled = YES;
    
    if (self) {
        
        [self initializeNormalBubbleView];
        
        /********************************    单击手势    ***********************************/
        UITapGestureRecognizer *tapGesture = [[UITapGestureRecognizer alloc] initWithTarget:self action:@selector(clickBubbleViewTapped:)];
        tapGesture.numberOfTapsRequired = 1;
        tapGesture.numberOfTouchesRequired = 1;
        
        //开启触摸事件响应
        [self addGestureRecognizer:tapGesture];
        
        /**********************************************************/
        
        //坐标校正
        [self refreshSubviews];
        
    }
    
    return self;

}


//校正方向
- (void)correctionDirection
{
    UIImage *bubble = nil;
    
    if (_m_direction == 0) {
        //右边
        bubble = [UIImage imageNamed:@"icon_bubble.png"];
        [_bubuleV setFrame:CGRectMake(12, 0, _bubuleV.frame.size.width, _bubuleV.frame.size.height)];
        [_textL setFrame:CGRectMake(24, 0, _textL.frame.size.width, _textL.frame.size.height)];
        

        _point.frame = CGRectMake(0, 7, 13, 13);
    }
    else if (_m_direction == 1){
        
        //左边
        bubble = [UIImage imageNamed:@"icon_bubble_right.png"];
        
        [_bubuleV setFrame:CGRectMake(0, 0, _bubuleV.frame.size.width, _bubuleV.frame.size.height)];
        [_textL setFrame:CGRectMake(5, 0, _textL.frame.size.width, _textL.frame.size.height)];
        
        
        [_point setFrame:CGRectMake(_bubuleV.frame.size.width, 7, 13, 13)];

    }
    
    CGPoint center = CGPointMake(bubble.size.width / 2.0f, bubble.size.height / 2.0f);
    UIEdgeInsets capInsets = UIEdgeInsetsMake(center.y + 10, center.x, center.y - 10, center.x);
    
    // 气泡框
    [_bubuleV setImage:[bubble resizableImageWithCapInsets:capInsets]];
    
    _halo.position = _point.center;
    [self.layer insertSublayer:_halo below:_point.layer];
}


- (CGFloat)calculateDesLabelheight:(NSString *)text
{
    UIFont *font = [UIFont systemFontOfSize:12.0];
    //设置一个行高上限
    CGSize size = CGSizeMake(20000, 26);
    
    //TODO:需要ios7以上才能使用
    NSDictionary * tdic = [NSDictionary dictionaryWithObjectsAndKeys:font, NSFontAttributeName,nil];
    size =[text boundingRectWithSize:size options:NSStringDrawingUsesLineFragmentOrigin |NSStringDrawingUsesFontLeading attributes:tdic context:nil].size;
    
    return size.width;
}



- (void)touchesBegan:(NSSet *)touches withEvent:(UIEvent *)event
{
    //保存触摸起始点位置
    CGPoint point = [[touches anyObject] locationInView:self];
    _startPoint = point;
    
    //该view置于最前
    [[self superview] bringSubviewToFront:self];
}


- (void)touchesMoved:(NSSet *)touches withEvent:(UIEvent *)event
{
    if (_isMove) {
        //计算位移=当前位置-起始位置
        CGPoint point = [[touches anyObject] locationInView:self];
        float dx = point.x - _startPoint.x;
        float dy = point.y - _startPoint.y;
        
        //计算移动后的view中心点
        CGPoint newcenter = CGPointMake(self.center.x + dx, self.center.y + dy);
        
        
        /* 限制用户不可将视图托出屏幕 */
        float halfx = CGRectGetMidX(self.bounds);
        //x坐标左边界
        newcenter.x = MAX(halfx, newcenter.x);
        //x坐标右边界
        newcenter.x = MIN(self.superview.bounds.size.width - halfx, newcenter.x);
        
        //y坐标同理
        float halfy = CGRectGetMidY(self.bounds);
        newcenter.y = MAX(halfy, newcenter.y);
        newcenter.y = MIN(self.superview.bounds.size.height - halfy, newcenter.y);
        
        //移动view
        self.center = newcenter;
    }
}


//调转左右方向
- (void)turnAroundTip:(UITapGestureRecognizer *)sender
{
    if (sender.state == UIGestureRecognizerStateBegan) {
        CLog(@"UIGestureRecognizerStateBegan");
    }
    
    if (sender.state == UIGestureRecognizerStateChanged) {
        CLog(@"UIGestureRecognizerStateChanged");
    }
    
    if (sender.state == UIGestureRecognizerStateEnded) {
        CLog(@"UIGestureRecognizerStateEnded");
        
        UIImage *bubble = nil;
        
        if (_isLeft) {
            bubble = [UIImage imageNamed:@"icon_bubble.png"];
            [_bubuleV setFrame:CGRectMake(12, 0, _bubuleV.frame.size.width, _bubuleV.frame.size.height)];
            [_textL setFrame:CGRectMake(24, 0, _textL.frame.size.width, _textL.frame.size.height)];
            

            _point.frame = CGRectMake(0, 7, 13, 13);

        }
        else{
            bubble = [UIImage imageNamed:@"icon_bubble_right.png"];
            
            [_bubuleV setFrame:CGRectMake(0, 0, _bubuleV.frame.size.width, _bubuleV.frame.size.height)];
            [_textL setFrame:CGRectMake(5, 0, _textL.frame.size.width, _textL.frame.size.height)];

            [_point setFrame:CGRectMake(_bubuleV.frame.size.width, 7, 13, 13)];
            
        }
        
        CGPoint center = CGPointMake(bubble.size.width / 2.0f, bubble.size.height / 2.0f);
        UIEdgeInsets capInsets = UIEdgeInsetsMake(center.y + 10, center.x, center.y - 10, center.x);
        
        // 气泡框
        [_bubuleV setImage:[bubble resizableImageWithCapInsets:capInsets]];
        
        _halo.position = _point.center;
        [self.layer insertSublayer:_halo below:_point.layer];
        
        
        _isLeft = !_isLeft;
    }
}


//长按事件的实现方法(删除当前标签)
- (void)handleTableviewCellLongPressed:(UILongPressGestureRecognizer *)gestureRecognizer
{
    if (gestureRecognizer.state ==
        UIGestureRecognizerStateBegan) {
        CLog(@"UIGestureRecognizerStateBegan");
        
        NSString *POTagID = [theAppDelegate.PODict objectForKey:@"TAGID"];
        
        if ([_tipID isEqualToString:POTagID]) {
            return;
        }
        
        //删除标签
        if (_delegate && [_delegate respondsToSelector:@selector(deleteBubbleView:)]) {
            [_delegate deleteBubbleView:self.tag];
        }
    }
    if (gestureRecognizer.state ==
        UIGestureRecognizerStateChanged) {
        CLog(@"UIGestureRecognizerStateChanged");
    }
    
    if (gestureRecognizer.state == UIGestureRecognizerStateEnded) {
        CLog(@"UIGestureRecognizerStateEnded");

    }
}


//查看标签详情
- (void)clickBubbleViewTapped:(UITapGestureRecognizer *)sender
{
    
    CLog(@"%ld", (long)sender.view.tag);
    
    if (_delegate && [_delegate respondsToSelector:@selector(clickBubbleViewWithInfo:)]) {
        [_delegate clickBubbleViewWithInfo:sender.view.tag];
    }
}


// 重新绘制
- (void)refreshSubviews {
    
    CGFloat m_width = _bubuleV.bounds.size.width + 11;
    
    if (_startPoint.x > MAINSCREEN.size.width/2) {
        //气泡框在左边
        m_width = m_width > _startPoint.x ? _startPoint.x : m_width;
        
    }
    else{
        //气泡框在右边
        m_width = m_width > (MAINSCREEN.size.width - _startPoint.x) ? (MAINSCREEN.size.width - _startPoint.x):m_width;
    }
    
    [_bubuleV setWidth:m_width - 12];
    [_textL setWidth:m_width - 24];
    
    [self setWidth:m_width];
}

@end
