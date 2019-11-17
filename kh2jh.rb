#!/usr/bin/ruby

JP_WORD_TABLE = [
    #  ㅏ ㅐ ㅑ  ㅒ   ㅓ ㅔ ㅕ  ㅖ   ㅗ ㅘ   ㅙ  ㅚ  ㅛ   ㅜ ㅝ   ㅞ  ㅟ  ㅠ   ㅡ ㅢ  ㅣ
    %w(が げ ぎゃ ぎぇ ご げ ぎょ ぎぇ ご ごぁ きぇ ごぇ ぎょ ぐ ぐぉ ぐえ ぐぃ ぎゅ ぐ ぐい ぎ), # ㄱ
    %w(な ね にゃ しぇ の ね にょ にぇ の のぁ にぇ のぇ にょ ぬ ぬぉ ぬえ ぬぃ にゅ ぬ ぬい に), # ㄴ
    %w(だ で ぢゃ ぢぇ ど で ぢょ ぢぇ ど どぁ ぢぇ どぇ ぢょ づ づぉ づえ づぃ ぢゅ ど づい ぢ), # ㄷ
    %w(ら れ りゃ ふぇ ろ れ りょ ふぇ ろ ろぁ りぇ ろぇ りょ る るぉ るえ るぃ りゅ る るい り), # ㄹ
    %w(ま め みゃ みぇ も め みょ みぇ も もぁ みぇ もぇ みょ む むぉ むえ むぃ みゅ む むい み), # ㅁ
    %w(ば べ びゃ びぇ ぼ べ びょ びぇ ぼ ぼぁ びぇ ぼぇ びょ ぶ ぶぉ ぶえ ぶぃ びゅ ぶ ぶい び), # ㅂ
    %w(さ せ しゃ しぇ そ せ しょ しぇ そ そぁ しぇ そぇ しょ す すぉ すえ すぃ しゅ す すい し), # ㅅ
    %w(あ え や いぇ お え よ いぇ お わ おえ おぃ よ う うぉ うえ うぃ ゆ う うい い), # ㅇ
    %w(じゃ じぇ じゃ じぇ じょ じぇ じょ じぇ じょ じょあ しぇ じぇ じょ じゅ じゅ じゅえ じゅい じゅ じゅ じゅい じ), # ㅈ
    %w(ちゃ ちぇ ちゃ ちぇ ちょ ちぇ ちょ ちゅえ ちょ ちょあ ちぇ ちぇ ちょ ちゅ ちゅ つえ ちゅい ちゅ つ ちゅい ち), # ㅊ
    %w(か け きゃ きぇ こ け きょ きぇ こ こあ きぇ こぇ きょ く くぉ くえ くぃ きゅ く くい き), # ㅋ
    %w(た て ちゃ ちぇ と て ちょ ちぇ と とあ ちぇ とい ちょ つ つぉ つえ つぃ ちゅ つ つい ち), # ㅌ
    %w(ぱ ぺ ぴゃ ぴぇ ぽ ぺ ぴょ ぴぇ ぽ ぽあ ぴぇ ぴぇ ぴょ ぷ ぷぉ ぷえ ぷぃ ぴゅ ぷ ぷい ぴ), # ㅍ
    %w(は へ ひゃ ひぇ ほ へ ひょ ひぇ ほ ほあ ほえ ほい ひょ ふ ふぉ ふえ ふぃ ひゅ ふ ふい ひ) # ㅎ
]
JP_BADCHIM_TABLE = ['', "ぐ", "ぐ", "ぐ", "ん", "ん", "ん", "っ", "る", "ぐ", "ん", "ぶ", "る", "っ", "ぶ", "る", "ん", "ぶ", "ぶ", "っ", "っ", "ん", "っ", "っ", "く", "っ", "っ", "ぷ"]
KR_WORD_CODE_FIRST = '가'.ord
KR_WORD_CODE_LAST = '힣'.ord
KR_CONSONANT_FIRST = 'ㄱ'.ord
KR_CONSONANT_LAST = 'ㅎ'.ord
KR_VOWEL_FIRST = 'ㅏ'.ord
KR_VOWEL_LAST = 'ㅣ'.ord

def is_korean_word(char)
  char_ord = char.ord
  char_ord >= KR_WORD_CODE_FIRST and char_ord <= KR_WORD_CODE_LAST
end

def is_korean_consonant(char)
  char_ord = char.ord
  char_ord >= KR_CONSONANT_FIRST and char_ord <= KR_CONSONANT_LAST
end

def is_korean_vowel(char)
  char_ord = char.ord
  char_ord >= KR_VOWEL_FIRST and char_ord <= KR_VOWEL_LAST
end

def get_consonant_index_by_korean(char)
  char_ord = char.ord
  index = ((char_ord - KR_WORD_CODE_FIRST) / 28.0 / 21.0).floor
  if index > 0 then index -= 1 end # ㄲ
  if index > 3 then index -= 1 end # ㄸ
  if index > 5 then index -= 1 end # ㅃ
  if index > 6 then index -= 1 end # ㅆ
  if index > 8 then index -= 1 end # ㅉ
  index
end

def get_vowel_index_by_korean(char)
  char_ord = char.ord
  (((char_ord - KR_WORD_CODE_FIRST) / 28.0) % 21).floor
end

def get_badchim_index_by_korean(char)
  char_ord = char.ord
  (char_ord - KR_WORD_CODE_FIRST) % 28
end

def get_hiragana_by_korean(korean)
  korean.chars.map { |char|
    if is_korean_word(char)
      consonant_index = get_consonant_index_by_korean(char)
      vowel_index = get_vowel_index_by_korean(char)
      badchim_index = get_badchim_index_by_korean(char)
      badchim = badchim_index ? JP_BADCHIM_TABLE[badchim_index] : ''
      JP_WORD_TABLE[consonant_index][vowel_index] + badchim
    elsif is_korean_consonant(char)
      _consonant_index = char.ord - KR_CONSONANT_FIRST
      consonant_index = _consonant_index
      if _consonant_index > 0 then consonant_index -= 1 end # ㄲ
      if _consonant_index > 1 then consonant_index -= 1 end # ㄳ
      if _consonant_index > 3 then consonant_index -= 1 end # ㄵ
      if _consonant_index > 4 then consonant_index -= 1 end # ㄶ
      if _consonant_index > 6 then consonant_index -= 1 end # ㄸ
      if _consonant_index > 8 then consonant_index -= 1 end # ㄺ
      if _consonant_index > 9 then consonant_index -= 1 end # ㄻ
      if _consonant_index > 10 then consonant_index -= 1 end # ㄼ
      if _consonant_index > 11 then consonant_index -= 1 end # ㄽ
      if _consonant_index > 12 then consonant_index -= 1 end # ㄾ
      if _consonant_index > 13 then consonant_index -= 1 end # ㄿ
      if _consonant_index > 14 then consonant_index -= 1 end # ㅀ
      if _consonant_index > 17 then consonant_index -= 1 end # ㅃ
      if _consonant_index > 18 then consonant_index -= 1 end # ㅄ
      if _consonant_index > 20 then consonant_index -= 1 end # ㅆ
      if _consonant_index > 23 then consonant_index -= 1 end # ㅉ
      JP_WORD_TABLE[consonant_index][18]
    elsif is_korean_vowel(char)
      vowel_index = char.ord - KR_VOWEL_FIRST
      JP_WORD_TABLE[7][vowel_index]
    elsif char == '-'
      'ー'
    elsif char == ' '
      '  '
    elsif char == '.'
      '。'
    else
      char
    end
  }.join('')
end

ARGV.map do |text|
  message = get_hiragana_by_korean(text)
  puts message
  puts `say #{message} -v kyoko`
end
