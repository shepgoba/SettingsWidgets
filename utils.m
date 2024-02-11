#import "utils.h"
#import <rootless.h>

NSString *localizedStringForKey(NSString *key) {
    static NSBundle *tweakBundle;
    if (!tweakBundle)
        tweakBundle = [[NSBundle alloc] initWithPath:@ROOT_PATH("/Library/Application Support/SettingsWidgets")];

    return [tweakBundle localizedStringForKey:key value:@"" table:nil];
}
