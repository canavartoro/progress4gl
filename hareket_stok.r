	��V���Rd  8��              �                                 �  02640002utf-8 MAIN C:\OpenEdge\BarsetProxy\Prosedurler\hareket_stok.p,,INPUT fkod CHARACTER,INPUT ukod CHARACTER,INPUT bno CHARACTER,INPUT btarih CHARACTER,INPUT hkod CHARACTER,INPUT aciklama CHARACTER,INPUT StokHareketDS DATASET xhareket_table DATALINKS 0,OUTPUT master_no INTEGER,OUTPUT detay_satir INTEGER,OUTPUT islem_sonucu CHARACTER TEMP-TABLE xhareket_table 0,0 0 NO,stok_kod character 0 0,giren_depo character 1 0,cikan_depo character 2 0,miktar decimal 3 0,gelir_gider character 4 0,masraf_ad character 5 0,masraf_merkez character 6 0,analiz_kod character 7 0,parti_kod character 8 0,cari character 9 0     D                             %  D  �                            �     +             �  ? �  1  1254                             �   �                                           �              d                         �           7                            �                                                           PROGRESS                                     �          H  4     P     �\      |  
                 �              �      �   w        �             X         |        �             �         �        �             �         �                     �         �        ,             �         �        H                       p                         �        �             d         �   	     �             �         �   
                    �             >   ���� $ t                                                                                                                                                                     	                  
                                                   �  �  �  �                              �                                       $  ,  8                              <  D  P  X                              \  h  p  |                              �  �  �  �                              �  �  �  �                              �  �  �  �                              �                                          (  0                                                                          stok_kod    x(8)    stok_kod        giren_depo  x(8)    giren_depo      cikan_depo  x(8)    cikan_depo      miktar  ->>,>>9.99  miktar  0   gelir_gider x(8)    gelir_gider     masraf_ad   x(8)    masraf_ad       masraf_merkez   x(8)    masraf_merkez       analiz_kod  x(8)    analiz_kod      parti_kod   x(8)    parti_kod       cari    x(8)    cari        �  ���������          �                    �     i     	          '   2   9   E   O   ]   h   r                                  ����                                #        �                    �Nundefined                                                               �       �  t   \   �                          �����           ��h        O   ����    e�          O   ����    R�          O   ����    ��      �   !  )   �                              �   3   ����       3   ����   �     +     t          4   ����@                 �                      ��                  +   .               `�o           +     L   �           X   �              � ߱            Z   ,   �    �                        `     1   �  4          4   ����\   |                          � ߱            $   1     ���                            /   3   �     �                          3   �����   �        �                      3   �����   �        �                      3   �����   ,                              3   �����   \        L                      3   �����   �        |                      3   �����   �        �                      3   �����   �  !                           d        �                    3   �����       $   3   8  ���                                                    � ߱        �        �  �                  3   �����       $   3   �  ���                                  	       	           � ߱                                      3   ����      $   3   H  ���                                  
       
           � ߱                  C:\OpenEdge\barset\log\        8   ����        8   ����        %      -pf     %$     C:\OpenEdge\finans2011.pf ~"      � �    ~+      "    q�     �    q%     hareket_stok_run "      "      "      "      "      "      "      "  	    "  
        e   @ d d     �     	  	  � �                                                                                                                                 D                                                                
 X   d d Td                                                                      
 X   d (d                                                                 
       D                                                                    TXS xhareket_table stok_kod giren_depo cikan_depo miktar gelir_gider masraf_ad masraf_merkez analiz_kod parti_kod cari fkod ukod bno btarih hkod aciklama master_no detay_satir islem_sonucu barset-log-dir C:\OpenEdge\barset\log\ barset-test-app Islem:, Zamani: x(15) 99/99/99  ST-501 default StokHareketDS    X  H   �       �             T  �  �                        X   h   
   xhareket_table  �          �          �                                     $         4         @         L         stok_kod    giren_depo  cikan_depo  miktar  gelir_gider masraf_ad   masraf_merkez   analiz_kod  parti_kod   cari    x       h     barset-log-dir           �     barset-test-app �       �        fkod    �       �        ukod    �       �        bno                btarih  8       0        hkod    \       P        aciklama    t                     �       �        master_no   �    	   �        detay_satir       
   �        islem_sonucu            H  �  xhareket_table        StokHareketDS   )   +   ,   .   1   3       �[  .\Include3\Baglanti.i    4  ��    $C:\OpenEdge\BarsetProxy\Prosedurler\hareket_stok.p       %   0       �     %      