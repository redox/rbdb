require 'ostruct'

module Collation
  COLLATIONS = [
    {:label => 'armscii8', :title => 'ARMSCII-8 Armenian', :values => [
      {:title => 'Armenian, Binary', :value => 'armscii8_bin'},
      {:title => 'Armenian, case-insensitive', :value => 'armscii8_general_ci'}
    ]},
    {:label => "ascii", :title => "US ASCII", :values => [
      {:title => "West European (multilingual), Binary", :value => "ascii_bin"},
      {:title => "West European (multilingual), case-insensitive", :value => "ascii_general_ci"},
    ]},
    {:label => "big5", :title => "Big5 Traditional Chinese", :values => [
      {:title => "Traditional Chinese, Binary", :value => "big5_bin"},
      {:title => "Traditional Chinese, case-insensitive", :value => "big5_chinese_ci"},
    ]},
    {:label => "binary", :title => "Binary pseudo charset", :values => [
      {:title => "Binary", :value => "binary"},
    ]},
    {:label => "cp1250", :title => "Windows Central European", :values => [
      {:title => "Central European (multilingual), Binary", :value => "cp1250_bin"},
      {:title => "Croatian, case-insensitive", :value => "cp1250_croatian_ci"},
      {:title => "Czech, case-sensitive", :value => "cp1250_czech_cs"},
      {:title => "Central European (multilingual), case-insensitive", :value => "cp1250_general_ci"},
    ]},
    {:label => "cp1251", :title => "Windows Cyrillic", :values => [
      {:title => "Cyrillic (multilingual), Binary", :value => "cp1251_bin"},
      {:title => "Bulgarian, case-insensitive", :value => "cp1251_bulgarian_ci"},
      {:title => "Cyrillic (multilingual), case-insensitive", :value => "cp1251_general_ci"},
      {:title => "Cyrillic (multilingual), case-sensitive", :value => "cp1251_general_cs"},
      {:title => "Ukrainian, case-insensitive", :value => "cp1251_ukrainian_ci"},
    ]},
    {:label => "cp1256", :title => "Windows Arabic", :values => [
      {:title => "Arabic, Binary", :value => "cp1256_bin"},
      {:title => "Arabic, case-insensitive", :value => "cp1256_general_ci"},
    ]},
    {:label => "cp1257", :title => "Windows Baltic", :values => [
      {:title => "Baltic (multilingual), Binary", :value => "cp1257_bin"},
      {:title => "Baltic (multilingual), case-insensitive", :value => "cp1257_general_ci"},
      {:title => "Lithuanian, case-insensitive", :value => "cp1257_lithuanian_ci"},
    ]},
    {:label => "cp850", :title => "DOS West European", :values => [
      {:title => "West European (multilingual), Binary", :value => "cp850_bin"},
      {:title => "West European (multilingual), case-insensitive", :value => "cp850_general_ci"},
    ]},
    {:label => "cp852", :title => "DOS Central European", :values => [
      {:title => "Central European (multilingual), Binary", :value => "cp852_bin"},
      {:title => "Central European (multilingual), case-insensitive", :value => "cp852_general_ci"},
    ]},
    {:label => "cp866", :title => "DOS Russian", :values => [
      {:title => "Russian, Binary", :value => "cp866_bin"},
      {:title => "Russian, case-insensitive", :value => "cp866_general_ci"},
    ]},
    {:label => "cp932", :title => "SJIS for Windows Japanese", :values => [
      {:title => "Japanese, Binary", :value => "cp932_bin"},
      {:title => "Japanese, case-insensitive", :value => "cp932_japanese_ci"},
    ]},
    {:label => "dec8", :title => "DEC West European", :values => [
      {:title => "West European (multilingual), Binary", :value => "dec8_bin"},
      {:title => "Swedish, case-insensitive", :value => "dec8_swedish_ci"},
    ]},
    {:label => "eucjpms", :title => "UJIS for Windows Japanese", :values => [
      {:title => "Japanese, Binary", :value => "eucjpms_bin"},
      {:title => "Japanese, case-insensitive", :value => "eucjpms_japanese_ci"},
    ]},
    {:label => "euckr", :title => "EUC-KR Korean", :values => [
      {:title => "Korean, Binary", :value => "euckr_bin"},
      {:title => "Korean, case-insensitive", :value => "euckr_korean_ci"},
    ]},
    {:label => "gb2312", :title => "GB2312 Simplified Chinese", :values => [
      {:title => "Simplified Chinese, Binary", :value => "gb2312_bin"},
      {:title => "Simplified Chinese, case-insensitive", :value => "gb2312_chinese_ci"},
    ]},
    {:label => "gbk", :title => "GBK Simplified Chinese", :values => [
      {:title => "Simplified Chinese, Binary", :value => "gbk_bin"},
      {:title => "Simplified Chinese, case-insensitive", :value => "gbk_chinese_ci"},
    ]},
    {:label => "geostd8", :title => "GEOSTD8 Georgian", :values => [
      {:title => "Georgian, Binary", :value => "geostd8_bin"},
      {:title => "Georgian, case-insensitive", :value => "geostd8_general_ci"},
    ]},
    {:label => "greek", :title => "ISO 8859-7 Greek", :values => [
      {:title => "Greek, Binary", :value => "greek_bin"},
      {:title => "Greek, case-insensitive", :value => "greek_general_ci"},
    ]},
    {:label => "hebrew", :title => "ISO 8859-8 Hebrew", :values => [
      {:title => "Hebrew, Binary", :value => "hebrew_bin"},
      {:title => "Hebrew, case-insensitive", :value => "hebrew_general_ci"},
    ]},
    {:label => "hp8", :title => "HP West European", :values => [
      {:title => "West European (multilingual), Binary", :value => "hp8_bin"},
      {:title => "English, case-insensitive", :value => "hp8_english_ci"},
    ]},
    {:label => "keybcs2", :title => "DOS Kamenicky Czech-Slovak", :values => [
      {:title => "Czech-Slovak, Binary", :value => "keybcs2_bin"},
      {:title => "Czech-Slovak, case-insensitive", :value => "keybcs2_general_ci"},
    ]},
    {:label => "koi8r", :title => "KOI8-R Relcom Russian", :values => [
      {:title => "Russian, Binary", :value => "koi8r_bin"},
      {:title => "Russian, case-insensitive", :value => "koi8r_general_ci"},
    ]},
    {:label => "koi8u", :title => "KOI8-U Ukrainian", :values => [
      {:title => "Ukrainian, Binary", :value => "koi8u_bin"},
      {:title => "Ukrainian, case-insensitive", :value => "koi8u_general_ci"},
    ]},
    {:label => "latin1", :title => "cp1252 West European", :values => [
      {:title => "West European (multilingual), Binary", :value => "latin1_bin"},
      {:title => "Danish, case-insensitive", :value => "latin1_danish_ci"},
      {:title => "West European (multilingual), case-insensitive", :value => "latin1_general_ci"},
      {:title => "West European (multilingual), case-sensitive", :value => "latin1_general_cs"},
      {:title => "German (dictionary), case-insensitive", :value => "latin1_german1_ci"},
      {:title => "German (phone book), case-insensitive", :value => "latin1_german2_ci"},
      {:title => "Spanish, case-insensitive", :value => "latin1_spanish_ci"},
      {:title => "Swedish, case-insensitive", :value => "latin1_swedish_ci"},
    ]},
    {:label => "latin2", :title => "ISO 8859-2 Central European", :values => [
      {:title => "Central European (multilingual), Binary", :value => "latin2_bin"},
      {:title => "Croatian, case-insensitive", :value => "latin2_croatian_ci"},
      {:title => "Czech, case-sensitive", :value => "latin2_czech_cs"},
      {:title => "Central European (multilingual), case-insensitive", :value => "latin2_general_ci"},
      {:title => "Hungarian, case-insensitive", :value => "latin2_hungarian_ci"},
    ]},
    {:label => "latin5", :title => "ISO 8859-9 Turkish", :values => [
      {:title => "Turkish, Binary", :value => "latin5_bin"},
      {:title => "Turkish, case-insensitive", :value => "latin5_turkish_ci"},
    ]},
    {:label => "latin7", :title => "ISO 8859-13 Baltic", :values => [
      {:title => "Baltic (multilingual), Binary", :value => "latin7_bin"},
      {:title => "Estonian, case-sensitive", :value => "latin7_estonian_cs"},
      {:title => "Baltic (multilingual), case-insensitive", :value => "latin7_general_ci"},
      {:title => "Baltic (multilingual), case-sensitive", :value => "latin7_general_cs"},
    ]},
    {:label => "macce", :title => "Mac Central European", :values => [
      {:title => "Central European (multilingual), Binary", :value => "macce_bin"},
      {:title => "Central European (multilingual), case-insensitive", :value => "macce_general_ci"},
    ]},
    {:label => "macroman", :title => "Mac West European", :values => [
      {:title => "West European (multilingual), Binary", :value => "macroman_bin"},
      {:title => "West European (multilingual), case-insensitive", :value => "macroman_general_ci"},
    ]},
    {:label => "sjis", :title => "Shift-JIS Japanese", :values => [
      {:title => "Japanese, Binary", :value => "sjis_bin"},
      {:title => "Japanese, case-insensitive", :value => "sjis_japanese_ci"},
    ]},
    {:label => "swe7", :title => "7bit Swedish", :values => [
      {:title => "Swedish, Binary", :value => "swe7_bin"},
      {:title => "Swedish, case-insensitive", :value => "swe7_swedish_ci"},
    ]},
    {:label => "tis620", :title => "TIS620 Thai", :values => [
      {:title => "Thai, Binary", :value => "tis620_bin"},
      {:title => "Thai, case-insensitive", :value => "tis620_thai_ci"},
    ]},
    {:label => "ucs2", :title => "UCS-2 Unicode", :values => [
      {:title => "Unicode (multilingual), Binary", :value => "ucs2_bin"},
      {:title => "Czech, case-insensitive", :value => "ucs2_czech_ci"},
      {:title => "Danish, case-insensitive", :value => "ucs2_danish_ci"},
      {:title => "Esperanto, case-insensitive", :value => "ucs2_esperanto_ci"},
      {:title => "Estonian, case-insensitive", :value => "ucs2_estonian_ci"},
      {:title => "Unicode (multilingual), case-insensitive", :value => "ucs2_general_ci"},
      {:title => "Hungarian, case-insensitive", :value => "ucs2_hungarian_ci"},
      {:title => "Icelandic, case-insensitive", :value => "ucs2_icelandic_ci"},
      {:title => "Latvian, case-insensitive", :value => "ucs2_latvian_ci"},
      {:title => "Lithuanian, case-insensitive", :value => "ucs2_lithuanian_ci"},
      {:title => "Persian, case-insensitive", :value => "ucs2_persian_ci"},
      {:title => "Polish, case-insensitive", :value => "ucs2_polish_ci"},
      {:title => "West European, case-insensitive", :value => "ucs2_roman_ci"},
      {:title => "Romanian, case-insensitive", :value => "ucs2_romanian_ci"},
      {:title => "Slovak, case-insensitive", :value => "ucs2_slovak_ci"},
      {:title => "Slovenian, case-insensitive", :value => "ucs2_slovenian_ci"},
      {:title => "Traditional Spanish, case-insensitive", :value => "ucs2_spanish2_ci"},
      {:title => "Spanish, case-insensitive", :value => "ucs2_spanish_ci"},
      {:title => "Swedish, case-insensitive", :value => "ucs2_swedish_ci"},
      {:title => "Turkish, case-insensitive", :value => "ucs2_turkish_ci"},
      {:title => "Unicode (multilingual), case-insensitive", :value => "ucs2_unicode_ci"},
    ]},
    {:label => "ujis", :title => "EUC-JP Japanese", :values => [
      {:title => "Japanese, Binary", :value => "ujis_bin"},
      {:title => "Japanese, case-insensitive", :value => "ujis_japanese_ci"},
    ]},
    {:label => "utf8", :title => "UTF-8 Unicode", :values => [
      {:title => "Unicode (multilingual), Binary", :value => "utf8_bin"},
      {:title => "Czech, case-insensitive", :value => "utf8_czech_ci"},
      {:title => "Danish, case-insensitive", :value => "utf8_danish_ci"},
      {:title => "Esperanto, case-insensitive", :value => "utf8_esperanto_ci"},
      {:title => "Estonian, case-insensitive", :value => "utf8_estonian_ci"},
      {:title => "Unicode (multilingual), case-insensitive", :value => "utf8_general_ci"},
      {:title => "Hungarian, case-insensitive", :value => "utf8_hungarian_ci"},
      {:title => "Icelandic, case-insensitive", :value => "utf8_icelandic_ci"},
      {:title => "Latvian, case-insensitive", :value => "utf8_latvian_ci"},
      {:title => "Lithuanian, case-insensitive", :value => "utf8_lithuanian_ci"},
      {:title => "Persian, case-insensitive", :value => "utf8_persian_ci"},
      {:title => "Polish, case-insensitive", :value => "utf8_polish_ci"},
      {:title => "West European, case-insensitive", :value => "utf8_roman_ci"},
      {:title => "Romanian, case-insensitive", :value => "utf8_romanian_ci"},
      {:title => "Slovak, case-insensitive", :value => "utf8_slovak_ci"},
      {:title => "Slovenian, case-insensitive", :value => "utf8_slovenian_ci"},
      {:title => "Traditional Spanish, case-insensitive", :value => "utf8_spanish2_ci"},
      {:title => "Spanish, case-insensitive", :value => "utf8_spanish_ci"},
      {:title => "Swedish, case-insensitive", :value => "utf8_swedish_ci"},
      {:title => "Turkish, case-insensitive", :value => "utf8_turkish_ci"},
      {:title => "Unicode (multilingual), case-insensitive", :value => "utf8_unicode_ci"},
    ]},    
  ]
  Collations = COLLATIONS.map do |group|
    values = group.delete :values
    v = OpenStruct.new group
    v.values = values.map { |col| OpenStruct.new col }
    v
  end
end