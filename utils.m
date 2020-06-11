NSString *localizedStringForKey(NSString *key) {
    static NSBundle *tweakBundle;
    if (!tweakBundle)
        tweakBundle = [[NSBundle alloc] initWithPath:@"/Library/Application Support/SettingsWidgets"];

    return [tweakBundle localizedStringForKey:key value:@"" table:nil];
}
