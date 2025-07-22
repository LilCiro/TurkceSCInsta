// Tweak settings
- (NSArray *)specifiers {
    if (!_specifiers) {        
        _specifiers = [NSMutableArray arrayWithArray:@[
            [self newLinkCellWithTitle:@"Bağış Yap 💖" detailTitle:@"Bu tweak'i desteklemek için bağış yapmayı düşünün <3" url:@"https://ko-fi.com/socuul" iconURL:@"https://i.imgur.com/g4U5AMi.png" iconTransparentBG:YES],

            // Bölüm 1: Genel
            [self newSectionWithTitle:@"Genel" footer:nil],
            [self newSwitchCellWithTitle:@"Meta AI'yi Gizle 🕵️‍♂️" detailTitle:@"Uygulamadaki meta AI düğmelerini/fonksiyonlarını gizler 🔒" key:@"hide_meta_ai" changeAction:nil],
            [self newSwitchCellWithTitle:@"Açıklamayı Kopyala 📋" detailTitle:@"Metin açıklamalarını uzun basarak kopyalayın 📄" key:@"copy_description" changeAction:nil],
            [self newSwitchCellWithTitle:@"Detaylı Renk Seçici Kullan 🎨" detailTitle:@"Hikayelerde göz damlası aracına uzun basarak renkleri daha hassas seçin 🌈" key:@"detailed_color_picker" changeAction:nil],
            [self newSwitchCellWithTitle:@"Son Aramaları Kaydetme 🚫" detailTitle:@"Arama çubukları artık son aramaları kaydetmez ❌" key:@"no_recent_searches" changeAction:nil],
            [self newSwitchCellWithTitle:@"Notlar Çubuğunu Gizle 🗒️" detailTitle:@"DM gelen kutusundaki notlar çubuğunu gizler 🙈" key:@"hide_notes_tray" changeAction:nil],
            [self newSwitchCellWithTitle:@"Arkadaş Haritasını Gizle 🗺️" detailTitle:@"Notlar çubuğundaki arkadaş haritası simgesini gizler 🚷" key:@"hide_friends_map" changeAction:nil],

            // Bölüm 2: Akış (Feed)
            [self newSectionWithTitle:@"Akış" footer:nil],
            [self newSwitchCellWithTitle:@"Reklamları Gizle 🚫📢" detailTitle:@"Instagram uygulamasındaki tüm reklamları kaldırır ✂️" key:@"hide_ads" changeAction:nil],
            [self newSwitchCellWithTitle:@"Hikaye Çubuğunu Gizle 📵" detailTitle:@"Akışınızın üstündeki hikaye çubuğunu gizler 🙅‍♂️" key:@"hide_stories_tray" changeAction:nil],
            [self newSwitchCellWithTitle:@"Tüm Akışı Gizle 🕳️" detailTitle:@"Ana sayfa akışını tamamen gizler 📭" key:@"hide_entire_feed" changeAction:nil],
            [self newSwitchCellWithTitle:@"Önerilen Gönderileri Gizle 🚫✨" detailTitle:@"Akışınızdaki önerilen gönderileri kaldırır ❌" key:@"no_suggested_post" changeAction:nil],
            [self newSwitchCellWithTitle:@"Sizin İçin Önerilenleri Gizle 🙅‍♀️" detailTitle:@"Takip etmeniz için önerilen hesapları gizler 🙈" key:@"no_suggested_account" changeAction:nil],
            [self newSwitchCellWithTitle:@"Önerilen Reels Videolarını Gizle 🎞️" detailTitle:@"İzlemeniz için önerilen reels videolarını gizler 📵" key:@"no_suggested_reels" changeAction:nil],
            [self newSwitchCellWithTitle:@"Threads Önerilerini Gizle ✂️" detailTitle:@"Önerilen threads gönderilerini gizler 🧵" key:@"no_suggested_threads" changeAction:nil],

            // Bölüm 3: Medya Kaydetme
            [self newSectionWithTitle:@"Medya Kaydetme" footer:nil],
            [self newSwitchCellWithTitle:@"Akış Gönderilerini İndir 📥" detailTitle:@"Ana sekmedeki gönderileri parmaklarınızla uzun basarak indirin ⬇️" key:@"dw_feed_posts" changeAction:nil],
            [self newSwitchCellWithTitle:@"Reels Videolarını İndir 🎬" detailTitle:@"Reels videolarına uzun basarak indirin ⬇️" key:@"dw_reels" changeAction:nil],
            [self newSwitchCellWithTitle:@"Hikayeleri İndir 📚" detailTitle:@"Birinin hikayesine uzun basarak indirin ⬇️" key:@"dw_story" changeAction:nil],
            [self newSwitchCellWithTitle:@"Profil Fotoğrafını Kaydet 🖼️" detailTitle:@"Birinin profil fotoğrafına tıklayınca büyütün, ardından uzun basarak indirin 📸" key:@"save_profile" changeAction:nil],
            [self newStepperCellWithTitle:@"Uzun Basma İçin %@ %@" key:@"dw_finger_count" min:1 max:5 step:1 label:@"parmak" singularLabel:@"parmak"],
            [self newStepperCellWithTitle:@"%@ %@ basarak indir" key:@"dw_finger_duration" min:0 max:10 step:0.25 label:@"sn" singularLabel:@"sn"],

            // Bölüm 4: Hikayeler ve Mesajlar
            [self newSectionWithTitle:@"Hikayeler ve Mesajlar" footer:nil],
            [self newSwitchCellWithTitle:@"Silinen Mesajları Tut 🗑️" detailTitle:@"Sohbette silinen direkt mesajları tutar 📩" key:@"keep_deleted_message" changeAction:nil],
            [self newSwitchCellWithTitle:@"Ekran Görüntüsü Algılamayı Kapat 📵" detailTitle:@"DM'deki görsel mesajlarda ekran görüntüsü engellemesini kaldırır 🔓" key:@"remove_screenshot_alert" changeAction:nil],
            [self newSwitchCellWithTitle:@"Sınırsız Tekrar İzle 🎥♾️" detailTitle:@"Direkt mesajdaki hikayeleri sınırsız kez tekrar oynatır (resim kontrol ikonu ile açılır)" key:@"unlimited_replay" changeAction:nil],
            [self newSwitchCellWithTitle:@"Okundu Bildirimini Kapat 👀❌" detailTitle:@"Mesajları okuduğunuzda karşı tarafa okundu bilgisini göndermez 📭" key:@"remove_lastseen" changeAction:nil],
            [self newSwitchCellWithTitle:@"Hikaye Görülme Bildirimini Kapat 👁️‍🗨️" detailTitle:@"Birinin hikayesini izlediğinizde bildirim göndermez 🙈" key:@"no_seen_receipt" changeAction:nil],
            [self newSwitchCellWithTitle:@"Tek Görüntüleme Kısıtlamasını Kaldır 🔄" detailTitle:@"Tek seferlik mesajları normal görsel mesaj gibi yapar (döngü ve duraklatılabilir)" key:@"disable_view_once_limitations" changeAction:nil],

            // Bölüm 5: İşlem Onayları
            [self newSectionWithTitle:@"İşlem Onayları" footer:nil],
            [self newSwitchCellWithTitle:@"Beğeni Onayı ✔️❌" detailTitle:@"Gönderi veya hikayelerde beğeni yapmadan önce onay sorar ⚠️" key:@"like_confirm" changeAction:nil],
            [self newSwitchCellWithTitle:@"Reels Beğeni Onayı 🎞️✔️❌" detailTitle:@"Reels videolarındaki beğeniler için onay ister ⚠️" key:@"like_confirm_reels" changeAction:nil],
            [self newSwitchCellWithTitle:@"Takip Onayı 🤝❗" detailTitle:@"Takip butonuna basınca onay isteyin ✔️" key:@"follow_confirm" changeAction:nil],
            [self newSwitchCellWithTitle:@"Arama Onayı 📞❗" detailTitle:@"Sesli/görüntülü arama yapmadan önce onay alın ⚠️" key:@"call_confirm" changeAction:nil],
            [self newSwitchCellWithTitle:@"Sesli Mesaj Onayı 🎤❗" detailTitle:@"Sesli mesaj göndermeden önce onay gösterir ✔️" key:@"voice_message_confirm" changeAction:nil],
            [self newSwitchCellWithTitle:@"Sessiz Mod Onayı 🤫❗" detailTitle:@"Kaybolan mesaj modunu açmadan önce onay alır ✔️" key:@"shh_mode_confirm" changeAction:nil],
            [self newSwitchCellWithTitle:@"Sticker Etkileşim Onayı 🎟️❗" detailTitle:@"Birinin hikayesindeki sticker'a basınca onay ister ✔️" key:@"sticker_interact_confirm" changeAction:nil],
            [self newSwitchCellWithTitle:@"Yorum Gönderme Onayı 💬❗" detailTitle:@"Yorum yapmadan önce onay ister ✔️" key:@"post_comment_confirm" changeAction:nil],
            [self newSwitchCellWithTitle:@"Tema Değişikliği Onayı 🎨❗" detailTitle:@"DM kanal teması değiştirirken onay ister ✔️" key:@"change_direct_theme_confirm" changeAction:nil],

            // Bölüm 6: Odaklanma/Dikkat Dağınıklığı
            [self newSectionWithTitle:@"Odaklanma/Dikkat" footer:nil],
            [self newSwitchCellWithTitle:@"Keşfet Gönderi Izgarasını Gizle 🔍" detailTitle:@"Keşfet/arama sekmesindeki önerilen gönderi ızgarasını gizler 📵" key:@"hide_explore_grid" changeAction:nil],
            [self newSwitchCellWithTitle:@"Trend Olan Aramaları Gizle 📈" detailTitle:@"Keşfet arama çubuğu altındaki trend aramaları gizler ❌" key:@"hide_trending_searches" changeAction:nil],
            [self newSwitchCellWithTitle:@"Önerilen Sohbetleri Gizle 💬" detailTitle:@"DM'deki önerilen yayın kanallarını gizler 🙅‍♂️" key:@"no_suggested_chats" changeAction:nil],
            [self newSwitchCellWithTitle:@"Önerilen Kullanıcıları Gizle 🙅‍♀️" detailTitle:@"Sizin için önerilen kullanıcıları gizler 🙈" key:@"no_suggested_users" changeAction:nil],
            [self newSwitchCellWithTitle:@"Reels Kaydırmayı Kapat 🚫🎞️" detailTitle:@"Reels videolarının otomatik kaydırmasını engeller ✋" key:@"disable_scrolling_reels" changeAction:nil],

            // Bölüm 7: Navigasyon Sekmelerini Gizle
            [self newSectionWithTitle:@"Navigasyon" footer:nil],
            [self newSwitchCellWithTitle:@"Keşfet Sekmesini Gizle 🔍" detailTitle:@"Alt çubuktaki keşfet/arama sekmesini gizler 🚫" key:@"hide_explore_tab" changeAction:nil],
            [self newSwitchCellWithTitle:@"Oluştur Sekmesini Gizle ➕" detailTitle:@"Alt çubuktaki oluştur/kamera sekmesini gizler 🚫" key:@"hide_create_tab" changeAction:nil],
            [self newSwitchCellWithTitle:@"Reels Sekmesini Gizle 🎞️" detailTitle:@"Alt çubuktaki reels sekmesini gizler 🚫" key:@"hide_reels_tab" changeAction:nil],

            // Bölüm 8: Güvenlik
            [self newSectionWithTitle:@"Güvenlik" footer:nil],
            [self newSwitchCellWithTitle:@"Kilitleme 🔒" detailTitle:@"Instagram'ı biyometri/şifre ile kilitler 🛡️" key:@"padlock" changeAction:nil],

            // Bölüm 9: Hata Ayıklama
            [self newSectionWithTitle:@"Hata Ayıklama" footer:nil],
            [self newSwitchCellWithTitle:@"FLEX Hareketini Etkinleştir 🤚" detailTitle:@"Ekrana 5 parmakla basarak FLEX gezginini açmanızı sağlar 🔍" key:@"flex_instagram" changeAction:@selector(FLEXAction:)],

            // Bölüm 10: Katkıda Bulunanlar
[self newSectionWithTitle:@"Katkıda Bulunanlar" footer:[NSString stringWithFormat:@"SCInsta %@\n\nInstagram v%@", SCIVersionString, [SCIUtils IGVersionString]]],
[self newLinkCellWithTitle:@"Geliştirici" detailTitle:@"SoCuul" url:@"https://socuul.dev" iconURL:@"https://i.imgur.com/WSFMSok.png" iconTransparentBG:NO],
[self newLinkCellWithTitle:@"Çevirmen" detailTitle:@"LilCiro" url:@"https://github.com/LilCiro" iconURL:@"https://i.imgur.com/WSFMSok.png" iconTransparentBG:NO],
[self newLinkCellWithTitle:@"Repoyu Görüntüle" detailTitle:@"Fork edilmiş tweakin kaynak kodunu GitHub'da görüntüle" url:@"https://github.com/LilCiro" iconURL:@"https://i.imgur.com/BBUNzeP.png" iconTransparentBG:YES],
[self newLinkCellWithTitle:@"Orijinal Repoyu Görüntüle" detailTitle:@"Orijinal tweakin kaynak kodunu GitHub'da görüntüle" url:@"https://github.com/SoCuul/SCInsta" iconURL:@"https://i.imgur.com/BBUNzeP.png" iconTransparentBG:YES]
        ]];
        
        [self collectDynamicSpecifiersFromArray:_specifiers];
    }
    
    return _specifiers;
}
