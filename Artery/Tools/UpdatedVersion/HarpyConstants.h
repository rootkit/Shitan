//
//  HarpyConstants.h
//  
//
//  Created by Arthur Ariel Sabintsev on 1/30/13.
//
//


/*
 Option 1 (DEFAULT): NO gives user option to update during next session launch
 Option 2: YES forces user to update app on launch
 */
static BOOL harpyForceUpdate = NO;

// 2. Your AppID (found in iTunes Connect)
#define kHarpyAppID                 @"945646691"

// 3. Customize the alert title and action buttons
#define kHarpyAlertViewTitle        @"有新版本"
#define kHarpyCancelButtonTitle     @"下次再说"
#define kHarpyUpdateButtonTitle     @"更新"
