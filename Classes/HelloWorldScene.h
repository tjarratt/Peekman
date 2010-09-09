
// When you import this file, you import all the cocos2d classes
#import "cocos2d.h"

// HelloWorld Layer
@interface HelloWorld : CCLayer
{
	CCSprite* hero;
	CGPoint destination;
	
	NSMutableArray *peeks;
	
	CCSprite* callBtn;
	
}

@property (retain) NSMutableArray *peeks;

// returns a Scene that contains the HelloWorld as the only child
+(id) scene;

-(BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event;
-(BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event;
-(BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event;

@end
