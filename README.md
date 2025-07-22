# SCInsta

iOS için Instagram’a özel, çok sayıda özellik içeren bir tweak!
`Sürüm v0.7.1` | `Instagram 384.0.0 sürümünde test edildi`

---

> \[!NOT]
>* ⚙️  SCInsta ayarlarını değiştirmek için [bu sayfaya](https://github.com/LilCiro/TurkceSCInsta/wiki/SCInsta-Ayarlar%C4%B1n%C4%B1-De%C4%9Fi%C5%9Ftirme) göz atabilirsin 
>* 🐛  Sizce Türkçede hata manasızlık anlamsızlık ingilizce yerler ve benzeri şeyler için [buraya tıklayın](https://github.com/LilCiro/TurkceSCInsta/issues)

---

# Kurulum

> \[!ÖNEMLİ]
> Bu tweak’i hangi tür cihazda kullanmayı planlıyorsunuz?
>
> * Jailbreak’li veya TrollStore’lu cihaz -> [Hazır paketli tweak’i indir](https://github.com/LilCiro/TurkceSCInsta/releases/latest)
> * Standart iOS cihaz -> [IPA dosyası oluşturma rehberine](https://github.com/LilCiro/TurkceSCInsta/wiki/IPA-Yapmak) göz atın

# Özellikler

### Genel

* Meta AI öğelerini gizle
* Açıklamayı kopyala
* Ayrıntılı renk seçici kullan
* Reels kaydırmayı devre dışı bırak
* Son aramaları kaydetme
* Keşfet gönderi ızgarasını gizle
* Trend aramaları gizle
* Arkadaş haritasını gizle
* Önerilen sohbetleri gizle (dm’de)
* Önerilen kullanıcıları gizle
* Notlar tepsisini gizle

### Akış (Feed)

* Reklamları gizle
* Tüm akışı gizle
* Hikayeler tepsisini gizle
* Önerilen gönderileri gizle
* Önerilen hesapları gizle
* Önerilen reels gizle
* Önerilen Threads gönderilerini gizle

### İşlem onayları

* Beğenme onayı: Gönderiler (ve hikayeler)
* Beğenme onayı: Reels
* Takip onayı
* Arama onayı
* Sesli mesaj onayı
* Sessiz mod onayı (kaybolan mesajlar)
* Sticker etkileşim onayı
* Yorum gönderme onayı
* Tema değiştirme onayı

### Gezinme sekmelerini gizle

* Keşfet sekmesini gizle
* Oluştur sekmesini gizle
* Reels sekmesini gizle

### Medya kaydetme (kısmen çalışıyor)

* Görüntü/video indir
* Profil fotoğrafını kaydet

### Hikayeler ve mesajlar

* Silinen mesajları sakla
* Doğrudan hikayeleri sınırsız tekrar oynat (şu anda video desteği yok)
* Okundu bildirimini devre dışı bırak
* Ekran görüntüsü uyarısını kaldır
* Hikaye görüntüleme bildirimini devre dışı bırak
* Tek seferlik mesaj kısıtlamalarını devre dışı bırak

### Güvenlik

* Kilit (uygulamayı açmak için biyometrik kimlik doğrulama gerektirir)

### Optimizasyon

* Gereksiz önbellek klasörlerini otomatik temizler, Instagram kurulumunuzun boyutunu azaltır

### Dahili Tweak Ayarları

[SCInsta ayarları nasıl değiştirilir?]([https://github.com/SoCuul/SCInsta/wiki/Modify-Settings](https://github.com/LilCiro/TurkceSCInsta/wiki/SCInsta-Ayarlar%C4%B1n%C4%B1-De%C4%9Fi%C5%9Ftirme))

# Uygulama içi ekran görüntüleri

|                                             |                                             |                                             |
| :-----------------------------------------: | :-----------------------------------------: | :-----------------------------------------: |
| <img src="https://i.imgur.com/EZIktAw.png"> | <img src="https://i.imgur.com/aA3g1Vw.png"> | <img src="https://i.imgur.com/QdyFbo4.png"> |
| <img src="https://i.imgur.com/Ydd61cZ.png"> | <img src="https://i.imgur.com/XGOn3lY.png"> | <img src="https://i.imgur.com/n4GFWl8.png"> |

# Kaynak Koddan Derleme

### Önkoşullar

* XCode + Komut Satırı Geliştirici Araçları
* [Homebrew](https://brew.sh/#install)
* [CMake](https://formulae.brew.sh/formula/cmake#default) (`brew install cmake`)
* [Theos](https://theos.dev/docs/installation)
* [cyan](https://github.com/asdfzxcvbn/pyzule-rw?tab=readme-ov-file#install-instructions) **\*sideload için gerekli**

### Kurulum

1. iOS 14.5 framework’lerini theos için yükleyin

   1. [iOS SDK’larını indir](https://github.com/xybp888/iOS-SDKs/archive/refs/heads/master.zip)
   2. Arşivi açın ve `iPhoneOS14.5.sdk` klasörünü `~/theos/sdks` içine kopyalayın
2. GitHub’dan SCInsta deposunu klonlayın: `git clone --recurse-submodules https://github.com/SoCuul/SCInsta`
3. **Sideload için**: Güvenilir bir kaynaktan Instagram’ın şifresi çözülmüş IPA dosyasını indirin ve adını `com.burbn.instagram.ipa` olarak değiştirin.
   Ardından SCInsta klasöründe `packages` adlı bir klasör oluşturun ve IPA dosyasını içine taşıyın.

### Derleme komutunu çalıştırın

```sh
$ chmod +x build.sh  
$ ./build.sh <sideload/rootless/rootful>  
```

# Katkıda Bulunanlar

Bu tweak’e yapılan katkılar çok değerlidir. Katkıda bulunmak isterseniz pull request göndermekten çekinmeyin.

Teknik bilgiye sahip değilseniz, dokümantasyonun geliştirilmesi de her zaman çok yardımcı olur!

# Projeyi Destekleyin

SCInsta geliştirmek çok zaman alıyor, çünkü Instagram sürekli değişiyor ve takip etmek zor. Ayrıca ben bir öğrenciyim ve fazla zamanım yok.

Çalışmalarıma destek olmak istersen [ko-fi sayfama](https://ko-fi.com/socuul) bağış yapabilirsin!
Bu projeyi desteklemenin başka yolları da var; mesela tweak’in linkini ilgilenebilecek insanlarla paylaşmak gibi!

Bu tweak’in kullanıldığını görmek motivasyonumu artırıyor ❤️

# Katkıda Bulunanlar

* Orijinal BHInstagram projesini oluşturan [@BandarHL](https://github.com/BandarHL)’ye büyük teşekkürler. SCInsta bu projeye dayanıyor.
* Çevirmesini yaptığım SCInsta projesini yapan [@SoCuul](https://github.com/SoCuul)’a teşekürler

---
