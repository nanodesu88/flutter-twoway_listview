#import "TwowayListviewPlugin.h"
#if __has_include(<twoway_listview/twoway_listview-Swift.h>)
#import <twoway_listview/twoway_listview-Swift.h>
#else
// Support project import fallback if the generated compatibility header
// is not copied when this plugin is created as a library.
// https://forums.swift.org/t/swift-static-libraries-dont-copy-generated-objective-c-header/19816
#import "twoway_listview-Swift.h"
#endif

@implementation TwowayListviewPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftTwowayListviewPlugin registerWithRegistrar:registrar];
}
@end
