#JISHIDE

##Warning / Peringatan
*Pustaka ini dibangun pada tahun 2015 menggunakan **bahasa C** dan **Objective-C** yang mungkin saja sudah tidak kompatibel dengan compiler ios/macos saat ini (2022), repositori ini bermaksud untuk membagikan teknik teknik real time audio encoder yang mungkin saja masih bisa bermanfaat.*
 
##Fungsi Jishide
Jishide adalah pustaka yang bertugas untuk 
 1. Membaca ios/macos media audio (Apple format seperti M4A dsb)
 2. Melakukan real time encoding menjadi format yang diterima oleh Icecast yaitu Ogg Vorbis atau MP3
 3. Melakukan pengaturan beragam parameter network Icecast
 4. Mengirim  audio data ke Icecast Server


##Icecast
Icecast adalah streaming media serrver yang hanya mendukung Ogg Vorbis dan MP3 audio stream, Icecast banyak digunakan oleh stasion internet radio dan mentransmisikan ke pendengar di seluruh penjuru dunia yang dapat menjangkau Internet stasion radio tersebut. Secara ringkas Icecast bekerja seperti berikut di bawah ini :

**[AUDIO SOURCE]-->[SOURCE CLIENT]-->[ICECAST SERVER]-->[LISTENER/PENDENGAR]**

Audio source dapat berupa :

1. Musik digital dalam format Ogg Vorbis atau MP3
2. Microphone
3. Kombinasi 1 dan 2 (mixing)

Dan ditempatkan di mana saja baik itu di rumah, di kantor atau di data center yang terhubung ke jejaring internet, dalam terminologi Icecast, audio source ini diproses terlebih dahulu menggunakan **source client** sebagai audio data menuju Icecast Server, selanjutnya pendengar dapat mendengarkan secara live menggunakan aplikasi radio atau browser.

Referensi lengkap tentang Icecast dapat dilihat di [https://icecast.org](https://icecast.org) 

##Ogg Vorbis
adalah format audio yang bersifat kode terbuka, non-proprietary, bebas paten royalti, mendukung kompresi menengah hingga tinggi (8 - 48 kHz, 16+ bit, polyphonic), Ogg Vorbis setara dengan MPEG-4 AAC, memiliki performa yang lebih baik dibandingkan dengan MP3, WMA ataupun PAC.  
