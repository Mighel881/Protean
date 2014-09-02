#import <Preferences/Preferences.h>
#import <SettingsKit/SKListControllerProtocol.h>
#import <SettingsKit/SKTintedListController.h>
#import <objc/runtime.h>
#import "IconSelectorController.h"
#import <MessageUI/MFMailComposeViewController.h>

@interface PSListController (SettingsKit)
-(UIView*)view;
-(UINavigationController*)navigationController;
-(void)viewWillAppear:(BOOL)animated;
-(void)viewWillDisappear:(BOOL)animated;
-(void)viewDidDisappear:(BOOL)animated;

- (void)presentViewController:(UIViewController *)viewControllerToPresent animated:(BOOL)flag completion:(void (^)(void))completion;
- (void)dismissViewControllerAnimated:(BOOL)flag completion:(void (^)(void))completion;
-(UINavigationController*)navigationController;

-(void)loadView;
@end

@interface ProteanSettingsListController : SKTintedListController<SKListControllerProtocol, MFMailComposeViewControllerDelegate>
@end

@interface PRAdvancedSettingsListController : SKTintedListController<SKListControllerProtocol>
@end

@implementation ProteanSettingsListController
-(NSString*) headerText { return @"Protean"; }
-(NSString*) headerSubText { return NO ? @"Your status bar, your way" : @"By Elijah and Andrew"; }
-(NSString*) customTitle { return @""; }

-(NSString*) shareMessage { return @"I'm using #Protean by @daementor and @drewplex: your status bar, your way."; }

-(UIColor*) navigationTintColor { return [UIColor colorWithRed:79/255.0f green:176/255.0f blue:136/255.0f alpha:1.0f]; }
-(UIColor*) switchOnTintColor { return self.navigationTintColor; }
-(UIColor*) iconColor { return self.navigationTintColor; }
-(UIColor*) headerColor { return [UIColor colorWithRed:74/255.0f green:74/255.0f blue:74/255.0f alpha:1.0f]; }
//-(UIColor*) tintColor { return self.navigationTintColor; }

-(NSArray*) customSpecifiers
{
    return @[
             
             @{ @"cell": @"PSGroupCell"
                },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.efrederickson.protean.settings",
                 @"key": @"enabled",
                 @"label": @"Enabled",
                 @"PostNotification": @"com.efrederickson.protean/reloadSettings",
                 @"cellClass": @"SKTintedSwitchCell",
                 @"icon": @"enabled.png",
                 },

             @{ @"cell": @"PSGroupCell",
                @"footerText": @"Items do not show up until they have appeared in your status bar. Libstatusbar items cannot be in the center, and a respring will be needed to apply changes to them."
                },
             @{
                 @"cell": @"PSLinkListCell",
                 @"cellClass": @"SKTintedCell",
                 @"detail": @"PROrganizationController",
                 @"label": @"Organization",
                 @"icon": @"organization.png"
                 },
             
             @{ @"cell": @"PSGroupCell",
                @"footerText": @"Select applications, flipswitches, etc and glyphs to show in the status bar (similar to OpenNotifier)"
                },
             @{
                 @"cell": @"PSLinkListCell",
                 @"cellClass": @"SKTintedCell",
                 @"action": @"pushTotalNotificationCountController",
                 @"label": @"Total Notification Count",
                 @"icon": @"tnc.png"
                 },
             @{
                 @"cell": @"PSLinkListCell",
                 @"cellClass": @"SKTintedCell",
                 @"detail": @"ProteanAppsController",
                 @"label": @"Applications",
                 @"icon": @"applications.png"
                 },
             @{
                 @"cell": @"PSLinkListCell",
                 @"cellClass": @"SKTintedCell",
                 @"detail": @"PRSystemIconsController",
                 @"label": @"System Icons",
                 @"icon": @"sysicons.png"
                 },
             @{
               @"cell": @"PSLinkListCell",
                 @"cellClass": @"SKTintedCell",
               @"detail": @"PRFlipswitchController",
               @"label": @"Flipswitches",
               @"icon": @"flipswitches.png"
               },
             @{
                 @"cell": @"PSLinkListCell",
                 @"cellClass": @"SKTintedCell",
                 @"detail": @"PRBluetoothController",
                 @"label": @"Bluetooth Devices",
                 @"icon": @"bluetooth.png"
                 },
            @{ },
            @{
                @"cell": @"PSLinkListCell",
                @"cellClass": @"SKTintedCell",
                @"detail": @"PRAdvancedSettingsListController",
                @"label": @"Advanced Options",
                @"icon": @"settings.png"
            },
             
             @{ @"cell": @"PSGroupCell" },
             @{
                 @"cell": @"PSLinkCell",
                 @"detail": @"PRMakersListController",
                 @"label": @"Credits & Recommendations",
                 @"icon": @"makers.png",
                 @"cellClass": @"SKTintedCell",
                 },
             
             @{ @"cell": @"PSGroupCell",
                @"footerText": @"© 2014 Elijah Frederickson & Andrew Abosh" },
             @{
                 @"cell": @"PSLinkCell",
                 @"action": @"showSupportDialog",
                 @"label": @"Support",
                 @"icon": @"support.png",
                 @"cellClass": @"SKTintedCell",
                 },
             ];
}

-(void) showSupportDialog
{
    MFMailComposeViewController *mailViewController;
    if ([MFMailComposeViewController canSendMail])
    {
        mailViewController = [[MFMailComposeViewController alloc] init];
        mailViewController.mailComposeDelegate = self;
        [mailViewController setSubject:@"Protean"];
        [mailViewController setMessageBody:@"" isHTML:NO];
        [mailViewController setToRecipients:@[@"elijah.frederickson@gmail.com", @"andrewaboshartworks@gmail.com"]];
            
        [self.rootController presentViewController:mailViewController animated:YES completion:nil];
    }

}

-(void)mailComposeController:(MFMailComposeViewController*)controller didFinishWithResult:(MFMailComposeResult)result error:(NSError*)error{
    [self dismissViewControllerAnimated:YES completion:NULL];
}

-(void) pushTotalNotificationCountController
{
	PRIconSelectorController* controller = [[PRIconSelectorController alloc]
                                            initWithAppName:@"Total Notification Count"
                                            identifier:@"TOTAL_NOTIFICATION_COUNT"
                                            ];
	controller.rootController = self.rootController;
	controller.parentController = self;
	
	[self pushController:controller];
}

-(void)setPreferenceValue:(id)value specifier:(PSSpecifier*)specifier
{
    [super setPreferenceValue:value specifier:specifier];
    CFNotificationCenterPostNotification(CFNotificationCenterGetDarwinNotifyCenter(), CFSTR("com.efrederickson.protean/refreshStatusBar"), nil, nil, YES);
}

@end

@implementation PRAdvancedSettingsListController
-(NSArray*) customSpecifiers {
             return @[
                @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.efrederickson.protean.settings",
                 @"key": @"normalizeLS",
                 @"label": @"Normalize LS StatusBar",
                 @"PostNotification": @"com.efrederickson.protean/reloadSettings",
                 @"cellClass": @"SKTintedSwitchCell",
                 @"icon": @"normalizeLS.png"
                 },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @NO,
                 @"defaults": @"com.efrederickson.protean.settings",
                 @"key": @"showSignalRSSI",
                 @"label": @"Show Signal RSSI",
                 @"PostNotification": @"com.efrederickson.protean/reloadSettings",
                 @"cellClass": @"SKTintedSwitchCell",
                 @"icon": @"normalizeLS.png"
                 },
             
             @{ @"cell": @"PSGroupCell",
                @"footerText": @"Enabled by default if time is not aligned in the center. Unlike many other tweaks, it is compatible with LockInfo7 and Forecast."
                },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.efrederickson.protean.settings",
                 @"key": @"showLSTime",
                 @"label": @"Show LS Time",
                 @"PostNotification": @"com.efrederickson.protean/reloadSettings",
                 @"cellClass": @"SKTintedSwitchCell",
                 @"icon": @"showLSTime.png"
                 },
             
             @{ @"cell": @"PSGroupCell",
                @"footerText": @"Change the battery percentage and carrier to custom string types. Space for carrier string hides it, empty is original carrier name."
                },
             @{
                 @"cell": @"PSLinkListCell",
                 @"default": @0,
                 @"defaults": @"com.efrederickson.protean.settings",
                 @"key": @"batteryStyle",
                 @"label": @"Battery Percentage Style",
                 @"PostNotification": @"com.efrederickson.protean/reloadSettings",
                 @"detail": @"SKListItemsController",
                 @"icon": @"batteryStyle.png",
                 @"validTitles": @[ @"Default", @"Hide '%' sign", @"Textual" ],
                 @"validValues": @[ @0,         @1,               @2         ]
                 },
             @{
                 @"cell": @"PSEditTextCell",
                 @"default": @"",
                 @"defaults": @"com.efrederickson.protean.settings",
                 @"key": @"serviceString",
                 @"label": @"Custom Carrier",
                 @"PostNotification": @"com.efrederickson.protean/reloadSettings",
                 @"icon": @"carrierName.png",
                 },
             
             @{ @"cell": @"PSGroupCell",
                @"footerText": @"This may cause minor spacing or overlap issues if items extend pass the midline of the status bar. It is, of course, libstatusbar's fault ;P. Requires a respring to fully apply."
                },
             @{
                 @"cell": @"PSSwitchCell",
                 @"default": @YES,
                 @"defaults": @"com.efrederickson.protean.settings",
                 @"key": @"allowOverlap",
                 @"label": @"Don't cut off items",
                 @"PostNotification": @"com.efrederickson.protean/reloadSettings",
                 @"cellClass": @"SKTintedSwitchCell",
                 @"icon": @"allowOverlap.png"
                 },

            @{ },
             @{
                 @"cell": @"PSButtonCell",
                 @"action": @"respring",
                 @"label": @"Respring",
                 @"icon": @"respring.png"
                 }

             ]; }

-(void)respring
{
    system("killall -9 SpringBoard");
}
@end

#define WBSAddMethod(_class, _sel, _imp, _type) \
if (![[_class class] instancesRespondToSelector:@selector(_sel)]) \
class_addMethod([_class class], @selector(_sel), (IMP)_imp, _type)
void $PSViewController$hideNavigationBarButtons(PSRootController *self, SEL _cmd) {
}

id $PSViewController$initForContentSize$(PSRootController *self, SEL _cmd, CGRect contentSize) {
    return [self init];
}
static __attribute__((constructor)) void __wbsInit() {
    WBSAddMethod(PSViewController, hideNavigationBarButtons, $PSViewController$hideNavigationBarButtons, "v@:");
    WBSAddMethod(PSViewController, initForContentSize:, $PSViewController$initForContentSize$, "@@:{ff}");
}

