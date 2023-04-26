//
//  Enums.Voices.swift
//  sugah
//
//  Created by Rodi on 2/6/23.
//

import Foundation
import BackgroundTasks




/*
 
 
 Language Name   Quality       Identifier                                       Class
 ar-SA    Maged     Default    com.apple.ttsbundle.Maged-compact                AVSpeechSynthesisVoice
 cs-CZ    Zuzana    Default    com.apple.ttsbundle.Zuzana-compact               AVSpeechSynthesisVoice

 da-DK    Sara      Default    com.apple.ttsbundle.Sara-compact                 AVSpeechSynthesisVoice
 de-DE    Anna      Default    com.apple.ttsbundle.Anna-compact                 AVSpeechSynthesisVoice
 de-DE    Helena    Default    com.apple.ttsbundle.siri_female_de-DE_compact    AVSpeechSynthesisVoice
 de-DE    Martin    Default    com.apple.ttsbundle.siri_male_de-DE_compact      AVSpeechSynthesisVoice
 
====== 14 english voices
 
 el-GR    Melina    Default    com.apple.ttsbundle.Melina-compact               AVSpeechSynthesisVoice
 en-AU    Catherine Default    com.apple.ttsbundle.siri_female_en-AU_compact    AVSpeechSynthesisVoice
 en-AU    Gordon    Default    com.apple.ttsbundle.siri_male_en-AU_compact      AVSpeechSynthesisVoice
 en-AU    Karen     Default    com.apple.ttsbundle.Karen-compact                AVSpeechSynthesisVoice
 en-GB    Arthur    Default    com.apple.ttsbundle.siri_male_en-GB_compact      AVSpeechSynthesisVoice
 en-GB    Daniel    Default    com.apple.ttsbundle.Daniel-compact               AVSpeechSynthesisVoice
 en-GB    Martha    Default    com.apple.ttsbundle.siri_female_en-GB_compact    AVSpeechSynthesisVoice
 en-IE    Moira     Default    com.apple.ttsbundle.Moira-compact                AVSpeechSynthesisVoice
 en-IN    Rishi     Default    com.apple.ttsbundle.Rishi-compact                AVSpeechSynthesisVoice
 en-US    Aaron     Default    com.apple.ttsbundle.siri_male_en-US_compact      AVSpeechSynthesisVoice
 en-US    Fred      Default    com.apple.speech.synthesis.voice.Fred            AVSpeechSynthesisVoice
 en-US    Nicky     Default    com.apple.ttsbundle.siri_female_en-US_compact    AVSpeechSynthesisVoice
 en-US    Samantha  Default    com.apple.ttsbundle.Samantha-compact             AVSpeechSynthesisVoice
 en-ZA    Tessa     Default    com.apple.ttsbundle.Tessa-compact                AVSpeechSynthesisVoice
 
 es-ES    Mónica    Default    com.apple.ttsbundle.Monica-compact               AVSpeechSynthesisVoice
 es-MX    Paulina   Default    com.apple.ttsbundle.Paulina-compact              AVSpeechSynthesisVoice
 
 fi-FI    Satu      Default    com.apple.ttsbundle.Satu-compact                 AVSpeechSynthesisVoice
 
 fr-CA    Amélie    Default    com.apple.ttsbundle.Amelie-compact               AVSpeechSynthesisVoice
 fr-FR    Daniel    Default    com.apple.ttsbundle.siri_male_fr-FR_compact      AVSpeechSynthesisVoice
 fr-FR    Marie     Default    com.apple.ttsbundle.siri_female_fr-FR_compact    AVSpeechSynthesisVoice
 fr-FR    Thomas    Default    com.apple.ttsbundle.Thomas-compact               AVSpeechSynthesisVoice
 
 he-IL    Carmit    Default    com.apple.ttsbundle.Carmit-compact               AVSpeechSynthesisVoice
 
 hi-IN    Lekha     Default    com.apple.ttsbundle.Lekha-compact                AVSpeechSynthesisVoice
 
 hu-HU    Mariska   Default    com.apple.ttsbundle.Mariska-compact              AVSpeechSynthesisVoice
 
 id-ID    Damayanti Default    com.apple.ttsbundle.Damayanti-compact            AVSpeechSynthesisVoice
 
 it-IT    Alice     Default    com.apple.ttsbundle.Alice-compact                AVSpeechSynthesisVoice
 
 ja-JP    Hattori   Default    com.apple.ttsbundle.siri_male_ja-JP_compact      AVSpeechSynthesisVoice
 ja-JP    Kyoko     Default    com.apple.ttsbundle.Kyoko-compact                AVSpeechSynthesisVoice
 ja-JP    O-ren     Default    com.apple.ttsbundle.siri_female_ja-JP_compact    AVSpeechSynthesisVoice
 
 ko-KR    Yuna      Default    com.apple.ttsbundle.Yuna-compact                 AVSpeechSynthesisVoice
 
 nl-BE    Ellen     Default    com.apple.ttsbundle.Ellen-compact                AVSpeechSynthesisVoice
 nl-NL    Xander    Default    com.apple.ttsbundle.Xander-compact               AVSpeechSynthesisVoice
 
 no-NO    Nora      Default    com.apple.ttsbundle.Nora-compact                 AVSpeechSynthesisVoice
 
 pl-PL    Zosia     Default    com.apple.ttsbundle.Zosia-compact                AVSpeechSynthesisVoice
 
 pt-BR    Luciana   Default    com.apple.ttsbundle.Luciana-compact              AVSpeechSynthesisVoice
 pt-PT    Joana     Default    com.apple.ttsbundle.Joana-compact                AVSpeechSynthesisVoice
 
 ro-RO    Ioana     Default    com.apple.ttsbundle.Ioana-compact                AVSpeechSynthesisVoice
 
 ru-RU    Milena    Default    com.apple.ttsbundle.Milena-compact               AVSpeechSynthesisVoice
 
 sk-SK    Laura     Default    com.apple.ttsbundle.Laura-compact                AVSpeechSynthesisVoice
 
 sv-SE    Alva      Default    com.apple.ttsbundle.Alva-compact                 AVSpeechSynthesisVoice
 
 th-TH    Kanya     Default    com.apple.ttsbundle.Kanya-compact                AVSpeechSynthesisVoice
 
 tr-TR    Yelda     Default    com.apple.ttsbundle.Yelda-compact                AVSpeechSynthesisVoice
 
 zh-CN    Li-mu     Default    com.apple.ttsbundle.siri_male_zh-CN_compact      AVSpeechSynthesisVoice
 zh-CN    Tian-Tian Default    com.apple.ttsbundle.Ting-Ting-compact            AVSpeechSynthesisVoice
 zh-CN    Yu-shu    Default    com.apple.ttsbundle.siri_female_zh-CN_compact    AVSpeechSynthesisVoice
 zh-HK    Sin-Ji    Default    com.apple.ttsbundle.Sin-Ji-compact               AVSpeechSynthesisVoice
 zh-TW    Mei-Jia   Default    com.apple.ttsbundle.Mei-Jia-compact              AVSpeechSynthesisVoice
 
 en-US    Alex      Enhanced   com.apple.speech.voice.Alex                      AVAlexSpeechSynthesisVoice
 
 


*/



/*
 
 2023-01-03 10:34:43.167657-0800 Sugah[63196:13074604] [strings] ERROR: Daria not found in table SpeechVoiceNames of bundle CFBundle 0x158d0d370 </Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/TextToSpeech.framework> (not loaded)
 
 2023-01-03 10:34:43.170603-0800 Sugah[63196:13074604] [strings] ERROR: Zosia not found in table SpeechVoiceNames of bundle CFBundle 0x158d0d370 </Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/TextToSpeech.framework> (not loaded)
 
 
 [[AVSpeechSynthesisVoice 0x6000029903f0]
 
 Language: ar-001, Name: Majed, Quality: Default [com.apple.voice.compact.ar-001.Maged], [AVSpeechSynthesisVoice 0x600002990140]
 
 Language: bg-BG, Name: DARIA, Quality: Default [com.apple.voice.compact.bg-BG.Daria], [AVSpeechSynthesisVoice 0x600002990080]
 
 Language: ca-ES, Name: Montse, Quality: Default [com.apple.voice.compact.ca-ES.Montserrat], [AVSpeechSynthesisVoice 0x600002990190]
 
 Language: cs-CZ, Name: Zuzana, Quality: Default [com.apple.voice.compact.cs-CZ.Zuzana], [AVSpeechSynthesisVoice 0x600002990160]
 
 Language: da-DK, Name: Sara, Quality: Default [com.apple.voice.compact.da-DK.Sara], [AVSpeechSynthesisVoice 0x600002990460]
 
 Language: de-DE, Name: Anna, Quality: Default [com.apple.voice.compact.de-DE.Anna], [AVSpeechSynthesisVoice 0x6000029900c0]
 
 Language: el-GR, Name: Melina, Quality: Default [com.apple.voice.compact.el-GR.Melina], [AVSpeechSynthesisVoice 0x600002990170]
 
 Language: en-AU, Name: Karen, Quality: Default [com.apple.voice.compact.en-AU.Karen], [AVSpeechSynthesisVoice 0x600002990410]
 
 Language: en-GB, Name: Daniel, Quality: Default [com.apple.voice.compact.en-GB.Daniel], [AVSpeechSynthesisVoice 0x6000029904a0]
 
 Language:en-IE, Name: Moira, Quality: Default [com.apple.voice.compact.en-IE.Moira], [AVSpeechSynthesisVoice 0x600002990480]
 
 Language:en-IN, Name: Rishi, Quality: Default [com.apple.voice.compact.en-IN.Rishi], [AVSpeechSynthesisVoice 0x600002990040]
 
 Language: en-US, Name: Monster, Quality: Default [com.apple.speech.synthesis.voice.Trinoids], [AVSpeechSynthesisVoice 0x600002990070]
 
 Language:en-US, Name: Albert, Quality: Default [com.apple.speech.synthesis.voice.Albert], [AVSpeechSynthesisVoice 0x600002990100]
 
 Language: en-US, Name: Spaßvogel, Quality: Default [com.apple.speech.synthesis.voice.Hysterical], [AVSpeechSynthesisVoice 0x600002990120]
 
 Language:en-US, Name: Samantha, Quality: Default [com.apple.voice.compact.en-US.Samantha], [AVSpeechSynthesisVoice 0x600002990130]
 
 Language: en-US, Name: Flüstern, Quality: Default [com.apple.speech.synthesis.voice.Whisper], [AVSpeechSynthesisVoice 0x6000029901a0]
 
 Language:en-US, Name: Superstar, Quality: Default [com.apple.speech.synthesis.voice.Princess], [AVSpeechSynthesisVoice 0x6000029901e0]
 
 Language: en-US, Name: Glocken, Quality: Default [com.apple.speech.synthesis.voice.Bells], [AVSpeechSynthesisVoice 0x600002990240]
 
 Language:en-US, Name: Orgel, Quality: Default [com.apple.speech.synthesis.voice.Organ], [AVSpeechSynthesisVoice 0x600002990270]
 
 Language: en-US, Name: Schlechte Neuigkeiten, Quality: Default [com.apple.speech.synthesis.voice.BadNews], [AVSpeechSynthesisVoice 0x600002990280]
 
 Language:en-US, Name: Seifenblasen, Quality: Default [com.apple.speech.synthesis.voice.Bubbles], [AVSpeechSynthesisVoice 0x600002990290]
 
 Language: en-US, Name: Junior, Quality: Default [com.apple.speech.synthesis.voice.Junior], [AVSpeechSynthesisVoice 0x6000029902b0]
 
 Language:en-US, Name: Bahh, Quality: Default [com.apple.speech.synthesis.voice.Bahh], [AVSpeechSynthesisVoice 0x6000029902c0]
 
 Language: en-US, Name: Wobble, Quality: Default [com.apple.speech.synthesis.voice.Deranged], [AVSpeechSynthesisVoice 0x600002990300]
 
 Language: en-US, Name: Boing, Quality: Default [com.apple.speech.synthesis.voice.Boing], [AVSpeechSynthesisVoice 0x600002990320]
 
 Language:en-US, Name: Gute Neuigkeiten, Quality: Default [com.apple.speech.synthesis.voice.GoodNews], [AVSpeechSynthesisVoice 0x600002990380]
 
 Language: en-US, Name: Zarvox, Quality: Default [com.apple.speech.synthesis.voice.Zarvox], [AVSpeechSynthesisVoice 0x6000029903a0]
 
 Language:en-US, Name: Ralph, Quality: Default [com.apple.speech.synthesis.voice.Ralph], [AVSpeechSynthesisVoice 0x6000029903d0]
 
 Language: en-US, Name: Cellos, Quality: Default [com.apple.speech.synthesis.voice.Cellos], [AVSpeechSynthesisVoice 0x600002990430]

 Language:en-US, Name: Katrin, Quality: Default [com.apple.speech.synthesis.voice.Kathy], [AVSpeechSynthesisVoice 0x600002990450]
 
 Language: en-US, Name: Fred, Quality: Default [com.apple.speech.synthesis.voice.Fred], [AVSpeechSynthesisVoice 0x6000029901b0]
 
 Language:en-ZA, Name: Tessa, Quality: Default [com.apple.voice.compact.en-ZA.Tessa], [AVSpeechSynthesisVoice 0x600002990400]
 
 Language: es-ES, Name: Mónica, Quality: Default [com.apple.voice.compact.es-ES.Monica], [AVSpeechSynthesisVoice 0x600002990470]

 Language:es-MX, Name: Paulina, Quality: Default [com.apple.voice.compact.es-MX.Paulina], [AVSpeechSynthesisVoice 0x6000029902a0]
 
 Language: fi-FI, Name: Satu, Quality: Default [com.apple.voice.compact.fi-FI.Satu], [AVSpeechSynthesisVoice 0x600002990220]
 
 Language:fr-CA, Name: Amélie, Quality: Default [com.apple.voice.compact.fr-CA.Amelie], [AVSpeechSynthesisVoice 0x6000029900f0]
 
 Language: fr-FR, Name: Thomas, Quality: Default [com.apple.voice.compact.fr-FR.Thomas], [AVSpeechSynthesisVoice 0x600002990370]
 
 Language:he-IL, Name: Carmit, Quality: Default [com.apple.voice.compact.he-IL.Carmit], [AVSpeechSynthesisVoice 0x6000029900d0]
 
 Language: hi-IN, Name: Lekha, Quality: Default [com.apple.voice.compact.hi-IN.Lekha], [AVSpeechSynthesisVoice 0x600002990200]
 
 Language:hr-HR, Name: Lana, Quality: Default [com.apple.voice.compact.hr-HR.Lana], [AVSpeechSynthesisVoice 0x6000029903c0]
 
 Language: hu-HU, Name: Tünde, Quality: Default [com.apple.voice.compact.hu-HU.Mariska], [AVSpeechSynthesisVoice 0x6000029b1470]
 
 Language:id-ID, Name: Damayanti, Quality: Default [com.apple.voice.compact.id-ID.Damayanti], [AVSpeechSynthesisVoice 0x600002990090]
 
 Language: it-IT, Name: Alice, Quality: Default [com.apple.voice.compact.it-IT.Alice], [AVSpeechSynthesisVoice 0x600002990310]
 
 Language:ja-JP, Name: Kyoko, Quality: Default [com.apple.voice.compact.ja-JP.Kyoko], [AVSpeechSynthesisVoice 0x600002990050]
 
 Language: ko-KR, Name: Yuna, Quality: Default [com.apple.voice.compact.ko-KR.Yuna], [AVSpeechSynthesisVoice 0x6000029900e0]
 
 Language:ms-MY, Name: Amira, Quality: Default [com.apple.voice.compact.ms-MY.Amira], [AVSpeechSynthesisVoice 0x6000029b1450]
 
 Language: nb-NO, Name: Nora, Quality: Default [com.apple.voice.compact.nb-NO.Nora], [AVSpeechSynthesisVoice 0x6000029901d0]
 
 Language:nl-BE, Name: Ellen, Quality: Default [com.apple.voice.compact.nl-BE.Ellen], [AVSpeechSynthesisVoice 0x600002990360]
 
 Language: nl-NL, Name: Xander, Quality: Default [com.apple.voice.compact.nl-NL.Xander], [AVSpeechSynthesisVoice 0x600002990390]
 
 Language:pl-PL, Name: ZOSIA, Quality: Default [com.apple.voice.compact.pl-PL.Zosia], [AVSpeechSynthesisVoice 0x6000029902f0]
 
 Language: pt-BR, Name: Luciana, Quality: Default [com.apple.voice.compact.pt-BR.Luciana], [AVSpeechSynthesisVoice 0x6000029903e0]

 Language:pt-PT, Name: Joana, Quality: Default [com.apple.voice.compact.pt-PT.Joana], [AVSpeechSynthesisVoice 0x600002990440]
 
 Language: ro-RO, Name: Ioana, Quality: Default [com.apple.voice.compact.ro-RO.Ioana], [AVSpeechSynthesisVoice 0x600002990350]

 Language:ru-RU, Name: Milena, Quality: Default [com.apple.voice.compact.ru-RU.Milena], [AVSpeechSynthesisVoice 0x6000029901c0]
 
 Language: sk-SK, Name: Laura, Quality: Default [com.apple.voice.compact.sk-SK.Laura], [AVSpeechSynthesisVoice 0x600002990230]
 
 Language:sv-SE, Name: Alva, Quality: Default [com.apple.voice.compact.sv-SE.Alva], [AVSpeechSynthesisVoice 0x600002990150]
 
 Language: th-TH, Name: Kanya, Quality: Default [com.apple.voice.compact.th-TH.Kanya], [AVSpeechSynthesisVoice 0x6000029902e0]

 Language:tr-TR, Name: Yelda, Quality: Default [com.apple.voice.compact.tr-TR.Yelda], [AVSpeechSynthesisVoice 0x600002990210]
 
 Language: uk-UA, Name: Lesya, Quality: Default [com.apple.voice.compact.uk-UA.Lesya], [AVSpeechSynthesisVoice 0x600002990250]

 Language:vi-VN, Name: Linh, Quality: Default [com.apple.voice.compact.vi-VN.Linh], [AVSpeechSynthesisVoice 0x6000029900b0]
 
 Language: zh-CN, Name: Tingting, Quality: Default [com.apple.voice.compact.zh-CN.Tingting], [AVSpeechSynthesisVoice 0x600002990330]

 Language:zh-HK, Name: Sinji, Quality: Default [com.apple.voice.compact.zh-HK.Sinji], [AVSpeechSynthesisVoice 0x6000029b1460]
 
 Language: zh-TW, Name: Meijia, Quality: Default [com.apple.voice.compact.zh-TW.Meijia]]
 2023-01-03 10:34:43.172739-0800 Sugah[63196:13074604] [strings] ERROR: Daria not found in table SpeechVoiceNames of bundle CFBundle 0x158d0d370


 </Applications/Xcode.app/Contents/Developer/Platforms/iPhoneOS.platform/Library/Developer/CoreSimulator/Profiles/Runtimes/iOS.simruntime/Contents/Resources/RuntimeRoot/System/Library/PrivateFrameworks/TextToSpeech.framework> (not loaded)
 
 
 
 */

