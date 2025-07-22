#!/usr/bin/env bash

# Hata oluştuğunda betiği durdur
set -e

# CMake mimarileri ve SDK kök dizini ayarları
CMAKE_OSX_ARCHITECTURES="arm64e;arm64"
CMAKE_OSX_SYSROOT="iphoneos"

# Varsayılan değerler (boş bırakılırsa Makefiles'taki mevcut değerler kullanılır)
YENI_UYGULAMA_ADI=""
YENI_GELISTIRICI_ADI=""

# Argümanları ayrıştırma
# getopts yerine daha esnek olan getopt kullanıldı
ARGS=$(getopt -o "" -l "uygulama-adi:,gelistirici-adi:" -- "$@")
if [ $? -ne 0 ]; then
    echo "Hata: Argümanlar ayrıştırılamadı."
    exit 1
fi

eval set -- "$ARGS"

while true; do
    case "$1" in
        --uygulama-adi)
            YENI_UYGULAMA_ADI="$2"
            shift 2
            ;;
        --gelistirici-adi)
            YENI_GELISTIRICI_ADI="$2"
            shift 2
            ;;
        --)
            shift
            break
            ;;
        *)
            echo "Dahili hata!"
            exit 1
            ;;
    esac
done

# Kalan ilk argüman derleme modudur
BUILD_MODE="$1"
shift # BUILD_MODE'u işledikten sonra kaydır

# Kalan argümanlar (örneğin --dev) make komutuna doğrudan iletilecek
MAKE_ARGS=""
if [ -n "$@" ]; then
    MAKE_ARGS="$@"
fi

# Uygulama adı ve geliştirici adı değişkenlerini make komutuna ekle
# Bu değişkenler boş değilse, make komutuna argüman olarak geçirilir.
# Boş bırakılırlarsa, makefile'daki varsayılan değerler kullanılır.
if [ -n "${YENI_UYGULAMA_ADI}" ]; then
    MAKE_ARGS="${MAKE_ARGS} APP_NAME=\"${YENI_UYGULAMA_ADI}\""
fi

if [ -n "${YENI_GELISTIRICI_ADI}" ]; then
    MAKE_ARGS="${MAKE_ARGS} DEV_NAME=\"${YENI_GELISTIRICI_ADI}\""
fi

---

## **Derleme Modları 🛠️**

Eğer bir **derleme modu** belirtilmezse, betik kullanım kılavuzunu gösterecektir.

### **1. Sideload Modu (IPA Olarak Derleme) 📱✨**

`./build.sh sideload [--uygulama-adi "Yeni Ad"] [--gelistirici-adi "Yeni Ad"] [--dev]`

Bu mod, tweakinizi bir IPA dosyası olarak derlemek için kullanılır. Özellikle iOS cihazlara sideload yapmak için idealdir.

* Derleme kalıntıları temizlenir.
* **`./packages/com.burbn.instagram.ipa`** dosyasının mevcut olup olmadığı kontrol edilir. Bu dosya, derleme için şifresi çözülmüş Instagram IPA'sı olmalıdır. Yoksa hata verir.
* "SCInsta tweak IPA olarak sideload için derleniyor..." mesajı görüntülenir.
* Eğer ikinci argüman olarak `--dev` verilirse, geliştirme modunda derlenir. Aksi takdirde normal sideload derlemesi yapılır.
* IPA dosyası oluşturulur ve `packages/SCInsta-sideloaded.ipa` olarak kaydedilir.

### **2. Rootless Modu (Jailbreakli Cihazlar İçin) 🌿📱**

`./build.sh rootless [--uygulama-adi "Yeni Ad"] [--gelistirici-adi "Yeni Ad"]`

Bu mod, modern, rootless jailbreak'li cihazlar (iOS 15 ve sonrası) için bir `.deb` paketi derler.

* Derleme kalıntıları temizlenir.
* "SCInsta tweak rootless için derleniyor..." mesajı görüntülenir.
* **`THEOS_PACKAGE_SCHEME`** ortam değişkeni `rootless` olarak ayarlanır.
* `make package` komutu çalıştırılarak `.deb` paketi oluşturulur.

### **3. Rootful Modu (Eski Jailbreakli Cihazlar İçin) 🌳📱**

`./build.sh rootful [--uygulama-adi "Yeni Ad"] [--gelistirici-adi "Yeni Ad"]`

Bu mod, daha eski, rootful jailbreak'li cihazlar (iOS 14 ve öncesi) için bir `.deb` paketi derler.

* Derleme kalıntıları temizlenir.
* "SCInsta tweak rootful için derleniyor..." mesajı görüntülenir.
* **`THEOS_PACKAGE_SCHEME`** ortam değişkeninin ayarı kaldırılır (varsayılan rootful davranış için).
* `make package` komutu çalıştırılarak `.deb` paketi oluşturulur.

---

## **Önemli Notlar**

* **Uygulama Adı ve Geliştirici Adı (Opsiyonel):** `--uygulama-adi "Yeni Uygulama Adı"` ve `--gelistirici-adi "Yeni Geliştirici Adı"` argümanları **isteğe bağlıdır**. Eğer bu argümanları kullanmazsanız, projenizin **`Makefile`'ında tanımlı olan mevcut uygulama ve geliştirici adları kullanılacaktır**.
* **`Makefile` Entegrasyonu:** Bu betik, belirtilen uygulama ve geliştirici adlarını `make` komutuna `APP_NAME` ve `DEV_NAME` değişkenleri olarak iletir. Bu değerlerin projenizin **`Makefile`'ında doğru şekilde işlendiğinden** (örneğin `Info.plist`'i veya Theos'un paketleme ayarlarını güncelleyecek şekilde) emin olmanız gerekmektedir.

---

```bash
if [ "${BUILD_MODE}" == "sideload" ]; then

    # Derleme kalıntılarını temizle 🧹
    make clean
    rm -rf .theos

    # Şifresi çözülmüş Instagram IPA dosyasını kontrol et 🔍
    ipaFile="$(find ./packages/*com.burbn.instagram*.ipa -type f -exec basename {} \;)"
    if [ -z "${ipaFile}" ]; then
        echo -e '\033[1m\033[0;31m./packages/com.burbn.instagram.ipa bulunamadı. ❌\nLütfen şifresi çözülmüş bir Instagram IPA dosyasını bu yola yerleştirin.\033[0m'
        exit 1
    fi

    echo -e '\033[1m\033[32mSCInsta tweak IPA olarak sideload için derleniyor... 📱✨\033[0m'

    # Geliştirici moduyla derlenip derlenmediğini kontrol et
    if [ "${MAKE_ARGS}" == "--dev" ]; then
        make "DEV=1" ${MAKE_ARGS} # MAKE_ARGS'ı DEV=1 ile birleştir
    else
        make "SIDELOAD=1" ${MAKE_ARGS} # MAKE_ARGS'ı SIDELOAD=1 ile birleştir
    fi

    # IPA Dosyası Oluştur 📦
    echo -e '\033[1m\033[32mIPA dosyası oluşturuluyor... 🚀\033[0m'
    rm -f packages/SCInsta-sideloaded.ipa
    # cyan komutuna APP_NAME ve DEV_NAME'i doğrudan geçirmek için ek bir mekanizma gerekebilir
    # Bu örnekte, cyan komutunun bu değişkenleri doğrudan kullanabildiği varsayılmıştır.
    cyan -i "packages/${ipaFile}" -o packages/SCInsta-sideloaded.ipa -f .theos/obj/debug/SCInsta.dylib .theos/obj/debug/sideloadfix.dylib $FLEXPATH -c 0 -m 15.0 -du

    echo -e "\033[1m\033[32mTamamlandı, SCInsta'yı beğeneceğinizi umuyoruz! 🎉😊\n\nIPA dosyasını şu adreste bulabilirsiniz: $(pwd)/packages\033[0m"

elif [ "${BUILD_MODE}" == "rootless" ]; then
    
    # Derleme kalıntılarını temizle 🧹
    make clean
    rm -rf .theos

    echo -e '\033[1m\033[32mSCInsta tweak rootless için derleniyor... 🌿📱\033[0m'

    export THEOS_PACKAGE_SCHEME=rootless
    make package ${MAKE_ARGS} # MAKE_ARGS'ı make package ile birleştir

    echo -e "\033[1m\033[32mTamamlandı, SCInsta'yı beğeneceğinizi umuyoruz! 🎉😊\n\nDeb dosyasını şu adreste bulabilirsiniz: $(pwd)/packages\033[0m"

elif [ "${BUILD_MODE}" == "rootful" ]; then

    # Derleme kalıntılarını temizle 🧹
    make clean
    rm -rf .theos

    echo -e '\033[1m\033[32mSCInsta tweak rootful için derleniyor... 🌳📱\033[0m'

    unset THEOS_PACKAGE_SCHEME
    make package ${MAKE_ARGS} # MAKE_ARGS'ı make package ile birleştir

    echo -e "\033[1m\033[32mTamamlandı, SCInsta'yı beğeneceğinizi umuyoruz! 🎉😊\n\nDeb dosyasını şu adreste bulabilirsiniz: $(pwd)/packages\033[0m"

else
    echo '+--------------------+'
    echo '|SCInsta Derleme Betiği|'
    echo '+--------------------+'
    echo
    echo 'Kullanım: ./build.sh <sideload/rootless/rootful> [--uygulama-adi "Yeni Ad" (Opsiyonel)] [--gelistirici-adi "Yeni Ad" (Opsiyonel)]'
    exit 1
fi
