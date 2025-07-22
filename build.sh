#!/usr/bin/env bash

# Hata durumunda betiği durdur
set -e

# --- Varsayılan Değerler ---
APP_NAME=""
DEVELOPER_NAME=""
REMOVE_APP_ICON="false"
CUSTOM_INSTAGRAM_VERSION=""
BUILD_MODE="" # Derleme modunu saklamak için

# --- Argümanları Ayrıştırma ---
echo "Argümanlar ayrıştırılıyor..."
# İlk argüman her zaman derleme modu olmalı (sideload/rootless/rootful)
BUILD_MODE="$1"
shift # BUILD_MODE'u işledikten sonra kaydır

# Kalan argümanları işle
while [[ "$#" -gt 0 ]]; do
    case "$1" in
        --uygulama-adi)
            APP_NAME="$2"
            shift
            ;;
        --gelistirici-adi)
            DEVELOPER_NAME="$2"
            shift
            ;;
        --remove-app-icon)
            REMOVE_APP_ICON="true"
            ;;
        --instagram-sürümü)
            CUSTOM_INSTAGRAM_VERSION="$2"
            shift
            ;;
        --dev) # Sideload modu için geliştirme bayrağı
            DEV_MODE="true"
            ;;
        *)
            echo "Hata: Bilinmeyen argüman '$1'"
            exit 1
            ;;
    esac
    shift # Bir sonraki argümana geç
done

# --- Önkoşullar ---
# FLEXing submodule kontrolü
if [ -z "$(ls -A modules/FLEXing)" ]; then
    echo -e '\033[1m\033[0;31mFLEXing alt modülü bulunamadı. ❌\nLütfen alt modülleri çekmek için şu komutu çalıştırın:\n\n\033[0m    git submodule update --init --recursive'
    exit 1
fi

# Ortam değişkeni THEOS'u ayarlıyoruz (eğer zaten ayarlı değilse)
if [ -z "${THEOS}" ]; then
    export THEOS=$(realpath ../theos) # Projenin ana dizinine göre ayarlayın
fi
export THEOS_SDK_PATH=${THEOS}/sdks/iPhoneOS14.5.sdk # Kullandığınız SDK yolu

# packages dizinini baştan oluşturup gerekli izinleri verelim
mkdir -p packages
chmod 755 packages
echo "packages/ dizini oluşturuldu ve izinleri ayarlandı."

# --- Derleme Modları ---
if [ "${BUILD_MODE}" == "sideload" ]; then

    echo -e '\033[1m\033[32mSCInsta tweak IPA olarak sideload için derleniyor... 📱✨\033[0m'

    # Derleme kalıntılarını temizle 🧹
    make clean
    rm -rf .theos

    # Orijinal Instagram IPA dosyasını kontrol et 🔍
    ipaFile="$(find ./packages/*com.burbn.instagram*.ipa -type f -exec basename {} \;)"
    if [ -z "${ipaFile}" ]; then
        echo -e '\033[1m\033[0;31m./packages/com.burbn.instagram.ipa bulunamadı. ❌\nLütfen şifresi çözülmüş bir Instagram IPA dosyasını bu yola yerleştirin.\033[0m'
        exit 1
    fi

    echo "IPA dosyası açılıyor ve hazırlanıyor..."
    # IPA'yı geçici bir dizine aç
    IPA_EXTRACT_DIR="packages/extracted_ipa_temp"
    rm -rf "$IPA_EXTRACT_DIR" # Önceki kalıntıları temizle
    mkdir -p "$IPA_EXTRACT_DIR"

    unzip -q "packages/${ipaFile}" -d "$IPA_EXTRACT_DIR"

    # Payload klasörünü doğrulama ve taşıma
    if [ ! -d "${IPA_EXTRACT_DIR}/Payload" ]; then
        echo "Hata: IPA içinde 'Payload' klasörü bulunamadı. IPA yapısı beklenenden farklı."
        exit 1
    fi

    # Payload klasörünü yeni, kalıcı bir yere taşı (burayı IPA_BASE_DIR olarak kullanacağız)
    IPA_BASE_DIR="packages/modded_ipa_base"
    rm -rf "$IPA_BASE_DIR" # Önceki kalıntıları temizle
    mv "${IPA_EXTRACT_DIR}/Payload" "$IPA_BASE_DIR"
    rm -rf "$IPA_EXTRACT_DIR" # Geçici çıkarma dizinini temizle

    # Uygulamanın tam yolunu belirle
    # Payload klasörünün içinde sadece bir .app dosyası olmalı
    APP_DIR=$(find "${IPA_BASE_DIR}" -maxdepth 1 -type d -name "*.app" | head -n 1)

    if [ -z "$APP_DIR" ]; then
        echo "Hata: '${IPA_BASE_DIR}' içinde .app paketi bulunamadı. IPA yapısı bozuk olabilir."
        exit 1
    fi

    INFO_PLIST="${APP_DIR}/Info.plist"

    # Info.plist dosyasının varlığını kontrol et
    if [ ! -f "$INFO_PLIST" ]; then
        echo "Hata: Info.plist dosyası '$INFO_PLIST' bulunamadı. .app paketi bozuk olabilir."
        exit 1
    fi

    # --- Özelleştirmeleri Uygula (Info.plist ve İkonlar) ---

    # 1. Uygulama Adını Değiştirme
    if [ -n "$APP_NAME" ]; then
        echo "Uygulama adı '${APP_NAME}' olarak ayarlanıyor..."
        /usr/libexec/PlistBuddy -c "Set :CFBundleDisplayName $APP_NAME" "$INFO_PLIST" || { echo "PlistBuddy CFBundleDisplayName hatası!"; exit 1; }
        /usr/libexec/PlistBuddy -c "Set :CFBundleName $APP_NAME" "$INFO_PLIST" || { echo "PlistBuddy CFBundleName hatası!"; exit 1; }
    fi

    # 2. Geliştirici Adını Değiştirme (Not: Genellikle Info.plist'te standart bir anahtar değildir)
    if [ -n "$DEVELOPER_NAME" ]; then
        echo "Geliştirici adı '${DEVELOPER_NAME}' olarak ayarlanmaya çalışılıyor..."
        # Bu genellikle uygulamanın kendisi içinde sabitlenmiştir ve Info.plist üzerinden değiştirilemez.
        # Eğer özel bir anahtar varsa (nadiren):
        # /usr/libexec/PlistBuddy -c "Set :YourCustomDeveloperKey $DEVELOPER_NAME" "$INFO_PLIST" || true
    fi

    # 3. Instagram Uygulama Sürümünü Ayarlama
    if [ -n "$CUSTOM_INSTAGRAM_VERSION" ]; then
        echo "Instagram uygulama sürümü '${CUSTOM_INSTAGRAM_VERSION}' olarak ayarlanıyor..."
        /usr/libexec/PlistBuddy -c "Set :CFBundleShortVersionString $CUSTOM_INSTAGRAM_VERSION" "$INFO_PLIST" || { echo "PlistBuddy CFBundleShortVersionString hatası!"; exit 1; }
        /usr/libexec/PlistBuddy -c "Set :CFBundleVersion $CUSTOM_INSTAGRAM_VERSION" "$INFO_PLIST" || { echo "PlistBuddy CFBundleVersion hatası!"; exit 1; }
    else
        echo "Instagram uygulama sürümü için özel bir değer belirtilmedi, orijinal sürüm kullanılacak."
    fi

    # 4. Uygulama İkonunu Kaldırma
    if [ "$REMOVE_APP_ICON" == "true" ]; then
        echo "Uygulama ikonları kaldırılıyor..."
        # İkon setini sil (AppIcon.appiconset klasörü varsa)
        rm -rf "${APP_DIR}/AppIcon.appiconset" || true
        # Info.plist'ten ikon referanslarını kaldır
        /usr/libexec/PlistBuddy -c "Delete :CFBundleIcons" "$INFO_PLIST" || true
        /usr/libexec/PlistBuddy -c "Delete :CFBundleIcons~ipad" "$INFO_PLIST" || true
        /usr/libexec/PlistBuddy -c "Delete :UIPrerenderedIcon" "$INFO_PLIST" || true
        echo "Uygulama ikonları başarıyla kaldırıldı (veya kaldırılmaya çalışıldı)."
    fi

    # --- Tweak'i Derle ---
    echo "Tweak derleniyor..."
    FLEXPATH_ARGS=""
    if [ "${DEV_MODE}" == "true" ]; then
        FLEXPATH_ARGS='packages/FLEXing.dylib packages/libflex.dylib'
        make "DEV=1"
    else
        FLEXPATH_ARGS='.theos/obj/debug/FLEXing.dylib .theos/obj/debug/libflex.dylib'
        make "SIDELOAD=1"
    fi

    # --- Değiştirilmiş Uygulamayı Geçici Bir IPA'ya Sıkıştır ---
    echo "Değiştirilmiş uygulamayı geçici IPA'ya sıkıştırılıyor..."
    TEMP_MODIFIED_IPA_PATH="packages/temp_modified_base.ipa"
    
    # Yeni bir geçici dizin oluştur (buraya Payload ve .app taşınacak)
    FINAL_ZIP_SOURCE_DIR="packages/final_zip_source"
    rm -rf "$FINAL_ZIP_SOURCE_DIR"
    mkdir -p "$FINAL_ZIP_SOURCE_DIR/Payload" # Zip dosyasının içinde Payload klasörü olacak

    # Modifiye edilmiş .app paketini, sıkıştırma için hazırlanmış Payload dizinine taşı
    # Bu adımda APP_DIR, packages/modded_ipa_base/Payload/Instagram.app gibi olmalı
    # Bu yüzden buraya direkt APP_DIR'ı taşıyoruz
    mv "$APP_DIR" "$FINAL_ZIP_SOURCE_DIR/Payload/" 
    
    # Sıkıştırma sonrası kalacak olan modifiye edilmiş base dizini temizle
    rm -rf "$IPA_BASE_DIR"

    # `final_zip_source` dizinine gidip, `Payload` klasörünü sıkıştır
    cd "$FINAL_ZIP_SOURCE_DIR"
    # Sadece Payload klasörünü ve içindekileri sıkıştır.
    # Çıktı IPA ana dizine göre yolunu belirtiyoruz.
    zip -r -q "../../${TEMP_MODIFIED_IPA_PATH##*/}" Payload/
    cd ../.. # Ana dizine geri dön

    # Kullanılan geçici zip dizinini temizle
    rm -rf "$FINAL_ZIP_SOURCE_DIR"

    # Oluşturulan geçici IPA dosyasının varlığını kontrol et
    if [ ! -f "$TEMP_MODIFIED_IPA_PATH" ]; then
        echo "Hata: Geçici IPA dosyası ($TEMP_MODIFIED_IPA_PATH) oluşturulamadı! ❌"
        # Hata durumunda hata ayıklama için dizin içeriğini listeleyelim
        echo "Hata ayıklama: packages/ dizin içeriği:"
        ls -la packages/
        exit 1
    fi

    # --- Tweak'i Geçici IPA'ya Enjekte Et ve Nihai IPA'yı Oluştur ---
    echo -e '\033[1m\033[32mNihai IPA dosyası oluşturuluyor... 🚀\033[0m'
    rm -f packages/SCInsta-sideloaded.ipa # Eski IPA'yı sil

    # cyan komutu ile tweak dylib'lerini enjekte et
    cyan -i "$TEMP_MODIFIED_IPA_PATH" -o packages/SCInsta-sideloaded.ipa -f .theos/obj/debug/SCInsta.dylib .theos/obj/debug/sideloadfix.dylib ${FLEXPATH_ARGS} -c 0 -m 15.0 -du
    
    # Geçici IPA'yı temizle
    rm -f "$TEMP_MODIFIED_IPA_PATH"

    echo -e "\033[1m\033[32mTamamlandı, SCInsta'yı beğeneceğinizi umuyoruz! 🎉😊\n\nIPA dosyasını şu adreste bulabilirsiniz: $(pwd)/packages\033[0m"

elif [ "${BUILD_MODE}" == "rootless" ]; then
    
    echo -e '\033[1m\033[32mSCInsta tweak rootless için derleniyor... 🌿📱\033[0m'

    # Derleme kalıntılarını temizle 🧹
    make clean
    rm -rf .theos

    export THEOS_PACKAGE_SCHEME=rootless
    make package

    echo -e "\033[1m\033[32mTamamlandı, SCInsta'yı beğeneceğinizi umuyoruz! 🎉😊\n\nDeb dosyasını şu adreste bulabilirsiniz: $(pwd)/packages\033[0m"

elif [ "${BUILD_MODE}" == "rootful" ]; then

    echo -e '\033[1m\033[32mSCInsta tweak rootful için derleniyor... 🌳📱\033[0m'

    # Derleme kalıntılarını temizle 🧹
    make clean
    rm -rf .theos

    unset THEOS_PACKAGE_SCHEME
    make package

    echo -e "\033[1m\033[32mTamamlandı, SCInsta'yı beğeneceğinizi umuyoruz! 🎉😊\n\nDeb dosyasını şu adreste bulabilirsiniz: $(pwd)/packages\033[0m"

else
    echo '+--------------------+'
    echo '|SCInsta Derleme Betiği|'
    echo '+--------------------+'
    echo
    echo 'Kullanım: ./build.sh <sideload/rootless/rootful> [--uygulama-adi "Yeni Ad" (Opsiyonel)] [--gelistirici-adi "Yeni Ad" (Opsiyonel)] [--instagram-sürümü "Yeni Sürüm" (Opsiyonel)] [--remove-app-icon (Opsiyonel)] [--dev (Sadece sideload için)]'
    exit 1
fi
