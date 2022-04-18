# JISHIDE

---



### A. Pengantar / Warning / Peringatan

*Pustaka ini dibangun pada tahun 2015 menggunakan **bahasa C** dan **Objective-C** yang mungkin saja sudah tidak kompatibel dengan compiler ios/macos saat ini (2022), repositori ini bermaksud untuk membagikan teknik teknik real time audio encoder yang mungkin saja masih bisa bermanfaat.*



## A.1. Apa Itu Jishide

**Jishide** diucapkan ***Jii-se-daa***  diambil dari bahasa China yang berarti real time. Jishide adalah **pustaka statik (static library)** yang ditulis menggunakan bahasa C dan Objective-C dan dikompilasi untuk digunakan bersama (linked) dengan aplikasi. Walaupun Jishide dikhususkan untuk bekerja dalam platform IOS/MacOS , Jishide ini mudah untuk diporting ke dalam environment lainnya seperti Linux atau keluarga Nix karena kode sumber yang terbuka, tetapi saat ini hanya tersedia untuk platform IOS/MacOS saja.

Sebagai pustaka statik , Jishide menyediakan kumpulan fungsi fungsi yang memudahkan developer/programmer untuk membuat aplikasi yang membutuhkan :

1. Real time transcoding audio dari AudioBufferList  ke format Ogg Vorbis atau MP3

2. Bertanggung jawab dalam berkomunikasi dengan streaming server (Icecast atau Shoutcast)

3. Mengirim data audio ke streaming server (Icecast atau Shoutcast)



Dengan fungsi utama di atas dapat disimpulkan bahwa Jishide dapat digunakan oleh anda untuk membuat aplikasi untuk iPhone atau MacOS seperti :

1. Konverter media format proprietary Apple yaitu m4a ke dalam format media non-proprietary dan terbebas dari lisensi paten yaitu Ogg Vorbis

2. Internet Radio streaming

3. Broadcast live events

4. Podcasting 



### A.2. Transcoding

Dalam Jishide, transcoding adalah konversi langsung digital-to-digital encoding Apple proprietary media format ke  encoding Ogg Vorbis. Ogg Vorbis adalah format audio yang bersifat kode terbuka (open source), bebas royalti paten, mendukung kompresi menengah hingga tinggi (8 - 48 kHz), 16+ bit, polyphonic, mendukung fixed dan variable bitrates dari 16 hingga 128 kbps/channel.  

Dengan kemampuan tersebut di atas, Ogg Vorbis lebih baik dari format MP3, MPEG-1/2 audio layer, MPEG-4 audio (TwinVQ), WMA ataupun PAC.

Ogg Vorbis saat ini banyak dipakai oleh perusahaan besar seperti Spotify, Canonical (Ubuntu Distro), Blizzard Entertainment dan lain nya.

Disamping Ogg Vorbis, Jishide juga menyertakan transcoding ke MP3 walaupun saya tidak merekomendasikannya, fasilitas ini hanya disediakan karena beberapa streaming server tidak menerima format Ogg Vorbis, misalnya Shoutcast. 

Output transcoding yang dilakukan Jishide dapat digunakan sebagai berikut :

1. Disimpan dalam media penyimpanan lokal (iPhone/MacOS), karena output berupa NSData dataWithBytes

2. Ditransmisikan melalui protokol HTTP, Xaudiocast ataupun Icy untuk keperluan seperti Internet Radio live streaming, podcast dan sejenisnya. 



### A.3. Berkomunikasi Dengan Streaming Server

Secara spesifik, Jishide hanya mendukung streaming server untuk Icecast server https://icecast.org dan Shoutcast https://shoutcast.com server , Icecast server membolehkan format audio Ogg Vorbis, AAC atau MP3, sementara Shoutcast server hanya AAC dan MP3.

Semua tugas untuk berkomunikasi dengan streaming server tersebut dipikul oleh Jishide, sehingga anda sebagai developer/programmer dapat menghemat waktu dalam proses pengembangan perangkat lunak untuk iPhone atau MacOS.



## B. Panduan Pemrograman

### B.1. Kode Sumber Atau Source Code

Kode sumber Jishide dibagi menjadi beberapa bagian yaitu 

1. Pre Compiled Library

2. Kode Sumber Utama

3. Kode Sumber Pendukung



Untuk memudahkan dalam mengkompilasi, saya sertakan library yang diperlukan dan sudah dikompilasi dan siap pakai yaitu :

> 1. libmp3lame.a
> 2. libogg.a
> 3. libshout.a
> 4. libtheora.a
> 5. libvorbis.a
> 6. libvorbisenc.a



library ini sudah dikompilasi dan disertakan header C nya masing masing di folder **precompiledlibs** , anda tidak perlu khawatir, kode sumber pre compiled library ini pun dapat dilihat di folder **supportlibs**. Kode sumber utama terdiri dari :



> 1. CCVorbisEncoder.h dan CCVorbisEncoder.m
> 
> 2. CCMP3Encoder.h dan CCMP3Encoder.m
> 
> 3. CCerror.h dan CCerror.m (opsional) 

dimana file file tersebut dapat dilihat selengkapnya di folder **Lifters** pada repository ini.

### B.2. Teknik Pemrograman

Dalam bahasan ini, saya hanya akan menuntun tata cara dasar bagaimana menggunakan Jishide sebagai source client Icecast server, dimana tahapan tahapan nya adalah sebagai berikut :

1. Buka audio library di Ios/MacOS

2. Proses AudioBufferList

3. Transcoding menjadi Ogg Vorbis

4. Transmisikan ke Icecast server



Karena pembahasan di sini bukanlah dokumen step by step, maka saya menganggap anda sudah paham dalam : 

1. Bekerja di XCode IDE

2. Paham tata kelola administrasi Icecast server 



#### B.2.1. Persiapkan Headers

import semua header yang diperlukan

```
#import "shout.h"
#import "CCMP3Encoder.h"
#import "CCVorbisEncoder.h"

.....
.....

link semua library libmp3lame.a, libogg.a, libshout.a, 
libtheora.a, libvorbis.a, libvorbisenc.a dan link juga semua framework
core audio yang diperlukan.
```

#### B.2.2.  Buka Audio Library



### 3. Persiapkan parameter shout

shout memiliki banyak parameter dapat dilihat di south.h, parameter penting yang harus di ikutkan adalah :

1. shout_set_host (icecast host / ip address) tipe data const char *
2. shout_set_port (icecast port) tipe data unsigned short
3. shout_set_protocol, tipe data unsigned int protocol, default SHOUT_PROTOCOL_HTTP
4. shout_set_password (icecast server password) tipe data const char *
5. shout_set_user (icecast server username) tipe data const char *
6. shout_set_mount (icecast mount point) tipe data const char *
7. shout_set_public, (public visibility) tipe data unsigned integer, 1 = public
8. shout_set_format, tipe data unsigned integer, 0 = SHOUT_FORMAT_OGG , 1 = SHOUT_FORMAT_MP3, 2 = SHOUT_FORMAT_AAC

Contoh pemanggilan parameter 

```
-(id)prepareShoutSettings {

        if (shout_set_host(shout, "localhost") != SHOUTERR_SUCCESS)
            return some_shout_error;
}
```

to be continue
