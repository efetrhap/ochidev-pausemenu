# ochidev-pause

![License](https://img.shields.io/badge/license-MIT-blue.svg)
![Version](https://img.shields.io/badge/version-1.0.0-brightgreen.svg)
![Qbox](https://img.shields.io/badge/Qbox-supported-brightgreen.svg)
![QBCore](https://img.shields.io/badge/QBCore-supported-brightgreen.svg)

FiveM için modern Pause Menü. Qbox ve QBCore altyapılarını destekler.

---

## Özellikler

- **Dinamik Kamera Takibi:** Menü açıldığında kamerayı karaktere veya araca kilitler; hareket halindeyken ya da koşarken kadrajdan çıkma yaşanmaz.
- **Düşük Kaynak Tüketimi:** Menü kapalıyken 0.00ms, menü açıkken ~0.01ms resmon tüketimi.
- **Framework Uyumluluğu:** Qbox (`qbx_core`) ve QBCore (`qb-core`) otomatik tespiti.
- **Veri Güvenliği & Optimizasyon:** `ox_lib` callback entegrasyonu, oyuncu bazlı rate-limit ve sunucu önbellekleme.
- **Harita ve Ayarlar Entegrasyonu:** Orijinal GTA V harita ve ayarlar menüsüne sorunsuz geçiş.
- **Onaylı Çıkış:** Yanlışlıkla sunucudan ayrılmayı önleyen onay mekanizması.

---

## Gereksinimler

- [ox_lib](https://github.com/overextended/ox_lib)
- Desteklenen bir framework: `qbx_core` veya `qb-core`

---

## Yapılandırma

`config.lua` dosyasındaki temel seçenekler:

```lua
Config = {}

-- Framework seçimi: 'qbox' | 'qbcore'
Config.Framework = 'qbox'

-- Kamera ayarları
Config.Camera = {
    TransitionTime = 800,       -- Geçiş süresi (ms)
    ReturnTime = 600,           -- Dönüş süresi (ms)
    OffsetX = 0.0,              -- X ekseni ofseti
    OffsetY = 1.35,             -- Y ekseni ofseti (karakterden uzaklık)
    OffsetZ = 0.45,             -- Z ekseni ofseti (yükseklik)
    DofStrength = 1.0,          -- Alan derinliği şiddeti
    BlurEffect = false,         -- Arka plan bulanıklık efekti
    Timecycle = 'hud_def_blur'  -- Kullanılacak filtre
}

-- Sunucudan ayrılma mesajı
Config.DisconnectReason = 'Sunucudan ayrıldınız.'

-- Menü metinleri
Config.Labels = {
    Resume = 'Devam Et',
    Map = 'Harita',
    Settings = 'AYARLAR',
    Disconnect = 'Sunucudan Çıkış',
    Job = 'İŞ',
    Cash = 'NAKİT',
    Bank = 'BANKA'
}
```

---

## Lisans

Bu proje MIT lisansı altındadır.
