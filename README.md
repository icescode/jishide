# JISHIDE

### Pengantar / Warning / Peringatan

*Pustaka ini dibangun pada tahun 2015 menggunakan **bahasa C** dan **Objective-C** yang mungkin saja sudah tidak kompatibel dengan compiler ios/macos saat ini (2022), repositori ini bermaksud untuk membagikan teknik teknik real time audio encoder yang mungkin saja masih bisa bermanfaat.*
 
### Fungsi Jishide
Jishide adalah pustaka yang bertugas untuk 

 1. Membaca ios/macos media audio (Apple format seperti M4A dsb)
 2. Melakukan real time encoding menjadi format yang diterima oleh Icecast yaitu Ogg Vorbis atau MP3
 3. Melakukan pengaturan beragam parameter network Icecast
 4. Mengirim  audio data ke Icecast Server


### Icecast
Icecast adalah streaming media serrver yang hanya mendukung Ogg Vorbis dan MP3 audio stream, Icecast banyak digunakan oleh stasion internet radio dan mentransmisikan ke pendengar di seluruh penjuru dunia yang dapat menjangkau Internet stasion radio tersebut. Secara ringkas Icecast bekerja seperti berikut di bawah ini :

**[AUDIO SOURCE]-->[SOURCE CLIENT]-->[ICECAST SERVER]-->[LISTENER/PENDENGAR]**

Audio source dapat berupa :

1. Musik digital dalam format Ogg Vorbis atau MP3
2. Microphone
3. Kombinasi 1 dan 2 (mixing)

Dan ditempatkan di mana saja baik itu di rumah, di kantor atau di data center yang terhubung ke jejaring internet, dalam terminologi Icecast, audio source ini diproses terlebih dahulu menggunakan **source client** sebagai audio data menuju Icecast Server, selanjutnya pendengar dapat mendengarkan secara live menggunakan aplikasi radio atau browser.

Referensi lengkap tentang Icecast dapat dilihat di [https://icecast.org](https://icecast.org) 

### Ogg Vorbis
adalah format audio yang bersifat kode terbuka, non-proprietary, bebas paten royalti, mendukung kompresi menengah hingga tinggi (8 - 48 kHz, 16+ bit, polyphonic), Ogg Vorbis setara dengan MPEG-4 AAC, memiliki performa yang lebih baik dibandingkan dengan MP3, WMA ataupun PAC.  

### Kode Sumber Atau Source Codes
Kode sumber dibagi menjadi beberapa bagian yaitu

### Pre Compiled Library
Untuk memudahkan dalam mengkompilasi, Saya sertakan library yang diperlukan dan sudah dikompilasi dan siap pakai yaitu :
1. libmp3lame.a
2. libogg.a
3. libshout.a
4. libtheora.a
5. libvorbis.a
6. libvorbisenc.a

library ini sudah dikompilasi dan disertakan header C nya masing masing di folder **precompiledlibs**

### Kode Sumber Utama
Terdiri dari 

1. CCVorbisEncoder.h dan CCVorbisEncoder.m
2. CCMP3Encoder.h dan CCMP3Encoder.m
3. CCerror.h dan CCerror.m (opsional) 

Selengkapnya ada di folder **Lifters** di repos


# Teknik Pemrograman
### 1. Persiapkan Headers

import semua header yang diperlukan
```
#import "shout.h"
#import "CCMP3Encoder.h"
#import "CCVorbisEncoder.h"
```

### 2. Inisialisasi shout
```
@interface your_class_implementation_file () {

    /* shout */
    shout_t *shout;

}

@property (strong, nonatomic) CCMP3Encoder * mp3Encoder;
@property (strong, nonatomic) CCVorbisEncoder * vorbisEncoder;

@end

-(instancetype)initWithOption:(NSDictionary *)option {

    self = [super init];

    if (self) {
        shout_init();
        shout = shout_new();
    }
    return self;
}

```

### 3. Persiapkan parameter shout
shout memiliki banyak parameter dapat dilihat di south.h, parameter penting yang harus di ikutkan adalah :

1. shout_set_host (icecast host / ip address) tipe data const char *
2. shout_set_port (icecast port) tipe data unsigned short
3. shout_set_protocol, tipe data unsigned int protocol, default SHOUT_PROTOCOL_HTTP
4. shout_set_password (icecast server password) tipe data const char *
5. shout_set_user (icecast server username) tipe data const char *
6. shout_set_mount (icecast mount point) tipe data const char *
6. shout_set_public, (public visibility) tipe data unsigned integer, 1 = public
7. shout_set_format, tipe data unsigned integer, 0 = SHOUT_FORMAT_OGG , 1 = SHOUT_FORMAT_MP3, 2 = SHOUT_FORMAT_AAC

Contoh pemanggilan parameter 

```
-(id)prepareShoutSettings {

        if (shout_set_host(shout, "localhost") != SHOUTERR_SUCCESS)
            return some_shout_error;
}
```

to be continue

