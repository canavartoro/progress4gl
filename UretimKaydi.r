	��V�<�R�   �              �                                 6  07F80007utf-8 MAIN C:\OpenEdge\BarsetProxy\Prosedurler\UretimKaydi.p,,INPUT fkod CHARACTER,INPUT ukod CHARACTER,INPUT logfile CHARACTER,INPUT partikod CHARACTER,INPUT OperasyonDS DATASET xop_table DATALINKS 0,INPUT IscilikDS DATASET xis_table DATALINKS 0,INPUT DurusDS DATASET xdur_table DATALINKS 0,INPUT HurdaDS DATASET xhur_table DATALINKS 0,INPUT AletDS DATASET xalet_table DATALINKS 0,INPUT MalzemeDS DATASET Malzemeler DATALINKS 0,OUTPUT master_no DECIMAL,OUTPUT detay_satir INTEGER,OUTPUT islem_sonucu CHARACTER TEMP-TABLE xop_table 0,0 0 NO,kayit_no character 0 0,isemri_no character 1 0,operasyon_kod character 2 0,istasyon_kod character 3 0,bas_tarihi character 4 0,bas_saati character 5 0,bit_tarihi character 6 0,bit_saati character 7 0,miktar decimal 8 0,kat_sayi decimal 9 0,kat_sayi2 decimal 10 0,vardiya_kod character 11 0,skk_no character 12 0,aciklama1 character 13 0,aciklama2 character 14 0,aciklama3 character 15 0,aciklama4 character 16 0,aciklama5 character 17 0,aciklama6 character 18 0 TEMP-TABLE xis_table 0,0 0 NO,ukayit_no character 0 0,personel_kod character 1 0,bas_tarihi character 2 0,bas_saati character 3 0,bit_tarihi character 4 0,bit_saati character 5 0,aciklama character 6 0 TEMP-TABLE xdur_table 0,0 0 NO,ukayit_no character 0 0,durus_kod character 1 0,tezgah_kod character 2 0,baslangic character 3 0,bas_saati character 4 0,bit_tarihi character 5 0,bit_saati character 6 0,aciklama character 7 0,sure integer 8 0,sirano integer 9 0 TEMP-TABLE xhur_table 0,0 0 NO,ukayit_no character 0 0,hurda_skod character 1 0,hurda_sbirim character 2 0,hurda_kod character 3 0,aciklama character 4 0,diger_depo character 5 0,parti_kod character 6 0,miktar decimal 7 0 TEMP-TABLE xalet_table 0,0 0 NO,ukayit_no character 0 0,platform_kod character 1 0,platform_ad character 2 0 TEMP-TABLE Malzemeler 0,0 0 NO,Alternatif logical 0 0,DepoKod character 1 0,MalzemeKod character 2 0,MalzemeKod2 character 3 0,Birim character 4 0,KMiktar decimal 5 0,FMiktar decimal 6 0,PartiNo character 7 0,MiktarSekli integer 8 0        �               '              |,  �   0              �               �	     +           �'  �  ? �)  �  1254                             �   l                                           �              l                                     ˦                          �   �  �                                                          PROGRESS                         X          �          H    *   8     I�      d                   �    T          �      �   �         �       �   H  �     �  �   =�      �         �          �    �          P      �   (         �       �   H  8     T  �   CL      �  
       �          �              �      �   �         �       /  H       (  /  �      T         /         �    �          \      �   �         �       q  H  �        q  ��      ,         q         �    t          �      �              �       �  H          �  ;�      H  	       �         �    8                 �   �       �             `         �       �             �         �       �             �                              �                                  8                        T                        p                        �                        �                               �             �                             �         &                      �             >   ���� " 4                                                                                                                                                                     	                  
                                                                                                                                                                                                                     T
  `
  h
  t
                              x
  �
  �
  �
                              �
  �
  �
  �
                              �
  �
  �
  �
                              �
                                       $  ,  8                              <  H  P  \                              `  l  t  �                              �  �  �  �                              �  �  �  �                              �  �  �  �                              �                                          (  0                              4  @  H  T                              X  d  l  x                              |  �  �  �                              �  �  �  �                              �  �  �  �                              �  �  �                                                                            kayit_no    x(8)    kayit_no        isemri_no   x(8)    isemri_no       operasyon_kod   x(8)    operasyon_kod       istasyon_kod    x(8)    istasyon_kod        bas_tarihi  x(8)    bas_tarihi      bas_saati   x(8)    bas_saati       bit_tarihi  x(8)    bit_tarihi      bit_saati   x(8)    bit_saati       miktar  ->>,>>9.99  miktar  0   kat_sayi    ->>,>>9.99  kat_sayi    0   kat_sayi2   ->>,>>9.99  kat_sayi2   0   vardiya_kod x(8)    vardiya_kod     skk_no  x(8)    skk_no      aciklama1   x(8)    aciklama1       aciklama2   x(8)    aciklama2       aciklama3   x(8)    aciklama3       aciklama4   x(8)    aciklama4       aciklama5   x(8)    aciklama5       aciklama6   x(8)    aciklama6       �  �  ���������                   �      �                �     i     	          !   /   <   G   Q   \   f   m   v   �   �   �   �   �   �   �   �                                                                                                                                                     �  �  �  �                              �  �  �  �                                                                    $  0  8  D                              H  T  \  h                              l  x  �  �                              �  �  �  �                                                                          ukayit_no   x(8)    ukayit_no       personel_kod    x(8)    personel_kod        bas_tarihi  x(8)    bas_tarihi      bas_saati   x(8)    bas_saati       bit_tarihi  x(8)    bit_tarihi      bit_saati   x(8)    bit_saati       aciklama    x(8)    aciklama        �  ���	������       �       �                �     i    	 	    �   �   <   G   Q   \   �                                                                                                                                      	                  
                                                   �  �  �  �                              �                                       ,  4  @                              D  P  X  d                              h  t  |  �                              �  �  �  �                              �  �  �  �                              �  �  �  �                              �                                          ,  4                                                                          ukayit_no   x(8)    ukayit_no       durus_kod   x(8)    durus_kod       tezgah_kod  x(8)    tezgah_kod      baslangic   x(8)    baslangic       bas_saati   x(8)    bas_saati       bit_tarihi  x(8)    bit_tarihi      bit_saati   x(8)    bit_saati       aciklama    x(8)    aciklama        sure    ->,>>>,>>9  sure    0   sirano  ->,>>>,>>9  sirano  0   �  ���������          �    �                �     i     	    �         G   Q   \   �   #  (                                                                                                                                     	                                 �  �  �                                       ,                              0  @  H  X                              \  h  p  |                              �  �  �  �                              �  �  �  �                              �  �  �  �                              �  �                                                                               ukayit_no   x(8)    ukayit_no       hurda_skod  x(8)    hurda_skod      hurda_sbirim    x(8)    hurda_sbirim        hurda_kod   x(8)    hurda_kod       aciklama    x(8)    aciklama        diger_depo  x(8)    diger_depo      parti_kod   x(8)    parti_kod       miktar  ->>,>>9.99  miktar  0   �  ���
������        �      �                �     i    
 	    �   :  E  R  �   \  g  f                                                                             t  �  �  �                              �  �  �  �                              �  �  �  �                                                                          ukayit_no   x(8)    ukayit_no       platform_kod    x(8)    platform_kod        platform_ad x(8)    platform_ad     �  ���������   �       �                �     i     	    �   }  �                                                                                                                                     	                  
                                 �  �  �  �                              �  �  �  �                              �                                      (  0  <                              @  H  P  X                              \  d  �  �                              �  �  �  �                              �  �  �  �                              �  �  �  �                                                                          Alternatif  yes/no  Alternatif  no  DepoKod X(30)   DepoKod     MalzemeKod  X(30)   MalzemeKod      MalzemeKod2 X(30)   MalzemeKod2     Birim   X(10)   Birim       KMiktar ->>>,>>>,>>>,>>>,>>9.999    KMiktar 0   FMiktar ->>>,>>>,>>>,>>>,>>9.999    FMiktar 0   PartiNo X(30)   PartiNo     MiktarSekli ->,>>>,>>9  MiktarSekli 0   �  ���������         �     �                �     i     	    �  �  �  �  �  �  �  �  �                                 ����                                �        l                    �f   �        h                    �!   �        d                    $�   �        `                    ۺ   �        \                    �   �        X                    xsundefined                                                               �       p  t   \   �                          �����           |�}        O   ����    e�          O   ����    R�          O   ����    ��      �   !  h   �                              �   3   ����       3   ����   �     j     t          4   ����@                 �                      ��                  j   m                �Y           j     L   �           X   �              � ߱            Z   k   �    �                            /   p                                  3   ����\   L        <                      3   ����|   |        l                      3   �����   �        �                      3   �����   �        �                      3   �����   �  !                             !                          <  !                          \  !                          |  !                          �  !                          $        �  �                  3   �����       $   p   �  ���                                                    � ߱        �        D  T                  3   �����       $   p   �  ���                                                    � ߱                  �  �                  3   �����       $   p     ���                                                    � ߱                C:\OpenEdge\barset\log\                     �  8   ����   �  8   ����   �  8   ����   �  8   ����   �  8   ����   �  8   ����   �  8   ����      8   ����     8   ����      8   ����       8   ����        8   ����        %      -pf     %$     C:\OpenEdge\finans2011.pf �"  
    � j   �+  %     UretimKaydi_run.r "      "      "      "      "      "      "          e   @ d d     �     	  	  � �                                                                                                                                 D                                                                
 X   d d Td                                                                 z     
 X   d (d                                                                 �       D                                                                    TXS xop_table kayit_no isemri_no operasyon_kod istasyon_kod bas_tarihi bas_saati bit_tarihi bit_saati miktar kat_sayi kat_sayi2 vardiya_kod skk_no aciklama1 aciklama2 aciklama3 aciklama4 aciklama5 aciklama6 xis_table ukayit_no personel_kod aciklama xdur_table durus_kod tezgah_kod baslangic sure sirano xhur_table hurda_skod hurda_sbirim hurda_kod diger_depo parti_kod xalet_table platform_kod platform_ad Malzemeler Alternatif DepoKod MalzemeKod MalzemeKod2 Birim KMiktar FMiktar PartiNo MiktarSekli fkod ukod logfile partikod master_no detay_satir islem_sonucu barset-log-dir C:\OpenEdge\barset\log\ barset-test-app Islem:, Zamani: x(15) 99/99/99 default MalzemeDS AletDS HurdaDS DurusDS IscilikDS OperasyonDS    4	  H   �	       �    �           d  �      �              ,  X   d      xop_table   H         T         `         p         �         �         �         �         �         �         �         �         �         �         �         �                                     kayit_no    isemri_no   operasyon_kod   istasyon_kod    bas_tarihi  bas_saati   bit_tarihi  bit_saati   miktar  kat_sayi    kat_sayi2   vardiya_kod skk_no  aciklama1   aciklama2   aciklama3   aciklama4   aciklama5   aciklama6   �  <  H     xis_table   �         �         �         �         �         �         �         ukayit_no   personel_kod    bas_tarihi  bas_saati   bit_tarihi  bit_saati   aciklama    �      
   xdur_table  �         �         �         �         �         �         �         �         �         �         ukayit_no   durus_kod   tezgah_kod  baslangic   bas_saati   bit_tarihi  bit_saati   aciklama    sure    sirano  �         xhur_table  t         �         �         �         �         �         �         �         ukayit_no   hurda_skod  hurda_sbirim    hurda_kod   aciklama    diger_depo  parti_kod   miktar  <  �  �     xalet_table                    0         ukayit_no   platform_kod    platform_ad     L  X  	   Malzemeler  �         �         �         �         �         �                                     Alternatif  DepoKod MalzemeKod  MalzemeKod2 Birim   KMiktar FMiktar PartiNo MiktarSekli @    	   0     barset-log-dir        
   T     barset-test-app �       |        fkod    �       �        ukod    �       �        logfile �       �        partikod                                               0                     H                     `                     x                     �       �        master_no   �       �        detay_satir          �        islem_sonucu          H  �  xop_table        H    xis_table   <    H  0  xdur_table  X    H  L  xhur_table  t    H  h  xalet_table       H  �  Malzemeler  �  �  MalzemeDS   �  �  AletDS  �  �  HurdaDS �  �  DurusDS �  �  IscilikDS       �  OperasyonDS h   j   k   m   p       �[  .\Include3\Baglanti.i    	  ��    $C:\OpenEdge\BarsetProxy\Prosedurler\UretimKaydi.p        d   o       t	     d      