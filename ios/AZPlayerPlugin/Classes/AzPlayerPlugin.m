#import "AzPlayerPlugin.h"
#import <az_player_plugin/az_player_plugin-Swift.h>

@implementation AzPlayerPlugin
+ (void)registerWithRegistrar:(NSObject<FlutterPluginRegistrar>*)registrar {
  [SwiftAzPlayerPlugin registerWithRegistrar:registrar];
}
@end
