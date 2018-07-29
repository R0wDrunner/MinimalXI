#import <UIKit/UIKit.h>
#import <UIKit/UIDevice.h>
#import <Preferences/PSViewController.h>
#import <UIKit/UIAppearance.h>

#define TweakEnabled PreferencesBool(@"tweakEnabled", YES)
#define HideSeparators PreferencesBool(@"hideSeparators", YES)
#define HideSearchBackground PreferencesBool(@"hideSearchBackground", NO)
#define EnableConcept PreferencesBool(@"enableConcept", NO)
#define HideUrlBG PreferencesBool(@"hideUrlBG", YES)
#define NoLargeTitles PreferencesBool(@"noLargeTitles", YES)
#define HideFolderBg PreferencesBool(@"hideFolderBg", NO)
#define HideFolderBlur PreferencesBool(@"hideFolderBlur", YES)
#define ShowNameBg PreferencesBool(@"showNameBg", NO)
#define HideFolderIcon PreferencesBool(@"hideFolderIcon", NO)
#define HideIconLabels PreferencesBool(@"hideIconLabels", NO)
#define HideBadgeCount PreferencesBool(@"hideBadgeCount", NO)




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
}

%ctor
  {
        preferences = [[NSDictionary alloc] initWithContentsOfFile:SETTINGS_PLIST_PATH];

        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)PreferencesChangedCallback, CFSTR("com.xiva.minimalxi-prefsreload"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  }

@interface _UISearchBarSearchFieldBackgroundView : UIView
@end
@interface PSListController : UIView
-(void) setEdgeToEdgeCells:(bool)arg1;
@end
@interface _SFNavigationBarURLButtonBackgroundView : UIView
@end
@interface _UINavigationBarLargeTitleViewLayout : UIView
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
@end
@interface SBIconBadgeView : UIView
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

%hook _UISearchBarSearchFieldBackgroundView
  -(void)layoutSubviews {
    if(TweakEnabled && HideSearchBackground) {
      %orig();
      self.alpha = 0;
    } else {
      %orig();
    }
  }
%end

%hook PSListController
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

%hook _SFNavigationBarURLButtonBackgroundView
  -(void) layoutSubviews {
    if(TweakEnabled && HideUrlBG) {
      %orig();
      self.hidden = true;
    } else {
      %orig();
  }
}
%end

%hook _UINavigationBarLargeTitleViewLayout
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

%hook SBFolderBackgroundView
  -(void)layoutSubviews {
    if(TweakEnabled && HideFolderBg) {
      %orig();
      self.hidden = true;
    } else {
      %orig();
      self.hidden = false;
    }
  }
%end

%hook SBFolderControllerBackgroundView
-(void)layoutSubviews {
  if(TweakEnabled && HideFolderBlur) {
    %orig();
    self.hidden = true;
  } else {
    %orig();
    self.hidden = false;
  }
}
%end

%hook UITextFieldBorderView
-(void) layoutSubviews {
  BOOL isCorrect = [[self superview] isMemberOfClass:%c(SBFolderTitleTextField)];
  if(TweakEnabled && ShowNameBg && isCorrect) {
    self.alpha = 1;
  } else {
    %orig();
  }
}
%end

%hook SBFolderIconBackgroundView
-(void)layoutSubviews {
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
-(void) layoutSubviews {
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
  %orig();
}
-(void) setHidden:(bool)arg1 {
  BOOL isCorrect = [[self superview] isMemberOfClass:%c(SBDarkeningImageView)];
  if(TweakEnabled && HideBadgeCount && isCorrect) {
    %orig(true);
  } else {
    %orig();
  }
}
%end

%hook SBIconBadgeView
-(void) layoutSubviews {
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
-(void) layoutSubviews {
  if(TweakEnabled && HideBadgeCount) {
    %orig();
    [self setFrame:CGRectMake( 45, -11, 26, 26)];
  } else {
    %orig();
  }
  %orig();
}
%end
