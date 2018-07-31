#import <UIKit/UIKit.h>
#import <UIKit/UIDevice.h>
#import <Preferences/PSViewController.h>
#import <UIKit/UIAppearance.h>

#define TweakEnabled PreferencesBool(@"tweakEnabled", YES)
#define HideSeparators PreferencesBool(@"hideSeparators", YES)
#define HideSearchBackground PreferencesBool(@"hideSearchBackground", YES)
#define EnableConcept PreferencesBool(@"enableConcept", NO)
#define HideUrlBG PreferencesBool(@"hideUrlBG", YES)
#define NoLargeTitles PreferencesBool(@"noLargeTitles", YES)
#define HideFolderBg PreferencesBool(@"hideFolderBg", NO)
#define HideFolderBlur PreferencesBool(@"hideFolderBlur", YES)
#define ShowNameBg PreferencesBool(@"showNameBg", YES)
#define HideFolderIcon PreferencesBool(@"hideFolderIcon", NO)
#define HideIconLabels PreferencesBool(@"hideIconLabels", YES)
#define HideBadgeCount PreferencesBool(@"hideBadgeCount", NO)
#define HideUpdatedDot PreferencesBool(@"hideUpdatedDot", YES)

static UIView* searchBackground;


#define SETTINGS_PLIST_PATH @"/var/mobile/Library/Preferences/com.xiva.minimalxi.plist"

static NSDictionary *preferences;
static BOOL PreferencesBool(NSString* key, BOOL fallback)
  {
      return [preferences objectForKey:key] ? [[preferences objectForKey:key] boolValue] : fallback;
  }
  /*
static float PreferencesFloat(NSString* key, float fallback)
    {
        return [preferences objectForKey:key] ? [[preferences objectForKey:key] floatValue] : fallback;
    } */

static void PreferencesChangedCallback(CFNotificationCenterRef center, void *observer, CFStringRef name, const void *object, CFDictionaryRef userInfo) {
    [preferences release];
    CFStringRef appID = CFSTR("com.xiva.minimalxi");
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    preferences = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFRelease(keyList);
    
    [searchBackground didMoveToWindow];
}

%ctor
  {
        preferences = [[NSDictionary alloc] initWithContentsOfFile:SETTINGS_PLIST_PATH];

        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)PreferencesChangedCallback, CFSTR("com.xiva.minimalxi-prefsreload"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  }

@interface _UISearchBarSearchFieldBackgroundView
@property CGFloat alpha;
@end
@interface PSListController
-(void) setEdgeToEdgeCells:(bool)arg1;
-(bool) _isRegularWidth;
@end
@interface PSUIPrefsListController
-(bool) skipSelectingGeneralOnLaunch;
@end
@interface _SFNavigationBarURLButtonBackgroundView : UIView
@end
@interface _UINavigationBarLargeTitleViewLayout
-(double) _textHeightForSize:(CGSize)arg1;
@end
@interface  SBFolderBackgroundView : UIView
@end
@interface SBFolderControllerBackgroundView : UIView
@end
@interface UITextFieldBorderView : UIView
@end
@interface  SBFolderIconBackgroundView : UIView
@end
@interface SBIconLegibilityLabelView : UIView
@end
@interface SBDarkeningImageView : UIView
-(void)setFrame:(CGRect)arg1;
-(id)superview;
@end
@interface SBIconParallaxBadgeView : UIView
-(void)setFrame:(CGRect)arg1;
@end
@interface SBIconBadgeView : UIView
-(void)setFrame:(CGRect)arg1;
@end
@interface SBIconRecentlyUpdatedLabelAccessoryView : UIView
@end

%hook UITableView //Hiding Separators
  -(void)setSeparatorStyle:(long long)arg1 {
    if (TweakEnabled && HideSeparators) {
      %orig(0);
      } else {
      %orig();
      }
    }
%end

%hook _UISearchBarSearchFieldBackgroundView //HIDE SEARCH BACKGROUND
  -(id)init {
    self = %orig;
    if (self) {
      searchBackground = self;
    }
  }

  -(void)didMoveToWindow {
    if(TweakEnabled && HideSearchBackground) {
      %orig();
      self.alpha = 0;
    } else {
      %orig();
    }
  }
%end

%hook PSListController //IOS12CONCEPT
  -(void) loadView {
    if(TweakEnabled && EnableConcept) {
      %orig();
      [self setEdgeToEdgeCells:NO];
    } else {
      %orig();
      [self setEdgeToEdgeCells:YES];
    }
  }
  -(bool) _isRegularWidth {
    if(TweakEnabled && EnableConcept) {
      return YES;
    } else {
      return NO;
    }
  }
%end

%hook PSUIPrefsListController
  -(bool) skipSelectingGeneralOnLaunch {
    if(TweakEnabled && EnableConcept) {
      return YES;
      } else {
        return NO;
      }
  }
%end

%hook _SFNavigationBarURLButtonBackgroundView //SAFARI FLAT URL
  -(void) layoutSubviews {
    if(TweakEnabled && HideUrlBG) {
      %orig();
      self.hidden = true;
    } else {
      %orig();
  }
}
%end

%hook _UINavigationBarLargeTitleViewLayout //NO LARGE TITLES
  -(double) _textHeightForSize:(CGSize)arg1 titleType:(long long)arg2 {
    if(TweakEnabled && NoLargeTitles) {
      return 0;
    } else {
      return 50;
    }
  }
  -(void) setTitleLabel:(id)arg1 {
    if(TweakEnabled && NoLargeTitles) {
      %orig(NULL);
    } else {
      %orig();
    }
  }
%end

%hook SBFolderBackgroundView // HIDE FOLDER BACKGROUND
  -(void)didMoveToWindow {
    if(TweakEnabled && HideFolderBg) {
      %orig();
      self.hidden = true;
    } else {
      %orig();
      self.hidden = false;
    }
  }
%end

%hook SBFolderControllerBackgroundView //HIDEFOLDERBLUR
-(void)didMoveToWindow {
  if(TweakEnabled && HideFolderBlur) {
    %orig();
    self.hidden = true;
  } else {
    %orig();
    self.hidden = false;
  }
}
%end

%hook UITextFieldBorderView //SHOW FOLDER NAME BACKGROUND
-(void)didMoveToWindow {
  BOOL isCorrect = [[self superview] isMemberOfClass:%c(SBFolderTitleTextField)];
  if(TweakEnabled && ShowNameBg && isCorrect) {
    self.alpha = 1;
  } else {
    %orig();
  }
}
%end

%hook SBFolderIconBackgroundView //HIDE FOLDER ICON BACKGROUND
-(void)didMoveToWindow {
  if(TweakEnabled && HideFolderIcon) {
    %orig();
    self.hidden = true;
  } else {
    %orig();
    self.hidden = false;
  }
}

-(void)setHidden:(bool)arg1 {
  if(TweakEnabled && HideFolderIcon) {
    %orig(true);
  } else {
    %orig();
  }
}
%end

%hook SBIconLegibilityLabelView
-(void) layoutSubviews {
  if(TweakEnabled && HideIconLabels) {
    %orig();
    self.hidden = true;
  } else {
    %orig();
  }
}
-(void) setHidden:(bool)arg1 {
  if(TweakEnabled && HideIconLabels) {
    %orig(true);
  } else {
    %orig();
  }
}
%end

%hook SBDarkeningImageView
-(void)didMoveToWindow {
  BOOL isCorrect = [[self superview] isMemberOfClass:%c(SBDarkeningImageView)];
  BOOL isDaddy = [[self superview] isMemberOfClass:%c(SBIconParallaxBadgeView)];

  if(TweakEnabled && HideBadgeCount && isCorrect) {
    %orig();
    self.hidden = true;
  } else {
    %orig();
  }
  if(TweakEnabled && HideBadgeCount && isDaddy) {
    %orig();
    [self setFrame:CGRectMake( 0, 0, 26, 26)];
  } else {
    %orig();
  }
}
-(void)setHidden:(bool)arg1 {
  BOOL isCorrect = [[self superview] isMemberOfClass:%c(SBDarkeningImageView)];
  if(TweakEnabled && HideBadgeCount && isCorrect) {
    %orig(true);
  } else {
    %orig();
  }
}
%end

%hook SBIconBadgeView
-(void)didMoveToWindow {
  if(TweakEnabled && HideBadgeCount) {
    %orig();
    [self setFrame:CGRectMake( 45, -11, 26, 26)];
  } else {
    %orig();
  }
  %orig();
}
%end


%hook SBIconParallaxBadgeView
-(void)layoutSubviews {
  if(TweakEnabled && HideBadgeCount) {
    %orig();
    [self setFrame:CGRectMake( 45, -11, 26, 26)];
  } else {
    %orig();
  }
  %orig();
}
%end

%hook SBIconRecentlyUpdatedLabelAccessoryView
-(void)didMoveToWindow {
  if(TweakEnabled && HideUpdatedDot) {
    %orig();
    self.hidden = true;
  }
  %orig();
}
%end
