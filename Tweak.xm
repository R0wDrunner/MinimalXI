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
@interface _SFNavigationBarURLButtonBackgroundView
@property bool hidden;
@end
@interface _UINavigationBarLargeTitleViewLayout
-(double) _textHeightForSize:(CGSize)arg1;
@end
@interface  SBFolderBackgroundView
@property bool hidden;
@end
@interface SBFolderControllerBackgroundView
@property bool hidden;
@end
@interface UITextFieldBorderView
@property CGFloat alpha;
-(id)superview;
@end
@interface  SBFolderIconBackgroundView
@property bool hidden;
-(void) setHidden:(bool)arg1;
@end
@interface SBIconLegibilityLabelView
@property bool hidden;
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
  %orig();
  self.hidden = true;
}
-(void) setHidden:(bool)arg1 {
  %orig(true);
}

%end
