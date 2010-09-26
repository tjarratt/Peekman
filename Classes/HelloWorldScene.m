//
// cocos2d Hello World example
// http://www.cocos2d-iphone.org
//

// Import the interfaces
#import "HelloWorldScene.h"
#include <stdlib.h>

// HelloWorld implementation
@implementation HelloWorld

@synthesize peeks, loopNumber, newPeeksToAdd;

+(id) scene
{
	// 'scene' is an autorelease object.
	CCScene *scene = [CCScene node];
	
	// 'layer' is an autorelease object.
	HelloWorld *layer = [HelloWorld node];
	
	// add layer as a child to scene
	[scene addChild: layer];
	
	// return the scene
	return scene;
}

// on "init" you need to initialize your instance
-(id) init
{
	// always call "super" init
	// Apple recommends to re-assign "self" with the "super" return value
	if( (self=[super init] )) {
		self.loopNumber = 0;
		// ask director the the window size
		CGSize size = [[CCDirector sharedDirector] winSize];
		newPeeksToAdd = 0;
		//jesus fuck is this ever important
		self.isTouchEnabled = YES;
		
		// create and initialize a Label
		//CCLabel* label = [CCLabel labelWithString:@"Hello World" fontName:@"Marker Felt" fontSize:64];
		CCSprite *aHero = [CCSprite spriteWithFile:@"red.png"];
		hero = aHero;
		
		NSMutableArray* thesePeeks = [[NSMutableArray alloc] init];
		peeks = thesePeeks;
		
		aHero.position = ccp(size.width / 2, size.height / 2);
		
		destination = aHero.position;
		
		// add the hero as a child to this Layer
		[self addChild: hero];
		
		CCMenuItem *starMenuItem = [CCMenuItemImage 
									itemFromNormalImage:@"ButtonStarSel.png" selectedImage:@"ButtonStar.png" 
									target:self selector:@selector(callPeeks:)];
		starMenuItem.position = ccp(size.width - 60, 60);
		CCMenu *starMenu = [CCMenu menuWithItems:starMenuItem, nil];
		starMenu.position = CGPointZero;
		[self addChild:starMenu];
		
		[NSTimer scheduledTimerWithTimeInterval: 0.05 target:self selector:@selector(gameLoop) userInfo:nil repeats:YES];
		
	}
	return self;
}

-(void)gameLoop {
	loopNumber ++;
	CGPoint current = [hero position];
	
	//conceptually, delta is a vector of the same direction, but 1/100th the magnitude
	CGPoint delta = ccp((destination.x - current.x) / 10, (destination.y - current.y) / 10);
	
	//what we want to do
	id action = [CCMoveBy actionWithDuration:0.001 position:delta];
	
	
	
	
	if ([peeks count] < 5) {
		CCSprite *peek = [CCSprite spriteWithFile:@"green.png"];
		
		CGPoint center = [hero position];
		int x = arc4random() % 250 +100;
		int y = arc4random() % 250 + 100;
		
		int flipX = arc4random() % 2;
		int flipY = arc4random() % 2;
		
		if (flipX == 1) {
			x = -x;
		}
		if (flipY == 1) {
			y = -y;
		}
		
		CGPoint newCenter = ccp(center.x + x,center.y + y);
		if (loopNumber == 300000) {
			loopNumber = 0;
		}
		peek.position = newCenter;
		
		[peeks addObject:peek];
		[self addChild:peek];
	}
	
	if (loopNumber % 20 == 0) {
		id actionCallFunc = [CCCallFunc actionWithTarget:self selector:@selector(callPeeks:)];
		
		id actionSequence = [CCSequence actions: action, actionCallFunc, nil];
		
		[hero runAction:actionSequence];
	}
	
	else {
		[hero runAction:action];
	}
	for (CCSprite *peeker in peeks) {
		CGRect peekerRect = CGRectMake(peeker.position.x - (peeker.contentSize.width/2), 
									   peeker.position.y - (peeker.contentSize.height/2), 
									   peeker.contentSize.width, 
									   peeker.contentSize.height);
		
		
		
		CGRect targetRect = CGRectMake(hero.position.x - (hero.contentSize.width/2), 
									   hero.position.y - (hero.contentSize.height/2), 
									   hero.contentSize.width, 
									   hero.contentSize.height);
		
		if (CGRectIntersectsRect(peekerRect, targetRect)) {
			
			[self removeChild:peeker cleanup:YES];
			newPeeksToAdd =+ 2;
			
			
			
		}
		
		
	}
	
	[self addNewPeeks];
	
}
-(void) addNewPeeks {
	
	while (newPeeksToAdd != 0) {
		CCSprite *peek = [CCSprite spriteWithFile:@"green.png"];
		
		CGPoint center = [hero position];
		int x = arc4random() % 250 +100;
		int y = arc4random() % 250 + 100;
		
		int flipX = arc4random() % 2;
		int flipY = arc4random() % 2;
		
		if (flipX == 1) {
			x = -x;
		}
		if (flipY == 1) {
			y = -y;
		}
		
		CGPoint newCenter = ccp(center.x + x,center.y + y);
		
		peek.position = newCenter;
		
		[peeks addObject:peek];
		[self addChild:peek];
		newPeeksToAdd--;
		
	}						
	
	
	
	
}
-(void) callPeeks: (id)sender {
	
	CGPoint center =  [hero position];
	
	int x = 0;
	int y = 0;
	
	for (CCSprite *peek in peeks) {
		x = (arc4random() % 250);
		y = (arc4random() % 250);
		
		int flipX = arc4random() % 2;
		int flipY = arc4random() % 2;
		
		if (flipX == 1) {
			x = -x;
		}
		if (flipY == 1) {
			y = -y;
		}
		
		id action = [CCMoveTo actionWithDuration:1.3 position:ccp(center.x + x, center.y + y)];
		[peek runAction:action];
	}
}

-(BOOL)ccTouchesBegan:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint loc = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]] ];
	
	destination = loc;
	
	return YES;
}

-(BOOL)ccTouchesMoved:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint loc = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]] ];
	
	destination = loc;
	
	return YES;
}

-(BOOL)ccTouchesEnded:(NSSet *)touches withEvent:(UIEvent *)event{
	UITouch *touch = [touches anyObject];
	CGPoint loc = [[CCDirector sharedDirector] convertToGL:[touch locationInView:[touch view]] ];
	
	return YES;
}

// on "dealloc" you need to release all your retained objects
- (void) dealloc
{
	// in case you have something to dealloc, do it in this method
	// in this particular example nothing needs to be released.
	// cocos2d will automatically release all the children (Label)
	
	// don't forget to call "super dealloc"
	[super dealloc];
}
@end
