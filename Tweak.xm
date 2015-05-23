@interface TFNTwitterAccount
@property(readonly, assign, nonatomic) NSString *accountID;
@property(readonly, assign, nonatomic) NSString *username;
@property(copy, nonatomic) NSString *password;
@end

@interface T1MainViewController
@property(retain, nonatomic) TFNTwitterAccount *account;
- (id)currentPanelNavigationController;
@end

@interface T1PhoneMainViewController : T1MainViewController
+ (id)mainViewControllerForAccount:(id)account;
- (void)setAccount:(id)account;
@end

// %hook T1MainViewController
// - (void)showCustomTimelineWithID:(id)anId owningUsername:(id)username animated:(BOOL)animated completion:(id)completion {
// 	NSLog(@"twodayslate was here");
// 	%log;
// 	%orig;
// }
// - (void)showCustomTimelineWithID:(id)anId owningUsername:(id)username fromPanel:(id)panel animated:(BOOL)animated completion:(id)completion {
// 	NSLog(@"twodayslate was here");
// 	%log;
// 	%orig;
// }
// %end

// @interface TFNTabbedViewController : UIViewController
// @end

static NSString *currentUsername;

%hook T1PhoneMainViewController
// + (id)mainViewControllerForAccount:(id)account {
// 	%log;
// 	NSLog(@"twodayslate was here");
// 	id p = %orig;
// 	NSLog(@"orig = %@",p);
// 	return %orig;
// }
- (void)setAccount:(TFNTwitterAccount *)account {
	%log;
	%orig;
	currentUsername = account.username;
}
%end

// %hook TFNTabbedViewController
// - (void)viewDidAppear:(BOOL)view {
// 	%log;
// 	%orig;
// }
// %end


@interface TFNNavigationStackController : UINavigationController
@end


%hook TFNNavigationStackController 

- (void)viewDidLoad {
	%log;
	%orig;
	NSString *newTitle = self.navigationBar.topItem.title;
	if([newTitle isEqualToString:@"Notifications"]) {
		newTitle = [NSString stringWithFormat:@"@%@'s %@", currentUsername, self.navigationBar.topItem.title];
	}
	self.navigationBar.topItem.title = newTitle;
	NSLog(@"%@",self.viewControllers);
}
%end

%hook T1SwipeTitleView
-(void)setCurrentTitle:(NSString *)arg1 {
	%log;
	NSString *newTitle = arg1;
	if([arg1 isEqualToString:@"Home"]) {
		newTitle = [NSString stringWithFormat:@"@%@", currentUsername];
	}
	
	%orig(newTitle);
}
%end

// %hook UINavigationController 
// - (void)viewDidAppear {
// 	%log;
// 	%orig; 

// 	NSString *newTitle = self.navigationBar.topItem.title;
// 	NSLog(@"original title = %@",newTitle);
// 	NSLog(@"%@",self.navigationBar.items);
// 	if([newTitle isEqualToString:@"Messages"]) {
// 		newTitle = [NSString stringWithFormat:@"@%@'s %@", currentUsername, self.navigationBar.topItem.title];
// 	}
// 	self.navigationBar.topItem.title = newTitle;
// 	self.navigationItem.title = newTitle;
// 	[self setTitle:newTitle];

// 	for(UINavigationItem *item in self.navigationBar.items) {
// 		item.title = newTitle;
// 	}
// }

// %end

// T1TimelineSwipeViewController
// T1NotificationsViewController
// T1DirectMessageInboxViewController





