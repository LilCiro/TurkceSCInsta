#import "SettingsViewController.h"

@interface SCISettingsViewController ()
@property (nonatomic, assign) BOOL hasDynamicSpecifiers;
@property (nonatomic, retain) NSMutableDictionary *dynamicSpecifiers;
@end

@implementation SCISettingsViewController
- (instancetype)init {
    self = [super init];
    if (self) {
        self.title = @"SCInsta Ayarları"; // Güncellendi
        [self.navigationController.navigationBar setPrefersLargeTitles:false];
    }
    return self;
}

- (UITableViewStyle)tableViewStyle {
    return UITableViewStyleInsetGrouped;
}

// Pref Section
- (PSSpecifier *)newSectionWithTitle:(NSString *)header footer:(NSString *)footer {
    PSSpecifier *section = [PSSpecifier preferenceSpecifierNamed:header target:self set:nil get:nil detail:nil cell:PSGroupCell edit:nil];
    if (footer != nil) {
        [section setProperty:footer forKey:@"footerText"];
    }
    return section;
}

// Pref Switch Cell
- (PSSpecifier *)newSwitchCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText key:(NSString *)keyText changeAction:(SEL)changeAction {
    PSSpecifier *switchCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSSwitchCell edit:nil];
    
    [switchCell setProperty:keyText forKey:@"key"];
    [switchCell setProperty:keyText forKey:@"id"];
    [switchCell setProperty:@YES forKey:@"big"];
    [switchCell setProperty:SCISwitchTableCell.class forKey:@"cellClass"];
    [switchCell setProperty:NSBundle.mainBundle.bundleIdentifier forKey:@"defaults"];
    //[switchCell setProperty:@([SCIManager getBoolPref:keyText]) forKey:@"default"];
    [switchCell setProperty:NSStringFromSelector(changeAction) forKey:@"switchAction"];
    if (detailText != nil) {
        [switchCell setProperty:detailText forKey:@"subtitle"];
    }
    return switchCell;
}

// Pref Stepper Cell
- (PSSpecifier *)newStepperCellWithTitle:(NSString *)titleText key:(NSString *)keyText min:(double)min max:(double)doublemax step:(double)step label:(NSString *)label singularLabel:(NSString *)singularLabel {
    PSSpecifier *stepperCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSTitleValueCell edit:nil];
    
    [stepperCell setProperty:keyText forKey:@"key"];
    [stepperCell setProperty:keyText forKey:@"id"];
    [stepperCell setProperty:@YES forKey:@"big"];
    [stepperCell setProperty:SCIStepperTableCell.class forKey:@"cellClass"];
    [stepperCell setProperty:NSBundle.mainBundle.bundleIdentifier forKey:@"defaults"];

    [stepperCell setProperty:@(min) forKey:@"min"];
    [stepperCell setProperty:@(doublemax) forKey:@"max"];
    [stepperCell setProperty:@(step) forKey:@"step"];
    [stepperCell setProperty:label forKey:@"label"];
    [stepperCell setProperty:singularLabel forKey:@"singularLabel"];

    return stepperCell;
}

// Pref Link Cell
- (PSSpecifier *)newLinkCellWithTitle:(NSString *)titleText detailTitle:(NSString *)detailText url:(NSString *)url iconURL:(NSString *)iconURL iconTransparentBG:(BOOL)iconTransparentBG {
    PSSpecifier *LinkCell = [PSSpecifier preferenceSpecifierNamed:titleText target:self set:@selector(setPreferenceValue:specifier:) get:@selector(readPreferenceValue:) detail:nil cell:PSButtonCell edit:nil];
    
    [LinkCell setButtonAction:@selector(hb_openURL:)];
    [LinkCell setProperty:HBLinkTableCell.class forKey:@"cellClass"];
    [LinkCell setProperty:url forKey:@"url"];
    if (detailText != nil) {
        [LinkCell setProperty:detailText forKey:@"subtitle"];
    }
    if (iconURL != nil) {
        [LinkCell setProperty:iconURL forKey:@"iconURL"];
        [LinkCell setProperty:@YES forKey:@"iconCircular"];
        [LinkCell setProperty:@YES forKey:@"big"];
        [LinkCell setProperty:@56 forKey:@"height"];
        [LinkCell setProperty:@(iconTransparentBG) forKey:@"iconTransparentBG"];
    }

    return LinkCell;
}

// Tweak settings
- (NSArray *)specifiers {
    if (!_specifiers) {        
        _specifiers = [NSMutableArray arrayWithArray:@[
            [self newLinkCellWithTitle:@"Bağış Yap 💖" detailTitle:@"Bu tweak'i desteklemek için bağış yapmayı düşünün <3" url:@"https://ko-fi.com/socuul" iconURL:@"https://i.imgur.com/g4U5AMi.png" iconTransparentBG:YES], // Güncellendi

            // Section 1: General
            [self newSectionWithTitle:@"Genel" footer:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Meta AI'yi Gizle 🕵️‍♂️" detailTitle:@"Uygulamadaki meta AI düğmelerini/fonksiyonlarını gizler 🔒" key:@"hide_meta_ai" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Açıklamayı Kopyala 📋" detailTitle:@"Metin açıklamalarını uzun basarak kopyalayın 📄" key:@"copy_description" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Detaylı Renk Seçici Kullan 🎨" detailTitle:@"Hikayelerde göz damlası aracına uzun basarak renkleri daha hassas seçin 🌈" key:@"detailed_color_picker" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Son Aramaları Kaydetme 🚫" detailTitle:@"Arama çubukları artık son aramaları kaydetmez ❌" key:@"no_recent_searches" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Notlar Çubuğunu Gizle 🗒️" detailTitle:@"DM gelen kutusundaki notlar çubuğunu gizler 🙈" key:@"hide_notes_tray" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Arkadaş Haritasını Gizle 🗺️" detailTitle:@"Notlar çubuğundaki arkadaş haritası simgesini gizler 🚷" key:@"hide_friends_map" changeAction:nil], // Güncellendi

            // Section 2: Feed
            [self newSectionWithTitle:@"Akış" footer:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Reklamları Gizle 🚫📢" detailTitle:@"Instagram uygulamasındaki tüm reklamları kaldırır ✂️" key:@"hide_ads" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Hikaye Çubuğunu Gizle 📵" detailTitle:@"Akışınızın üstündeki hikaye çubuğunu gizler 🙅‍♂️" key:@"hide_stories_tray" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Tüm Akışı Gizle 🕳️" detailTitle:@"Ana sayfa akışını tamamen gizler 📭" key:@"hide_entire_feed" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Önerilen Gönderileri Gizle 🚫✨" detailTitle:@"Akışınızdaki önerilen gönderileri kaldırır ❌" key:@"no_suggested_post" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Sizin İçin Önerilenleri Gizle 🙅‍♀️" detailTitle:@"Takip etmeniz için önerilen hesapları gizler 🙈" key:@"no_suggested_account" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Önerilen Reels Videolarını Gizle 🎞️" detailTitle:@"İzlemeniz için önerilen reels videolarını gizler 📵" key:@"no_suggested_reels" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Threads Önerilerini Gizle ✂️" detailTitle:@"Önerilen threads gönderilerini gizler 🧵" key:@"no_suggested_threads" changeAction:nil], // Güncellendi
            
            // Section 3: Save media
            [self newSectionWithTitle:@"Medya Kaydetme" footer:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Akış Gönderilerini İndir 📥" detailTitle:@"Ana sekmedeki gönderileri parmaklarınızla uzun basarak indirin ⬇️" key:@"dw_feed_posts" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Reels Videolarını İndir 🎬" detailTitle:@"Reels videolarına uzun basarak indirin ⬇️" key:@"dw_reels" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Hikayeleri İndir 📚" detailTitle:@"Birinin hikayesine uzun basarak indirin ⬇️" key:@"dw_story" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Profil Fotoğrafını Kaydet 🖼️" detailTitle:@"Birinin profil fotoğrafına tıklayınca büyütün, ardından uzun basarak indirin 📸" key:@"save_profile" changeAction:nil], // Güncellendi
            [self newStepperCellWithTitle:@"Uzun Basma İçin %@ parmak" key:@"dw_finger_count" min:1 max:5 step:1 label:@"parmak" singularLabel:@"parmak"], // Güncellendi
            [self newStepperCellWithTitle:@"%@ sn basarak indir" key:@"dw_finger_duration" min:0 max:10 step:0.25 label:@"sn" singularLabel:@"sn"], // Güncellendi

            // Section 4: Stories and Messages
            [self newSectionWithTitle:@"Hikayeler ve Mesajlar" footer:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Silinen Mesajları Tut 🗑️" detailTitle:@"Sohbette silinen direkt mesajları tutar 📩" key:@"keep_deleted_message" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Ekran Görüntüsü Algılamayı Kapat 📵" detailTitle:@"DM'deki görsel mesajlarda ekran görüntüsü engellemesini kaldırır 🔓" key:@"remove_screenshot_alert" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Sınırsız Tekrar İzle 🎥♾️" detailTitle:@"Direkt mesajdaki hikayeleri sınırsız kez tekrar oynatır (resim kontrol ikonu ile açılır)" key:@"unlimited_replay" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Okundu Bildirimini Kapat 👀❌" detailTitle:@"Mesajları okuduğunuzda karşı tarafa okundu bilgisini göndermez 📭" key:@"remove_lastseen" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Hikaye Görülme Bildirimini Kapat 👁️‍🗨️" detailTitle:@"Birinin hikayesini izlediğinizde bildirim göndermez 🙈" key:@"no_seen_receipt" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Tek Görüntüleme Kısıtlamasını Kaldır 🔄" detailTitle:@"Tek seferlik mesajları normal görsel mesaj gibi yapar (döngü ve duraklatılabilir)" key:@"disable_view_once_limitations" changeAction:nil], // Güncellendi
            
            // Section 5: Confirm actions
            [self newSectionWithTitle:@"İşlem Onayları" footer:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Beğeni Onayı ✔️❌" detailTitle:@"Gönderi veya hikayelerde beğeni yapmadan önce onay sorar ⚠️" key:@"like_confirm" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Reels Beğeni Onayı 🎞️✔️❌" detailTitle:@"Reels videolarındaki beğeniler için onay ister ⚠️" key:@"like_confirm_reels" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Takip Onayı 🤝❗" detailTitle:@"Takip butonuna basınca onay isteyin ✔️" key:@"follow_confirm" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Arama Onayı 📞❗" detailTitle:@"Sesli/görüntülü arama yapmadan önce onay alın ⚠️" key:@"call_confirm" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Sesli Mesaj Onayı 🎤❗" detailTitle:@"Sesli mesaj göndermeden önce onay gösterir ✔️" key:@"voice_message_confirm" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Sessiz Mod Onayı 🤫❗" detailTitle:@"Kaybolan mesaj modunu açmadan önce onay alır ✔️" key:@"shh_mode_confirm" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Sticker Etkileşim Onayı 🎟️❗" detailTitle:@"Birinin hikayesindeki sticker'a basınca onay ister ✔️" key:@"sticker_interact_confirm" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Yorum Gönderme Onayı 💬❗" detailTitle:@"Yorum yapmadan önce onay ister ✔️" key:@"post_comment_confirm" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Tema Değişikliği Onayı 🎨❗" detailTitle:@"DM kanal teması değiştirirken onay ister ✔️" key:@"change_direct_theme_confirm" changeAction:nil], // Güncellendi
            
            // Section 6: Focus/Distractions
            [self newSectionWithTitle:@"Odaklanma/Dikkat" footer:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Keşfet Gönderi Izgarasını Gizle 🔍" detailTitle:@"Keşfet/arama sekmesindeki önerilen gönderi ızgarasını gizler 📵" key:@"hide_explore_grid" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Trend Olan Aramaları Gizle 📈" detailTitle:@"Keşfet arama çubuğu altındaki trend aramaları gizler ❌" key:@"hide_trending_searches" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Önerilen Sohbetleri Gizle 💬" detailTitle:@"DM'deki önerilen yayın kanallarını gizler 🙅‍♂️" key:@"no_suggested_chats" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Önerilen Kullanıcıları Gizle 🙅‍♀️" detailTitle:@"Sizin için önerilen kullanıcıları gizler 🙈" key:@"no_suggested_users" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Reels Kaydırmayı Kapat 🚫🎞️" detailTitle:@"Reels videolarının otomatik kaydırmasını engeller ✋" key:@"disable_scrolling_reels" changeAction:nil], // Güncellendi

            // Section 7: Hide navigation tabs
            [self newSectionWithTitle:@"Navigasyon" footer:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Keşfet Sekmesini Gizle 🔍" detailTitle:@"Alt çubuktaki keşfet/arama sekmesini gizler 🚫" key:@"hide_explore_tab" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Oluştur Sekmesini Gizle ➕" detailTitle:@"Alt çubuktaki oluştur/kamera sekmesini gizler 🚫" key:@"hide_create_tab" changeAction:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Reels Sekmesini Gizle 🎞️" detailTitle:@"Alt çubuktaki reels sekmesini gizler 🚫" key:@"hide_reels_tab" changeAction:nil], // Güncellendi

            // Section 8: Security
            [self newSectionWithTitle:@"Güvenlik" footer:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"Kilitleme 🔒" detailTitle:@"Instagram'ı biyometri/şifre ile kilitler 🛡️" key:@"padlock" changeAction:nil], // Güncellendi

            // Section 9: Debugging
            [self newSectionWithTitle:@"Hata Ayıklama" footer:nil], // Güncellendi
            [self newSwitchCellWithTitle:@"FLEX Hareketini Etkinleştir 🤚" detailTitle:@"Ekrana 5 parmakla basarak FLEX gezginini açmanızı sağlar 🔍" key:@"flex_instagram" changeAction:@selector(FLEXAction:)], // Güncellendi

            // Section 10: Credits
            [self newSectionWithTitle:@"Katkıda Bulunanlar" footer:[NSString stringWithFormat:@"SCInsta %@\n\nInstagram v%@", SCIVersionString, [SCIUtils IGVersionString]]], // Güncellendi
            [self newLinkCellWithTitle:@"Geliştirici" detailTitle:@"SoCuul" url:@"https://socuul.dev" iconURL:@"https://i.imgur.com/WSFMSok.png" iconTransparentBG:NO], // Güncellendi
            [self newLinkCellWithTitle:@"Çevirmen" detailTitle:@"LilCiro" url:@"https://github.com/LilCiro" iconURL:@"https://i.imgur.com/WSFMSok.png" iconTransparentBG:NO], // Güncellendi
            [self newLinkCellWithTitle:@"Türkçe Repo" detailTitle:@"LilCiro tarafından sağlanan Türkçe repoyu görüntüle" url:@"https://github.com/LilCiro/SC" iconURL:@"https://i.imgur.com/BBUNzeP.png" iconTransparentBG:YES], // Türkçe Repo
            [self newLinkCellWithTitle:@"Orijinal Repo" detailTitle:@"Tweak'in orijinal kaynak kodunu görüntüle" url:@"https://github.com/SoCuul/SCInsta" iconURL:@"https://i.imgur.com/BBUNzeP.png" iconTransparentBG:YES] // Orijinal Repo
        ]];
        
        [self collectDynamicSpecifiersFromArray:_specifiers];
    }
    
    return _specifiers;
}

- (void)reloadSpecifiers {
    [super reloadSpecifiers];
    
    [self collectDynamicSpecifiersFromArray:self.specifiers];
}
- (CGFloat)tableView:(UITableView *)tableView heightForRowAtIndexPath:(NSIndexPath *)indexPath {
    if (self.hasDynamicSpecifiers) {
        PSSpecifier *dynamicSpecifier = [self specifierAtIndexPath:indexPath];
        BOOL __block shouldHide = false;
        
        [self.dynamicSpecifiers enumerateKeysAndObjectsUsingBlock:^(id  _Nonnull key, id  _Nonnull obj, BOOL * _Nonnull stop) {
            NSMutableArray *specifiers = obj;
            if ([specifiers containsObject:dynamicSpecifier]) {
                shouldHide = [self shouldHideSpecifier:dynamicSpecifier];
                
                UITableViewCell *specifierCell = [dynamicSpecifier propertyForKey:PSTableCellKey];
                specifierCell.clipsToBounds = shouldHide;
            }
        }];
        if (shouldHide) {
            return 0;
        }
    }
    
    return UITableViewAutomaticDimension;
}

- (void)collectDynamicSpecifiersFromArray:(NSArray *)array {
    if (!self.dynamicSpecifiers) {
        self.dynamicSpecifiers = [NSMutableDictionary new];
        
    } else {
        [self.dynamicSpecifiers removeAllObjects];
    }
    
    for (PSSpecifier *specifier in array) {
        NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];
        
        if (dynamicSpecifierRule.length > 0) {
            NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];
            
            if (ruleComponents.count == 3) {
                NSString *opposingSpecifierID = [ruleComponents objectAtIndex:0];
                if ([self.dynamicSpecifiers objectForKey:opposingSpecifierID]) {
                    NSMutableArray *specifiers = [[self.dynamicSpecifiers objectForKey:opposingSpecifierID] mutableCopy];
                    [specifiers addObject:specifier];
                    
                    
                    [self.dynamicSpecifiers removeObjectForKey:opposingSpecifierID];
                    [self.dynamicSpecifiers setObject:specifiers forKey:opposingSpecifierID];
                } else {
                    [self.dynamicSpecifiers setObject:[NSMutableArray arrayWithArray:@[specifier]] forKey:opposingSpecifierID];
                }
                
            } else {
                [NSException raise:NSInternalInconsistencyException format:@"dynamicRule key requires three components (Specifier ID, Comparator, Value To Compare To). You have %ld of 3 (%@) for specifier '%@'.", ruleComponents.count, dynamicSpecifierRule, [specifier propertyForKey:PSTitleKey]];
            }
        }
    }
    
    self.hasDynamicSpecifiers = (self.dynamicSpecifiers.count > 0);
}
- (DynamicSpecifierOperatorType)operatorTypeForString:(NSString *)string {
    NSDictionary *operatorValues = @{ @"==" : @(EqualToOperatorType), @"!=" : @(NotEqualToOperatorType), @">" : @(GreaterThanOperatorType), @"<" : @(LessThanOperatorType) };
    return [operatorValues[string] intValue];
}
- (BOOL)shouldHideSpecifier:(PSSpecifier *)specifier {
    if (specifier) {
        NSString *dynamicSpecifierRule = [specifier propertyForKey:@"dynamicRule"];
        NSArray *ruleComponents = [dynamicSpecifierRule componentsSeparatedByString:@", "];
        
        PSSpecifier *opposingSpecifier = [self specifierForID:[ruleComponents objectAtIndex:0]];
        id opposingValue = [self readPreferenceValue:opposingSpecifier];
        id requiredValue = [ruleComponents objectAtIndex:2];
        
        if ([opposingValue isKindOfClass:NSNumber.class]) {
            DynamicSpecifierOperatorType operatorType = [self operatorTypeForString:[ruleComponents objectAtIndex:1]];
            
            switch (operatorType) {
                case EqualToOperatorType:
                    return ([opposingValue intValue] == [requiredValue intValue]);
                    break;
                    
                case NotEqualToOperatorType:
                    return ([opposingValue intValue] != [requiredValue intValue]);
                    break;
                    
                case GreaterThanOperatorType:
                    return ([opposingValue intValue] > [requiredValue intValue]);
                    break;
                    
                case LessThanOperatorType:
                    return ([opposingValue intValue] < [requiredValue intValue]);
                    break;
            }
        }
        
        if ([opposingValue isKindOfClass:NSString.class]) {
            return [opposingValue isEqualToString:requiredValue];
        }
        
        if ([opposingValue isKindOfClass:NSArray.class]) {
            return [opposingValue containsObject:requiredValue];
        }
    }
    
    return NO;
}

- (void)setPreferenceValue:(id)value specifier:(PSSpecifier *)specifier {
    NSUserDefaults *Prefs = [NSUserDefaults standardUserDefaults];
    [Prefs setValue:value forKey:[specifier identifier]];

    NSLog(@"[SCInsta] Set user default. Key: %@ | Value: %@", [specifier identifier], value);
    
    if (self.hasDynamicSpecifiers) {
        NSString *specifierID = [specifier propertyForKey:PSIDKey];
        PSSpecifier *dynamicSpecifier = [self.dynamicSpecifiers objectForKey:specifierID];
        
        if (dynamicSpecifier) {
            [self.table beginUpdates];
            [self.table endUpdates];
        }
    }
}
- (id)readPreferenceValue:(PSSpecifier *)specifier {
    NSUserDefaults *Prefs = [NSUserDefaults standardUserDefaults];
    return [Prefs valueForKey:[specifier identifier]]?:[specifier properties][@"default"];
}

- (void)FLEXAction:(UISwitch *)sender {
    if (sender.isOn) {
        [[objc_getClass("FLEXManager") sharedManager] showExplorer];

        NSLog(@"[SCInsta] FLEX explorer: Enabled");
    }
    else {
        [[objc_getClass("FLEXManager") sharedManager] hideExplorer];

        NSLog(@"[SCInsta] FLEX explorer: Disabled");
    }
}
@end
