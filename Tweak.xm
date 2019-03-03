#import <UIKit/UIKit.h>
#import <UIKit/UIDevice.h>
#import <Preferences/PSViewController.h>
#import <UIKit/UIAppearance.h>

#define TweakEnabled PreferencesBool(@"tweakEnabled", YES)
#define HideSeparators PreferencesBool(@"hideSeparators", YES)
#define HideSearchBackground PreferencesBool(@"hideSearchBackground", NO)
#define EnableConcept PreferencesBool(@"enableConcept", NO)
#define HideUrlBG PreferencesBool(@"hideUrlBG", NO)
#define NoLargeTitles PreferencesBool(@"noLargeTitles", YES)
#define HideFolderBg PreferencesBool(@"hideFolderBg", NO)
#define HideFolderBlur PreferencesBool(@"hideFolderBlur", NO)
#define ShowNameBg PreferencesBool(@"showNameBg", NO)
#define HideFolderIcon PreferencesBool(@"hideFolderIcon", NO)
#define HideIconLabels PreferencesBool(@"hideIconLabels", YES)
#define HideUpdatedDot PreferencesBool(@"hideUpdatedDot", YES)
#define HideDockBackground PreferencesBool(@"hideDockBackground", NO)


#define SETTINGS_PLIST_PATH @"/var/mobile/Library/Preferences/com.r0wdrunner.minimalxi.plist"

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
    CFStringRef appID = CFSTR("com.r0wdrunner.minimalxi");
    CFArrayRef keyList = CFPreferencesCopyKeyList(appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    preferences = (NSDictionary *)CFPreferencesCopyMultiple(keyList, appID, kCFPreferencesCurrentUser, kCFPreferencesAnyHost);
    CFRelease(keyList);
    //Calling the Methods, so that after a Change in the Tweak's Settings, everything works without a Respring. Not Fully done yet.
  }

%ctor
  {
        preferences = [[NSDictionary alloc] initWithContentsOfFile:SETTINGS_PLIST_PATH];

        CFNotificationCenterAddObserver(CFNotificationCenterGetDarwinNotifyCenter(), NULL, (CFNotificationCallback)PreferencesChangedCallback, CFSTR("com.r0wdrunner.minimalxi-prefsreload"), NULL, CFNotificationSuspensionBehaviorCoalesce);
  }

@interface _UISearchBarSearchFieldBackgroundView : UIView
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
@interface _UILegibilityImageView : UIView
@end
@interface SBIconRecentlyUpdatedLabelAccessoryView : UIView
@end
@interface SBWallpaperEffectView : UIView
@end


%hook SBWallpaperEffectView
-(void)layoutSubviews {
  BOOL isCorrect = [[self superview] isMemberOfClass:%c(SBDockView)];
  if(TweakEnabled && HideDockBackground && isCorrect) {
    %orig();
    self.hidden = true;
  } else {
    %orig();
    self.hidden = false;
  }
}
  -(void)setHidden:(bool)arg1 {
    BOOL isCorrect = [[self superview] isMemberOfClass:%c(SBDockView)];
    if(TweakEnabled && HideDockBackground && isCorrect) {
      %orig(true);
    } else {
      %orig(false);
    }
}

%end

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
  -(void)didMoveToWindow {
    if(TweakEnabled && HideSearchBackground) {
      %orig();
      self.hidden = true;
    } else {
      %orig();
      self.hidden = false;
    }
    %orig();
  }
%end

%hook PSListController //IOS12CONCEPT
  -(bool) _isRegularWidth {
    if(TweakEnabled && EnableConcept) {
      return YES;
    } else {
      return NO;
    }
  }
%end

%hook PSUIPrefsListController //IOS12CONCEPT
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
  -(void)layoutSubviews {
    BOOL isCorrect = [[self superview] isMemberOfClass:%c(SBFolderTitleTextField)];
    if(TweakEnabled && ShowNameBg && isCorrect) {
      self.alpha = 1;
    } else {
      %orig();
    }
  }
%end

%hook SBFolderIconBackgroundView //HIDE FOLDER ICON BACKGROUND
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

%hook _UILegibilityImageView //HIDE ICON LABELS | SBIconLegibilityLabelView didn't work so I've hidden a subview of it, works fine now.
  -(void)layoutSubviews {
    BOOL isCorrect = [[self superview] isMemberOfClass:%c(SBIconLegibilityLabelView)];
    if(TweakEnabled && HideIconLabels && isCorrect) {
      %orig();
      self.hidden = true;
    } else {
      %orig();
      self.hidden = false;
    }
  }
    -(void)setHidden:(bool)arg1 {
      BOOL isCorrect = [[self superview] isMemberOfClass:%c(SBIconLegibilityLabelView)];
      if(TweakEnabled && HideIconLabels && isCorrect) {
        %orig(true);
      } else {
        %orig(false);
      }
  }
%end

%hook SBIconRecentlyUpdatedLabelAccessoryView //HIDE BLUE UPDATE DOT
  -(void)didMoveToWindow {
    if(TweakEnabled && HideUpdatedDot) {
      %orig();
      self.hidden = true;
    } else {
      %orig();
      self.hidden = false;
    }
    %orig();
  }
%end
