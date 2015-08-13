//
//  MainScence.m
//  Breakout
//
//  Created by mac on 8/1/15.
//  Copyright (c) 2015 mac. All rights reserved.
//

#import "MainScence.h"
#import "Level.h"
#import "Brick.h"

@interface MainScence() {
    NSTimer *_timer;
    CGFloat _vX;
    CGFloat _vY;
    double time;
    BOOL start;
    BOOL gameover;
    int countHitBrick;
    
    CGSize ballSize;
    CGFloat ballRadius;
    CGFloat barHalfWidth;
    CGFloat screenHeight, screenWidth;
    CGFloat brickWidth, brickHeight;
    CGRect originalBarFrame, originalBallFrame;
    
    Level *level;
    NSMutableArray *bricks;
    
    AVAudioPlayer *audioPlayer;
    SystemSoundID touchBrick;
    SystemSoundID die;
    SystemSoundID victory;
    
    int totalScore;
}

@property (weak, nonatomic) IBOutlet UIImageView *ball;
@property (weak, nonatomic) IBOutlet UIImageView *bar;
@property (weak, nonatomic) IBOutlet UILabel *mScore;

@end

@implementation MainScence

- (void) viewDidLoad {
    
    //[self initData];
    ballSize = self.ball.bounds.size;
    ballRadius = ballSize.width * 0.5;
    barHalfWidth = self.bar.bounds.size.width * 0.5;
    screenHeight = self.view.bounds.size.height;
    screenWidth = self.view.bounds.size.width;
    
    [self.bar addGestureRecognizer:[[UIPanGestureRecognizer alloc] initWithTarget:self
                                                                           action:@selector(onDragBar:)]];
    originalBallFrame = self.ball.frame;
    originalBarFrame = self.bar.frame;
    [self setUpVariables];
    [self setupLevel];
    [self createBricks];
    [self setupSound];
}

- (void) updateLabel: (NSString *) score
{
    self.mScore.text = [NSString stringWithFormat:@"%d", totalScore];
}

- (void) setUpVariables{
    gameover = false;
    start = false;
    countHitBrick = 0;
    touchBrick = 0;
    die = 0;
    victory = 0;
    totalScore = 0;
    
    bricks = [[NSMutableArray alloc] init];
    
    //Configure default velocity. Need to randomize it
    _vX = 0.1 + ((CGFloat)(arc4random_uniform(30)) - 15.0) / 10.0;
    _vX = fabs(_vX) < 0.5 ? -1.5: _vX;
    _vY = -1.0 - (CGFloat)((float)(arc4random_uniform(20)) / 10.0);
    
    time = 0.01;
    if (bricks.count > 0) {
        
        for (Brick *brick in bricks) {
            [brick removeFromSuperview];
        }
        
        [bricks removeAllObjects];
    }
}
- (void) setupLevel {
    NSArray *map = @[@1, @1, @2, @1, @2,
                    @2, @3, @3, @2, @1,
                    @2, @3, @3, @2, @1,
                    @2, @3, @3, @2, @3,
                    @1, @2, @1, @3, @3,
                    @1, @1, @1, @1, @2,
                    @1, @1, @1, @1, @3,
                    @1, @3, @2, @1 , @1];
    
    level = [[Level alloc] initWithCols:5 andRows:8 andMap:map];
}

- (void) createBricks {
    CGFloat topBrickWall = 35;
    CGFloat hMargin = 8;
    CGFloat vMargin = 25; // >= brickHeight
    
    brickWidth = (screenWidth - (CGFloat)(level.columns + 1) * hMargin) / (CGFloat)(level.columns);
    brickHeight = 10;
    
    for (int i = 0; i < level.rows; i++) {
        for (int j = 0; j < level.columns; j++) {
            
            
            CGRect brickFrame = CGRectMake(hMargin * (CGFloat)(j+1) + brickWidth * (CGFloat)(j) ,
                                           topBrickWall + (CGFloat)(i) * vMargin,
                                           brickWidth,
                                           brickHeight);
            
            Brick *brick = [[Brick alloc] initWithFrame:brickFrame];
            int score =  [level.map[i * level.columns + j] intValue];
            NSLog(@"%d",score);
            //brick.score = level.map[i * level.columns + j] ;
            brick.score = score;
            //[brick addScore:score];
            
            NSLog(@"createBricks: %d", brick.score);
            
            [bricks addObject:brick];
            [self.view addSubview:brick];
        
            
        }
    }

}

-(void) setupSound {
    NSBundle *mainBundle = [NSBundle mainBundle];
    // Background music
    NSString *soundFilePath = [mainBundle pathForResource:@"soundBackground" ofType:@"mp3"];
    audioPlayer = [[AVAudioPlayer alloc] initWithContentsOfURL:[NSURL fileURLWithPath:soundFilePath]
                                                          error:nil];
    
    audioPlayer.delegate = self;
    audioPlayer.numberOfLoops = -1;
    [audioPlayer play];
    
    //âm thanh trong game
    NSURL *soundX = [NSURL fileURLWithPath:[mainBundle pathForResource:@"touchBrick" ofType:@"wav"]];
    AudioServicesCreateSystemSoundID((__bridge CFURLRef)soundX, &touchBrick);
    
}



- (void) animate: (NSTimer*) theTimer {
    CGFloat newX = self.ball.center.x + _vX;
    CGFloat newY = self.ball.center.y + _vY;
    if (newX < ballRadius || newX > self.view.bounds.size.width  - ballRadius) {
        //Đập tường trái, phải
        _vX = -_vX;
    }
    
    if (newY < ballRadius) {
        //Đập trên cùng
        _vY = -_vY;
    }
    
    // newY > self.view.bounds.size.height - ballRadius
//    if (newY > self.bar.frame.origin.y + ballRadius) {
//        
//    }
    
    // newY  > self.view.bounds.size.height - ballRadius
    if (newY  > self.view.bounds.size.height - ballRadius) {
        // dap vao tuong duoi gameover
        self.ball.hidden = true;
        gameover = true;
        [_timer invalidate];
        _timer = nil;
        
        [self showResult];
        return;
    }
    if  ((newX <= self.bar.center.x + barHalfWidth) &&
        (newX >= self.bar.center.x - barHalfWidth) &&
        (_vY > 0) &&
        (newY + ballRadius >= self.bar.center.y - self.bar.bounds.size.height * 0.5) ) {
            _vY = -_vY;
            _vX = _vX * 1.1;
        }
    
    newX = self.ball.center.x + _vX;
    newY = self.ball.center.y + _vY;
    
    self.ball.center = CGPointMake(newX, newY);
    [self ballCollideBricks];
}

- (void) ballCollideBricks {
    
    if (countHitBrick == bricks.count) { // đập hết gạch
        [_timer invalidate];
        _timer = nil;
        gameover = false;
        [self showResult];
    }
    
    for (Brick *brick in bricks) {
        if ( brick.score == 0)
        {
            continue;
        }
        
        CGRect brickRect = brick.frame;
        CGRectInset(brickRect, -ballRadius, -ballRadius);
    
         if (CGRectContainsPoint(brickRect, self.ball.center)) {
           NSLog(@"%d",brick.score);
             
//        if (CGRectIntersectsRect(brickRect, self.ball.frame)) {
            AudioServicesPlaySystemSound(touchBrick);
            _vY = -_vY;
             //brick removeFromSuperview];
             brick.score = brick.score - 1;
             //[brick addScore:brick.score -1];
            
            NSLog(@"ballCollideBricks: %d", brick.score);
            
            if (brick.score == 0) {
                
               // brick viewWithTag:<#(NSInteger)#>
                countHitBrick = countHitBrick + 1;
                totalScore ++;
                
                NSString *strValue = [NSString stringWithFormat:@"%d", totalScore];
                self.mScore.text = strValue;
               
                
                //Fun logic when countHitBrick increase, increase velocity
//                CGFloat oneThirdBrickCounts = (CGFloat)(bricks.count) * 0.3;
//                if (countHitBrick > (int)(oneThirdBrickCounts) ) {
//                    CGFloat increase = sqrt((CGFloat)(countHitBrick) / oneThirdBrickCounts);
//                    _vX = _vX * increase;
//                    _vY = _vY * increase;
//                }

            }
        }
        
    }
    
}

- (void) showResult {
    NSLog(@"Game over");
    
    [audioPlayer pause];
    if (gameover) {
        UIAlertController *alert = [UIAlertController alertControllerWithTitle:@"Game over"
                                                                       message:@"To continue playing, hit 'Play Again"
                                                                preferredStyle:UIAlertControllerStyleAlert];
        
        UIAlertAction *continuePlayAction = [UIAlertAction
                                             actionWithTitle:@"Play again"
                                             style:UIAlertActionStyleDefault
                                             handler:^(UIAlertAction * action)
                                             {
                                                 [self resetGame];
                                                 
                                             }];
        
        
        UIAlertAction* cancelAction = [UIAlertAction
                                 actionWithTitle:@"End Game"
                                 style:UIAlertActionStyleDefault
                                 handler:^(UIAlertAction * action)
                                 {
                                     [alert dismissViewControllerAnimated:YES completion:nil];
                                     
                                 }];
        
        
        [alert addAction:continuePlayAction];
        [alert addAction:cancelAction];
        [self presentViewController:alert animated:YES completion:nil];
        
    } else {
        UIAlertView *alert = [[UIAlertView alloc] initWithTitle:@"Congratulation"
                                                    message:@"Victory"
                                                    delegate: self
                                                    cancelButtonTitle:@"OK"
                                                otherButtonTitles:nil];
        
        
        [alert show];
    }
    
}

- (void) onDragBar: (UIPanGestureRecognizer*) gestureRecognizer{
    start = true;
    
    if (start) { //di chuyển thanh hứng thì mới bắt đầu
        if (_timer == nil) {
        _timer = [NSTimer scheduledTimerWithTimeInterval:((NSTimeInterval)time)
                                                  target:self
                                                selector:@selector(animate:)
                                                userInfo:nil
                                                 repeats:true];
            
       }
        
        if ( ([gestureRecognizer state] == UIGestureRecognizerStateBegan) ||
            ([gestureRecognizer state] == UIGestureRecognizerStateChanged) ) {
            
            UIView *piece = gestureRecognizer.view;
            CGPoint translation = [gestureRecognizer translationInView:[piece superview]];
            
            CGFloat width = piece.bounds.size.width;
            //CGSize mainSize = self.view.bounds.size;
            
//            if (piece.center.x + translation.x < width/2 ) {
//              piece.center = CGPointMake(width/2, piece.center.y);
//            } else {
//                
//            }
            
            piece.center = CGPointMake(piece.center.x + translation.x, piece.center.y);
        
            //NSLog(@"piece x = %f, piece y = %f", piece.center.x, piece.center.y);
            [gestureRecognizer setTranslation:CGPointZero inView:piece.superview];
        }
        
    }
    
}


-(void) resetGame {
    //[bricks removeAllObjects];
    for (Brick *brick in bricks) {
        [brick removeFromSuperview];
    }
   
    self.ball.frame = originalBallFrame;
    self.ball.hidden = false;
    self.bar.frame = originalBarFrame;
    totalScore = 0;
    
    [self setUpVariables];
    [self setupLevel];
    [self createBricks];
    [self setupSound];
}


@end
