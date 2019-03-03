require 'mediawiki_api'
require 'HTTParty'
require 'timeout'
require_relative '../helper'
require 'uri'
require 'colorize'
require 'json'
require_relative 'japanese_episodes'

include Generic


# converting to use [[Template:Infobox broadcasting network]] per [[Wikipedia:Templates_for_discussion/Log/2018_November_16#Template:Infobox_ITV_franchisee]]
text = <<~TEXT
{{DISPLAYTITLE:List of ''Sgt. Frog'' episodes (season 1)}}
[[Image:Keroro cover 1.jpg|thumb|right|Cover of ''Keroro Gunsou''{{'}}s first DVD volume released.]]
The first season of the ''[[Sgt. Frog]]'' [[anime]] series is a compilation of the first fifty-one episodes from the series, which first aired in Japan from April 3, 2004 to March 26, 2005 on [[TV Tokyo]].

The season features one opening song and three different ending songs. {{nihongo|"Kero! to March"|ケロッ!とマーチ|Kero! tto Māchi|Ribbit March}} by [[Nobuaki Kakuda]] & Juri Ihata is used as the opening from episode 1 to 51. {{nihongo|"Afro Gunsō"|アフロ軍曹|Afuro Gunsō}} by [[Hideki Fujisawa|Dance Man]] is used as the ending from episode 1 to 18 and again from episode 27 to 39. {{nihongo|"Pekopon Shinryaku [[Ondo (music)|Ondo]]"|地球（ペコポン）侵略音頭||Pekopon Invasion Song}} by Ondo Girls meet [[Keroro Platoon]] is used as the ending from episode 19 to 26. {{nihongo|"Keroro-shōtai Kōnin! Netsuretsu Kangeiteki Ekaki Uta!!"|ケロロ小隊公認!熱烈歓迎的えかきうた!!||Keroro Platoon Authorized! Passionate Learn to Draw Song!!}} by Keroro Platoon is used as the ending from episode 40 to 51.

[[Funimation Entertainment]] licensed this season for distribution in 2008, and released it on DVD from 2009 to 2010 as two separate seasons. The first set, entitled "Season 1 Part 1", was released September 22, 2009, and contains episodes 1 through 13,<ref>{{cite web|url=https://www.amazon.com/dp/B002FOQXVO/ |title=Sgt. Frog: Season 1, Part 1|publisher=Amazon|accessdate=7 March 2010}}</ref> The second set, "Season 1 Part 2", was released on November 24, 2009, and contains episodes 14 through 26.<ref>{{cite web|url=https://www.amazon.com/dp/B002MXZYGI/ |title=Sgt. Frog: Season One, Part 2|publisher=Amazon|accessdate=7 March 2010}}</ref> A third set, "Season 2 Part 1", was released on January 26, 2010, containing episodes 27 through 39.<ref>{{cite web|url=https://www.amazon.com/dp/B002UOMGYC/ |title=Sgt. Frog: Season 2, Part 1|publisher=Amazon|accessdate=5 March 2010}}</ref> "Season 2 Part 2" was released on March 30, 2010 containing episodes 40 through 51.<ref>{{cite web|url=https://www.amazon.com/dp/B0030ZOYVI/ |title=Sgt. Frog: Season 2, Part 2 (2010)|publisher=Amazon|accessdate=5 March 2010}}</ref> The first two boxsets were re-released into one set on March 29, 2011,<ref>https://www.amazon.com/dp/B0049TC8DA</ref> with the complete second season set following up on April 26, 2011.<ref>https://www.amazon.com/dp/B004GZZH9O</ref>

This is currently the only season of Sgt. Frog in which all the episodes have a received an [[Dubbing (filmmaking)|English dub]].

==Episode list==
<onlyinclude>
{| class="wikitable" style="width: 99%;"
|- style="border-bottom:3px solid #00FF00;"
! style="width: 3%;" | No.
! Translated title / Funimation Entertainment title
! style="width: 15%;" | Original airdate
|-
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 01
 |EnglishTitleA = I Am Sergeant Keroro! / [[Meet the Press|Meet the Sergeant]]!
 |RomajiTitleA = Wagahai ga Keroro Gunsō de Arimasu
 |KanjiTitleA = 我が輩がケロロ軍曹 であります
 |EnglishTitleB = Sergeant Keroro Rising / Sgt. Frog Presents: The Episode That Should've Come First!
 |RomajiTitleB = Keroro Daichi ni Tatsu de Arimasu
 |KanjiTitleB = ケロロ 大地に立つ であります
 |OriginalAirDate = {{Start date|2004|4|3}}
 |ShortSummary= Sergeant Keroro is a frog-like alien from the planet Keron sent to invade planet Earth (or Pekopon, as his race calls it). He is instead kept as a pet and forced to do chores for the Hinata family, which consists of paranormal maniac Fuyuki, his ill-tempered older sister Natsumi, and their manga-editing mother Aki. Keroro is given his own room in the basement of the Hinata family house, which he refurnishes and uses as a base, not realizing that the room is haunted by a ghost.
<br>
In a prequel to the first segment, the Hinata family first discovers and captures Sgt. Keroro while he is scouting inside their house. Fuyuki takes the Keroball (Keroro's weapon) and fiddles around with it, accidentally sending a signal to the Keronian invasion fleet alerting them of Keroro's capture. The fleet abandons Keroro instead of rescuing him, leaving him to perform chores around the Hinata family household.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 02
 |EnglishTitleA = Momoka & Tamama, Battle Begins! / Momoka & Tamama Present: Bag of Secrets!
 |RomajiTitleA = Momoka ando Tamama Shutsugeki! de Arimasu
 |KanjiTitleA = 桃華&タママ 出撃! であります
 |EnglishTitleB = Momoka & Tamama, Operation Overload the Hinatas / Momoka & Tamama Present: Cow Flesh of Love!
 |RomajiTitleB = Momoka ando Tamama Hinatake Jōriku de Arimasu
 |KanjiTitleB = 桃華&タママ 日向家上陸 であります
 |OriginalAirDate = {{Start date|2004|4|10}}
 |ShortSummary= Keroro goes to Fuyuki's school in search of the other members of his platoon. Meanwhile, Fuyuki is stalked by Momoka, a girl who had come across Private Tamama, one of Keroro's platoon members. Momoka tries to confess her feelings for Fuyuki, but is interrupted when Tamama farts while hidden inside her schoolbag. Momoka angrily attacks Tamama, but Keroro arrives and saves her before the seemingly helpless Tamama snaps and counterattacks with his laser breath.
<br>
Momoka attends a meeting for Fuyuki's paranormal club at his house in an attempt to become closer to him, but is frequently interrupted by Keroro and Tamama's antics. Meanwhile, Keroro becomes jealous of Tamama when he discovers that his subordinate has been living a very pampered life at Momoka's mansion.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 03
 |EnglishTitleA = Keroro, Lethal Nervous Breakdown / Amphibian on the Verge of a Nervous Breakdown!
 |RomajiTitleA = Keroro Kiken Rinkaiten Toppa de Arimasu
 |KanjiTitleA = ケロロ 危険臨界点突破 であります
 |EnglishTitleB = Keroro, The Secret Mission Begins / [[Watchmen|Who Watches the Watch-Pekoponians]]?
 |RomajiTitleB = Keroro Gokuhi Ninmu Kaishi de Arimasu
 |KanjiTitleB = ケロロ 極秘任務開始 であります
 |OriginalAirDate = {{Start date|2004|4|17}}
 |ShortSummary= Keroro feels trapped inside the Hinatas' house and misses being outdoors. Tamama and Fuyuki help him think of ways he can leave the house without drawing too much attention, given that he is an alien. Keroro eventually discovers that the badge on his helmet allows him to temporarily turn invisible.
<br>
Natsumi suspects that Keroro will use his invisibility device to go out and cause trouble, so she convinces her family to install hidden cameras throughout the house to spy on him. Later, Natsumi accuses Keroro of spying on the family when she discovers a pair of binoculars outside, but the Hinatas survey the security footage to find that Keroro has done nothing out of the ordinary. The true culprit is later revealed to be Giroro, another member of Keroro's platoon.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 04
 |EnglishTitleA = Giroro, The Most Dangerous Man in the Universe / Giroro Presents: Blood Violence Death Kill!
 |RomajiTitleA = Giroro Uchū de Mottomo Kiken na Otoko de Arimasu
 |KanjiTitleA = ギロロ 宇宙でもっとも危険な男 であります
 |EnglishTitleB = Keroro, An Occasionally Dangerous Man / Oh, the Humidity!
 |RomajiTitleB = Keroro Ame Tokidoki Kiken na Otoko de Arimasu
 |KanjiTitleB = ケロロ 雨時々危険な男 であります
 |OriginalAirDate = {{Start date|2004|4|24}}
 |ShortSummary= Giroro is disgusted by Keroro and Tamama's lack of progress in the invasion, and decides to set traps for the Hinatas using all the information he had gathered on them. He immobilizes both Keroro and Fuyuki, but Natsumi easily overcomes the traps with her brute strength and knocks out Giroro.
<br>
Giroro suspects that the reason behind Keroro's lost interest in the Pekoponian invasion comes from a difference in humidity between Earth and Keron. He and Tamama install humidifiers in Keroro's room, which drastically increases his intelligence and strength, but the room becomes overly humid when it begins to rain, causing Keroro to go berserk. The humidity attracts a Nyororo, a natural enemy of the Keronians, which feeds on all the moisture Keroro had absorbed and returns him to normal.
| LineColor =00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 05
| Title           = The Song of a Man Obsessed with Toys / [[The Day the Clown Cried|The Day the Gundam Cried]]
| TranslitTitle   = Omocha o Aisuru Otokotachi no Uta de Arimasu
| NativeTitle     = おもちゃを愛する男達の歌 であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2004|5|1}}
| ShortSummary    = Keroro works hard doing chores so he can earn money to buy [[Gundam]] models at the local toy store, which is run by an old man. He goes to the toy store, only to realize that he can't buy anything while invisible. His invisibility wears off, and he is mistaken by the store owner for a toy and shut inside the store overnight. After escaping, he learns from Fuyuki that the shop is running out of business and will be closed for good. Keroro buys another model in an attempt to save the store, which ultimately fails.
| LineColor       = 00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 06
 |EnglishTitleA = Momoka, Romantic Plan on the South Seas / Operation: Free My Beached Love... With a Kiss!
 |RomajiTitleA = Momoka Raburabu Nankai Daisakusen de Arimasu
 |KanjiTitleA = 桃華 ラブラブ南海大作戦 であります
 |EnglishTitleB = Momoka, Spooky Plan on the South Seas / Operation: Ghost Kiss-perer!
 |RomajiTitleB = Momoka Hyūdoro Nankai Daisakusen de Arimasu
 |KanjiTitleB = 桃華 ひゅ～どろ南海大作戦 であります
 |OriginalAirDate = {{Start date|2004|5|8}}
 |ShortSummary= Momoka invites Fuyuki to her private island resort for spring break so she can steal her first kiss from Fuyuki. However, Natsumi, Aki, and the Keronians come along and thwart her plans. She ultimately tries to pretend that she is drowning so that Fuyuki can save her and give her [[Cardiopulmonary resuscitation|CPR]], but Fuyuki reveals that he doesn't know how to swim. Momoka nearly drowns for real and is unknowingly resuscitated by an octopus-like creature brought by Keroro instead.
<br>
Hoping to be alone with Fuyuki, Momoka plans an island ghost hunt after everyone's dessert mysteriously disappears, not realizing that it had been eaten by the ghost that haunts Keroro's room.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 07
 |EnglishTitleA = Mois, First Attempt to Destroy Earth / Angol Mois Presents: [[Apocalypse Now|Apocalypse Later]]!
 |RomajiTitleA = Moa Hajimete no Chikyū Hakai de Arimasu
 |KanjiTitleA = モア はじめての地球破壊 であります
 |EnglishTitleB = Tamama vs. Mois: Tamama's Defeat / Angol Mois & Tamama Present: [[Dr. Strangelove|Sergeant Strangelove: or How I learned to stop worrying and love the frog]].
 |RomajiTitleB = Tamama tai Moa Kekka wa Tamama no Make de Arimasu
 |KanjiTitleB = タママ VS モア 結果はタママの負け であります
 |OriginalAirDate = {{Start date|2004|5|15}}
 |ShortSummary= Angol Mois falls over the Hinata's house and reveals that she not only knows Keroro but she's here to fulfill the prophecy of the Earth's destruction. She's already years late however. A battle between Keronians, humans and Mois starts for the control of the Lucifer Spear that would grant the destruction, conquer or safety of the planet.
<br>
Tamama jealous of the attention that Keroro gives to Mois puts her through an intensive training to scare her from ever wanting to be her partner. Tamama fails after seeing Mois's determination.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 08
 |EnglishTitleA = Keroro, Invasion Status is Never Better / Handsome Keroro Presents: Invasion Status Is Never Better. Or Building a Base for Dummies.
 |RomajiTitleA = Keroro Shinryaku Sakusen Zekkōchō! de Arimasu
 |KanjiTitleA = ケロロ　侵略作戦絶好調!　であります
 |EnglishTitleB = Keroro, Building a Base for Dummies / Handsome Keroro Presents: [[Star Trek|Base: The Final Frontier]]
 |RomajiTitleB = Keroro Machigai Darake no Kichi Tsukuri de Arimasu
 |KanjiTitleB = ケロロ　間違いだらけの基地作り　であります
 |OriginalAirDate = {{Start date|2004|5|22}}
 |ShortSummary= Keroro remembers yet again that he should be invading Pekopon so he convinces the Hinatas to do something outdoors while he and his platoon work in constructing a secret base.
<br>
Fuyuki and Momoka investigate the new secret base while the platoon thinks they are intruders.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 09
 |EnglishTitleA = Natsumi, Where Love Blooms, Kululu Looms / [[Desperately Seeking Susan|Desperately Seeking Brains]]
 |RomajiTitleA = Natsumi Koi no Yukute ni Kuru Kururu de Arimasu
 |KanjiTitleA = 夏美 恋の行く手に来るクルル であります
 |EnglishTitleB = Aki Hinata, A Dynamite Woman / [[The Curious Case of Benjamin Button (film)|The Curious Case of Aki Hinata]]
 |RomajiTitleB = Hinata Aki Dainamaito na Onna de Arimasu
 |KanjiTitleB = 日向 秋 ダイナマイトな女 であります
 |OriginalAirDate = {{Start date|2004|5|29}}
 |ShortSummary= Things are getting difficult for Keroro who realizes that the invasion needs someone intelligent so he orders to find the fourth frog Kululu. Meanwhile, Natsumi is approached by the popular Saburo who would like to hang out in her house for some reason. Fuyuki thinks it’s because Saburo is an agent hunting aliens, but in fact it’s because he found Kululu and it was time to reunite him with the Platoon.
<br>
Kululu's first invention in Pekopon is a ray that modifies the target's age and Aki is the first to try it. However, there is a time limit to change her back or she'll remain young again and Aki escaped to Fuyuki's school to pass the day.
| LineColor =00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 10
| Title           = Face-off! Decisive Battle over Molar-3 / Sgt. Frog vs. The Cavitians Of Cavity 9!
| TranslitTitle   = Kessen! Daisan Daikyūshi de Arimasu
| NativeTitle     = 決戦! 第三大臼歯 であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2004|6|5}}
| ShortSummary    = Keroro gets a cavity for eating too many sweets and not brushing enough. However, Keronian cavities are caused by a microscopic alien race and must be exterminated from the inside. Kururu uses an invention to shrink Giroro and Tamama, and they go inside Keroro's mouth to beat the cavitians. Giroro and Tamama try but there are too many enemies for the two of them.
<br>
Another attack to the cavitians is organized, this time with Fuyuki, Natsumi and a robot with Keroro's conscience in it. They advance into the enemy base only to find the leader of the cavitians waiting for them. Keroro orders a retreat but he stays thinking he has a weapon that could end the battle but in fact the whole robot is a bomb that Kululu detonates.
| LineColor       = 00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 11
| Title           = Keroro Platoon Must Appear on TV! / Fantasti-cool Keroro Presents: Fake It Til You Make It!
| TranslitTitle   = Keroro Shōtai Terebi ni Shutsuen seyo! de Arimasu
| NativeTitle     = ケロロ小隊 テレビに出演せよ! であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2004|6|12}}
| ShortSummary    = The Platoon gets notice that an alien crew of a reality TV show will arrive in Earth and they are ordered to help them with the show in whatever they need even if that includes getting really weird shots for them.
<br>
The visitors demand food and a bath scene with all the girls. Aki and the girls play along until the aliens ask them to take off their towels and win a beating from Aki. Turns out that the aliens were a fraud and the real ones were attacked by Giroro.
| LineColor       = 00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 12
 |EnglishTitleA = Sumomo, A Pop Star Travels Across Space / Sumomo Presents: Pop Startled!
 |RomajiTitleA = Sumomo Aidoru wa Uchū o Koete
 |KanjiTitleA = すもも アイドルは宇宙をこえて であります
 |EnglishTitleB = Giroro, A Small Angel on the Battlefield / It's the Belt, Stupid!
 |RomajiTitleB = Giroro Senjō no Chiisana Tenshi de Arimasu
 |KanjiTitleB = ギロロ 戦場のちいさな天使 であります
 |OriginalAirDate = {{Start date|2004|6|19}}
 |ShortSummary= Space idol Sumomo arrives at the Hinata's house to offer a private concert for the troops in Pekopon. This is actually a lie. In fact, she just wanted to rest from all the attention she gets. In the end, after passing an afternoon as an unknown human, she realizes that she misses that attention and abandons Keroro leaving him with a huge debt from the concert planning.
<br>
Giroro finds a cat getting wet in the rain and decides to keep it. The next day he lost his belt and feels useless and clumsy. He even tries other things to replace his belt but nothing works. Turns out Kululu took it to show him that he indeed needed something to rely on and the cat found it for him.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 13
 |EnglishTitleA = Dororo, The Forgotten Soldier / Dororo Presents: [[The Boy That Time Forgot|The Frog That Friends Forgot]]
 |RomajiTitleA = Dororo Wasurerareta Senshi de Arimasu
 |KanjiTitleA = ドロロ 忘れられた戦士 でります
 |EnglishTitleB = Dororo and Koyuki, A Beautiful Friendship / Dororo & Koyuki Present: Viper? I Hardly Even Knew Her!
 |RomajiTitleB = Dororo ando Koyuki Yūjō wa Utsukushiki de Arimasu
 |KanjiTitleB = ドロロ&小雪 友情は美しき哉 であります
 |OriginalAirDate = {{Start date|2004|6|26}}
 |ShortSummary= Aliens all over Pekopon are being abducted and a new girl is transferred to Natsumi's group. Both things are related as the new girl Koyuki is a ninja protecting Earth who also found the last frog, Zeroro. Koyuki informs him and tries to reunite them but Zeroro refuses, revealing to his old friends that he changed his name to Dororo and will now protect Pekopon rather than invade it.
<br>
Dororo and Koyuki are taken prisoner by a member of the Vipers, natural enemies of the Keronians. The platoon goes to the rescue only to fail miserably for the lack of a fifth member. Keroro comes clean about breaking Dororo's music box a long time ago prompting Dororo to forgive him and help the platoon defeat Viper. At the end, Dororo realizes how painful was to remember his box and refuses to join them again.
| LineColor =00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 14
| Title           = Five People Gathering! Probably the Greatest Plan in History / ARMPIT Platoon Present: [[The Silence of the Lambs (film)|The Silence of the Plans]]!
| TranslitTitle   = Gonin Shūketsu! Tabun Shijō Saidai no Sakusen de Arimasu
| NativeTitle     = 五人集結! たぶん史上最大の作戦 であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2004|7|3}}
| ShortSummary    = Keroro works hard to come up with a plan to invade Pekopon but Dororo keeps refusing all of them for not being ecologically friendly. He wants to plant flowers to help peace flourish and an idea comes to Keroro that would satisfy everyone in the platoon.
<br>
The plan starts and everyone is called to plant seeds all night. The next day the flowers bloom for everyone to see but they are removed by cleaning personnel. Turns out the flowers were in fact monsters and the plan to make Dororo part of the group again fails.
| LineColor       = 00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 15
 |EnglishTitleA = Momoka, Dark Momoka Arises / [[The Dark Phoenix Saga|The Dark Momoka Saga]], Part 1 Plus Pool Training!
 |RomajiTitleA = Momoka Ura Momoka Kōrin de Arimasu
 |KanjiTitleA = 桃華 裏桃華 降臨　であります
 |EnglishTitleB = Dark Momoka, The Story Behind Her Betrayal / The Dark Momoka Saga, Part 2 And More Pool Fun!
 |RomajiTitleB = Ura Momoka Uragiri no Uragawa de Arimasu
 |KanjiTitleB = 裏桃華 裏切りの裏側　であります
 |OriginalAirDate = {{Start date|2004|7|10}}
 |ShortSummary= After a freak accident involving Tamama's training machine, Momoka's two different personalities split up. The bad Momoka escapes the mansion looking for Fuyuki.
<br>
Bad Momoka ends up taking over the leadership of Keroro's platoon and Kululu shows her a destructive missile but stops at the last second. Good Momoka realizes that she needs her bad side back and only synchronized swimming will combine them back.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 16
 |EnglishTitleA = Mois, Dark Mois Arises!? / Angol Mois Presents: [[Girls Gone Wild (franchise)|Girl Gone Wild]]!
 |RomajiTitleA = Moa Ura Moa Kōrin!? de Arimasu
 |KanjiTitleA = モア 裏モア 降臨!? であります
 |EnglishTitleB = Mois, Mois Mois' Big Panic  Twin At All Costs! / Angol Mois Presents: Twin at All Costs!
 |RomajiTitleB = Moa Moamoa Daipanikku de Arimasu
 |KanjiTitleB = モア モアモア大パニック であります
 |OriginalAirDate = {{Start date|2004|7|17}}
 |ShortSummary= Dororo, Saburo and Tamama find Mois beating up people and head to the Hinata's house to investigate. Kululu shows all of them a video of Mois' activities which was supposed to be secret and a gift to her father. Mois walks on them and runs out of the house. The group runs after her to catch them attacking Natsumi's friends. Natsumi tries to stop her but Mois fights back. Then another Mois walks into the scene.
<br>
Mois explains that she took the appearance of that girl when she first landed in Earth. The Platoon decides to help the girl and discovers the reason behind her violence. Mois is moved and decides to destroy the Earth so she won't suffer anymore but stops at her request.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 17
 |EnglishTitleA = Keroro vs Natsumi, Battle in the Waters! / Keroro vs. Natsumi Present: [[Doggy Paddle|Froggy Paddle]]
 |RomajiTitleA = Keroro tai Natsumi Suichū Daikessen! de Arimasu
 |KanjiTitleA = ケロロ VS 夏美 水中大決戦! であります
 |EnglishTitleB = Fuyuki, Welcome to Horror World / Fuyuki Presents: [[Night of the Living Dead|Night of the Living Room]]!
 |RomajiTitleB = Fuyuki Yōkoso Horā Wārudo e de Arimasu
 |KanjiTitleB = 冬樹 ようこそホラーワールドへ であります
 |OriginalAirDate = {{Start date|2004|7|24}}
 |ShortSummary= Keroro plans a trip to the school pool to test how good swimsuits actually stand against a Keronians. Once there Keroro challenges Natsumi to a swimming race which she losses.
<br>
Keroro and Tamama laugh at what Pekoponians think is scary so Natsumi challenge them back to a scary story telling competition of Humans against Keronians, with Giroro as the forced referee.
| LineColor =00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 18
| Title           = Natsumi Is Hilarious! Coast Story of an Adult / Today's Adventure: Wet, Hot, Beaches!
| TranslitTitle   = Natsumi Bakushō! Otona no Kaigan Monogatari de Arimasu
| NativeTitle     = 夏美 爆笑! 大人の海岸物語 であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2004|7|31}}
| ShortSummary    = Keroro and Natsumi want to go to the beach but Aki can't go, so the only way Kululu thinks of is to zap Natsumi with the age modifying ray. Keroro then reveals that the reason why they had to go there is a comedy stand contest which prize is a mountain of fake but very rare Gundam knock off models and he wants Mois and Natsumi to win them. Natsumi refuses but Saburo appears and talks that he would like the models too.
<br>
Natsumi enters the contest but needs a partner so Koyuki appears to help. Keroro and Mois enter too and it doesn’t take long before Keroro starts cheating. He sabotages Natsumi act and makes a perfect act only to realize that the prize he wanted was for the runner-up. Natsumi wins the Gundam and gives one to Saburo in the moment the ageing ray reverts.
| LineColor       = 00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 19
 |EnglishTitleA = Keroro vs. Natsumi Festival Showdown! / Keroro and Natsumi Present: The Ultimate Festival Challenge!
 |RomajiTitleA = Keroro tai Natsumi Omatsuri Chōjō Kessen! de Arimasu
 |KanjiTitleA = ケロロ VS 夏美 おまつり頂上決戦! であります
 |EnglishTitleB = Keroro, Your Ears have been Invaded by the Radio / Handsome Keroro Presents: [[Video Killed the Radio Star|Keroro Killed The Radio Star]]!
 |RomajiTitleB = Keroro Anata no Omimi ni Shinryaku Rajio de Arimasu
 |KanjiTitleB = ケロロ あなたのお耳に侵略ラジオ であります
 |OriginalAirDate = {{Start date|2004|8|7}}
 |ShortSummary= Natsumi, Fuyuki, Koyuki and Mois go to a festival in which they find the Platoon scamming people. Keroro challenges Natsumi to a turtle fishing challenge to either leave the festival or keep her prisoner. Natsumi wins but Keroro has a plan B that involves the festival's fireworks.
<br>
Keroro discovers the persuasive powers of the radio and decides to host a show that would brainwash humans to hand over the planet. All goes well until they lie about having the space idol Sumomo and Giroro was not able to recreate her voice.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 20
 |EnglishTitleA = Fuyuki Meets A Girl / [[Make love not war|Make Subs, Not War! Then Make War]]!
 |RomajiTitleA = Fuyuki Mītsu A Gāru de Arimasu
 |KanjiTitleA = 冬樹 ミーツ・ア・ガァ～ル であります
 |EnglishTitleB = Fuyuki, Messenger of Nontolma / [[20,000 Leagues Under the Sea|20,000 Leaps Under The Sea]]!
 |RomajiTitleB = Fuyuki Nontoruma no Shisha de Arimasu
 |KanjiTitleB = 冬樹 ノントルマの使者 であります
 |OriginalAirDate = {{Start date|2004|8|14}}
 |ShortSummary= Keroro decides to start the Peokoponian invasion by conquering the sea and the Hinatas tag along. Fuyuki meets a girl and both clean the beach until Keroro calls him to dive to the deeps of the sea to help him with a school research.
<br>
Keroro and the Platoon continue to conquer the sea. They go to the deepest part where Fuyuki offers to go himself. The submarine is attacked by the Nantoma, a race that inhabits the bottom of the sea. The Platoon flees but Fuyuki is abandoned and they can't go back for him. Luckily he's saved by the girl he met.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 21
 |EnglishTitleA = Keroro's Invasion can Conserve Energy / Handsome Keroro Presents: [[Some Like It Hot|Some Like It Scorching and Miserable]]!
 |RomajiTitleA = Keroro Shinryaku mo Shōene de ne de Arimasu
 |KanjiTitleA = ケロロ 侵略も省エネでね であります
 |EnglishTitleB = Keroro Charges To The Countryside / Handsome Keroro Presents: Mother's Superior!
 |RomajiTitleB = Keroro Inaka ni Mukete Totsugeki seyo! de Arimasu
 |KanjiTitleB = ケロロ 田舎にむけて突撃せよ! であります
 |OriginalAirDate = {{Start date|2004|8|21}}
 |ShortSummary= A power failure in the middle of the summer leaves everyone heat stroked. Koyuki teaches Natsumi ways in which she can stay fresh without electricity.
<br>
The Hinatas visit Grandma in her house at the mountain and the Platoon tag along. Giroro feels the call of nature but falls off a cliff, Tamama finds someone with who to train and ends up injured and Keroro ends lost in the woods with a dog. The three of them are saved by a strange woman that rings a bell.
| LineColor =00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 22
| Title           = Tamama, From now on I'm the Leader / Today's Adventure: [[Who's the Boss?|Lose the Boss]]!
| TranslitTitle   = Tamama Kyō kara Boku ga Taichō desū de Arimasu
| NativeTitle     = タママ 今日からボクが隊長ですぅ であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2004|8|28}}
| ShortSummary    = Tamama is appointed as the new leader of the platoon by headquarters. Quickly enough the power goes to his head, destroys all of Keroro's Gundam models and throws him into a pit.
<br>
Tamama designs a plan to fatten all Pekoponians by changing all water to soda and food to desserts. One by one he decides that nobody is good enough for his leadership and throws them to the dungeon. Tamama feels alone and quits as leader.
| LineColor       = 00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 23
| Title           = Panic! The Noisiest Day of the Hinata Family / Handsome Keroro Presents: The [[Clone Wars (Star Wars)|Clone Wars]] (The Unsucky Version)
| TranslitTitle   = Panikku! Hinataka no Mottomo Sawagashii Ichinichi de Arimasu
| NativeTitle     = パニック! 日向家の最も騒がしい一日 であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2004|9|4}}
| ShortSummary    = Keroro sneaks into Fuyuki's room to take the Keroball and clones himself by accident. The number of Keroros keeps growing until the house is full of clones all of them as useless as the original.
<br>
Kululu explains that the Keroball is broken and that unless it's fixed the clone process would continue until Keroro disappears. No one knows what to do until Saburo appears and is asked to draw another Keroball.
| LineColor       = 00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 24
 |EnglishTitleA = Keroro, The [[Space Sheriff Gavan|Space Detective]] of Righteousness and Poverty / Handsome Keroro Presents: [[The Man in the Iron Mask (1998 film)|The Man In The Ironic Mask]]!
 |RomajiTitleA = Keroro Seigi to binbō no Uchū Tantei de Arimasu
 |KanjiTitleA = ケロロ 正義と貧乏の宇宙探偵 であります
 |EnglishTitleB = Kogoro, [[Tokusatsu]] Employment On The Frontline / Space Deputy Kogoro Presents: [[Last Action Hero|Lost Action Hero]]!
 |RomajiTitleB = Kogorō Tokusatsu Shūshoku Saizensen! de Arimasu
 |KanjiTitleB = 556 特撮就職最前線! であります
 |OriginalAirDate = {{Start date|2004|9|11}}
 |ShortSummary= Space Detective Kogoro and his sister Lavie land in Pekopon and confuse Natsumi with random comments. They follow Natsumi to the Hinata's house looking for aliens that threaten the peace of Pekopon. The Platoon and the detective fight but only Keroro wants to fight. At the end the fight was staged because Keroro and Kogoro were friends since childhood.
<br>
Kogoro decides to stay in Earth but it's hard for him to find a job because of his weird actions and speeches. Kululu finds him an audition in a children's program and is actually doing good until Keroro and Tamama feel jealous and jump into the show too.
| LineColor =00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 25
| Title           = Momoka, Escapee of Love, Youth, and Troubles / Momoka Presents: A Justified War!
| TranslitTitle   = Momoka Ai to Seishun to Haran no Tōbō de Arimasu
| NativeTitle     = 桃華 愛と青春と波乱の逃亡 であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2004|9|18}}
| ShortSummary    = Momoka refuses to visit her father Baio Nishizawa in Scotland so he decides he'll bring her by force with his army, the best army on Earth. Keroro wants to film the platoon taking down the Nishizawa's army so headquarters would think he is competent.
<br>
The war starts and the Platoon isn’t able to stand against the army. Keroro snaps when the army destroys one of his Gundams and threatens to destroy the Earth for revenge. Fuyuki saves everyone once again but still Momoka goes to Scotland.
| LineColor       = 00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 26
| Title           = Keroro Unite Together! Let's Invade the Sports Meet / Let the Games Impend!
| TranslitTitle   = Keroro Itchi danketsu! Undōkai o Shinryaku seyo de Arimasu
| NativeTitle     = ケロロ 一致団結! 運動会を侵略せよ であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2004|9|25}}
| ShortSummary    = It's sport week and as always Fuyuki is not very optimistic of it. Natsumi plans to run the three leg race with Aki if she came make it in time to participate. Keroro decides to do whatever it takes to help Natsumi so she will own him a favor by sabotageing the events before the race.
<br>
Meanwhile, Tamama and Dororo try helping Aki finish faster. Keroro continues with the sabotage plan to no avail at the end. The only way for Natsumi to participate was accepting the help of Giroro.
| LineColor       = 00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 27
 |EnglishTitleA = Keroro Father Is Going! Father Is Coming! / Handsome Keroro Presents: Keroro's Daddy Issue!
 |RomajiTitleA = Keroro Chichi Kitaru Chichi Kaeru de Arimasu
 |KanjiTitleA = ケロロ 父キタル父カエル であります
 |EnglishTitleB = Keroro Hot Spring, Go! Go! Go! / Amazing Keroro Presents: [[Should I Stay or Should I Go|Should I Spa or Should I Go Now?]]
 |RomajiTitleB = Keroro Onsen GO! GO! GO! de Arimasu
 |KanjiTitleB = ケロロ 温泉GO! GO! GO!　であります
 |OriginalAirDate = {{Start date|2004|10|2}}
 |ShortSummary= Keroro gets a message from his father, telling him he is going to visit. To get the place prepared, he turns all of his friends into slaves.
<br>
The platoon creates a plan to make their own hot spring by drilling to find water. However, they get disastrous results.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 28
 |EnglishTitleA = Keroro Snowball Fight Survival / Handsome Keroro Presents: [[Das Boot|Das Snow Boot]]!
 |RomajiTitleA = Keroro Yukigassen Sabaibaru de Arimasu
 |KanjiTitleA = ケロロ 雪合戦サバイバル であります
 |EnglishTitleB = Kululu Ku of Kukuku / Kululu Presents: Ku Ku Kachoo Mr. Narrator
 |RomajiTitleB = Kururu [[Ge Ge Ge no Kitaro|Kukkukku no Ku]] de Arimasu
 |KanjiTitleB = クルル クックックのクッ であります
 |OriginalAirDate = {{Start date|2004|10|9}}
 |ShortSummary= Keroro and his friends have a regular snowball fight, but soon go to extreme mesures.
<br>
Kululu is tired of being the most unpopular character in the show, so he decides to play some nasty tricks.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 29
 |EnglishTitleA = Natsumi and Koyuki, Youth Written On Stage / Natsumi Hinata in: Actor Schmactor
 |RomajiTitleA = Natsumi ando Koyuki Butai ni Kakeru Seishun de Arimasu
 |KanjiTitleA = 夏美&小雪　舞台にかける青春　であります
 |EnglishTitleB = Keroro Scoop NG! / Handsome Keroro Presents: [[Close Encounters of the Third Kind|Close Encounters of the Frog Kind]]
 |RomajiTitleB = Keroro Sukūpu wa NG! de Arimasu
 |KanjiTitleB = ケロロ スクープはNG! であります
 |OriginalAirDate = {{Start date|2004|10|16}}
 |ShortSummary= Because of her popularity, Natsumi is forced to do a horror version of [[Peter Pan]] with Koyuki. After training with Keroro and a few other aliens, Natsumi is ready to take on the part of Wendy. Seeing Saburo in the audience, she gets too lovesick and makes a fool out of herself. It's up to Keroro to save the show!
<br>
A news group catches Keroro in person and want to put him in their next article. However, Keroro has other plans for the group.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 30
 |EnglishTitleA = Tamama, Youth From Keron Planet / [[It Came from Outer Space|Twit Came from Outer Space]]
 |RomajiTitleA = Tamama Keronsei kara Kita Shōnen
 |KanjiTitleA = タママ ケロン星から来た少年 であります
 |EnglishTitleB = Momoka's Aim For A Nice Body / [[Extreme Makeover]]: Momoka Edition
 |RomajiTitleB = Momoka Mezase Naisu Badi de Arimasu
 |KanjiTitleB = 桃華 めざせナイスバディ であります
 |OriginalAirDate = {{Start date|2004|10|23}}
 |ShortSummary= Private Taruru lands on Pekopon, and thinks Tamama is the sarge, due to some lies on Twitter. He makes hurtful jokes at all of Tamama's friends, and they all soon get revenge.
<br>
Momoka gets a complete makeover to make Fuyuki like her more. But it doesn't exactly work as planned.
| LineColor =00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 31
| Title           = Keroro Wanting to Go Back Home, But Can't / Handsome Keroro Presents: [[Lost in Translation (film)|Lost In Transportation]]
| TranslitTitle   = Keroro Kaeritai Kaerenai...de Arimasu
| NativeTitle     = ケロロ 帰りたい 帰れない… であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2004|10|30}}
| ShortSummary    = Keroro rides his new space bike everywhere until it runs out of fuel, and he gets lost in a forest.
<br>
Natsumi eventually finds him and reunites him with everybody. However, his bike is ruined.
| LineColor       = 00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 32
 |EnglishTitleA = Keroro Animal Platoon Assemble / Animal Army Attack!
 |RomajiTitleA = Keroro Dōbutsutaiin Daishūgō de Arimasu
 |KanjiTitleA = ケロロ 動物隊員大集合 であります
 |EnglishTitleB = Giroro, Kitty Wants To Say / Giroro Presents: Kitty Conundrum!
 |RomajiTitleB = Giroro Neko wa Iitai de Arimasu
 |KanjiTitleB = ギロロ ネコは言いたい であります
 |OriginalAirDate = {{Start date|2004|11|6}}
 |ShortSummary= Keroro decides to attempt to grow his army by turning animals into soldiers to join the platoon. Things do not go as planned, as usual.
<br>
The cat outside gets a hold of the gun that turns animals into humans in oder to say something. (Gun previously mentioned in the last episode)
| LineColor =00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 33
| Title           = Keroro Platoon Invades Pekopon In the Anime / Handsome Keroro Presents: The Episode We Wanted to Call [[Tiny Toons]] or [[Animaniacs]], But Those Were Already Taken
| TranslitTitle   = Keroro Shōtai Anime de Pekopon Shinryaku de Arimasu
| NativeTitle     = ケロロ小隊 アニメでペコポン侵略 であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2004|11|13}}
| ShortSummary    = Keroro plans makes his own cartoon in order to gain extra money. Unfortunately, they have lots of trouble trying to pull it off. So Keroro and crew go to the place where their favorite cartoon is made in order to try to get those animators to make their show.
| LineColor       = 00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 34
 |EnglishTitleA = Momoka vs. Koyuki Hotspring Battle / Hot Spring Hilarity
 |RomajiTitleA = Momoka tai Koyuki Onsen Sōdatsu Batoru de Arimasu
 |KanjiTitleA = 桃華 VS 小雪 温泉争奪バトル であります
 |EnglishTitleB = Keroro And Fuyuki Go Together / [[Band on the Run|Frog on the Run]]!
 |RomajiTitleB = Keroro ando Fuyuki Mattari Iko de Arimasu
 |KanjiTitleB = ケロロ&冬樹 まったり行こっ であります
 |OriginalAirDate = {{Start date|2004|11|20}}
 |ShortSummary=Fuyuki wins 4 tickets to a spa (from a game rigged by Momoka, hoping he would take her). However, Koyuki is invited instead. Meanwhile Keroro is determined to solve a rubix cube given to him by Natsumi in order to go.
<br>Keroro accidentally breaks Natsumi's favorite coffee mug, so he runs away, but later meets Fuyuki, who is on his way to school for a big math test. Keroro and Fuyuki then walk across a lane, in which Fuyuki sees some familiar places he went to within that lane when he was little kid.
| LineColor =00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 35
| Title           = Top Secret! Natsumi's Birthday Strategy / [[The Day the Earth Stood Still|The Birthday the Earth Stood Still]]!
| TranslitTitle   = Gokuhi! Natsumi no Otanjōbi Daisakusen de Arimasu
| NativeTitle     = 極秘! 夏美のお誕生日大作戦 であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2004|11|27}}
| ShortSummary    = Keroro plans to have a huge surprise party for Natsumi's birthday, however problems arise as it is revealed that Natsumi doest want a childish birthday party.
| LineColor       = 00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 36
 |EnglishTitleA = Keroro Death Battle! Gunso vs. General Winter / A Frog In Winter
 |RomajiTitleA = keroro Shitō! Gunsō tai Fuyushōgun
 |KanjiTitleA = ケロロ　死闘! 軍曹 VS 冬将軍 であります
 |EnglishTitleB = Fuyuki That's How It Is, Miss Nishizawa / [[Escape to Witch Mountain|Escape to Which Mountain?]]
 |RomajiTitleB = Fuyuki Sō Nan desu yo Nishizawa-san de Arimasu
 |KanjiTitleB = 冬樹 そ～なんですよ西澤さん であります
 |OriginalAirDate = {{Start date|2004|12|4}}
 |ShortSummary=After Fuyuki refuses to take him to the toy store, Keroro decides to get his revenge by putting them into a simulator that produces ice cold temperatures. However his plan backfires when Fuyuki and Natsumi are having fun, rather than suffering from the cold.
<br>After Tamama tells her what happened in the previous episode, Momoka decides to take everyone on a trip to her ski resort 
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 37
 |EnglishTitleA = Dororo to the Ninja Classroom / Storefront Shinobi!
 |RomajiTitleA = Dororo Kitare Ninja Kyōshitsu e de Arimasu
 |KanjiTitleA = ドロロ きたれ忍者教室へ であります
 |EnglishTitleB = [[Doraemon: Nobita's Dinosaur|Keroro's Dinosaur]] / [[Jurassic Park (film)|Jurassic Lark]]
 |RomajiTitleB = Keroro no Kyōryū de Arimasu
 |KanjiTitleB = ケロロ の恐竜 であります
 |OriginalAirDate = {{Start date|2004|12|11}}
 |ShortSummary=When Keroro finds himself in debt, he decides to open a ninja training school, with Dororo as the teacher. Since nobody shows up, Keroro decides to have Dororo teach the platoon the ways of the ninja, however they struggle to pay attention.
<br>When Natsumi seeks to get revenge on Keroro, she and Fuyuki find themselves in Keroro's latest plan: Triassic Garden.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 38
 |EnglishTitleA = Giroro Love Robot Soldiers / TV's Shooters & Practical Jokes
 |RomajiTitleA = Giroro Ai no Kidō Hohei de Arimasu
 |KanjiTitleA = ギロロ　愛の機動歩兵　であります
 |EnglishTitleB = Giroro vs. Natsumi Re-encounter... / One Potato, Two Potato, Sweet Potato, Amore
 |RomajiTitleB = Giroro tai Natsumi Meguriai...mo de Arimasu
 |KanjiTitleB = ギロロ VS 夏美 めぐりあい…も であります
 |OriginalAirDate = {{Start date|2004|12|18}}
 |ShortSummary= Sumomo and Keroro use hidden cameras to get a laugh out of Giroro's feelings for Hinata, but their plan backfires when a powered-up Natsumi goes on a rampage.

| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 39
 |EnglishTitleA = Keroro Christmas Battle / The Space Frog Who Stole Christmas!
 |RomajiTitleA = Keroro Kurisumasu Daisakusen de Arimasu
 |KanjiTitleA = ケロロ クリスマス大作戦 であります
 |EnglishTitleB = Keroro Spring Cleaning Battle / Keroro: Kahn of Klean!
 |RomajiTitleB = Keroro Shigoto Osame no Daisōji de Arimasu
 |KanjiTitleB = ケロロ 仕事納めの大掃除 であります
 |OriginalAirDate = {{Start date|2004|12|25}}
 |ShortSummary= Christmas time is here, and Keroro plans on using this time to finally conquer the world. However, Keroro is worried that Santa Clause will be first to conquer the planet.
<br>Christmas has come and gone, and now Keroro plans on starting the new year with the greatest house cleaning operation ever. 
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 40
 |EnglishTitleA = Mois, You Could Say Happy New Year? / Soup's Wrong!
 |RomajiTitleA = Moa Teiu ka Kinga Shinnen? de Arimasu
 |KanjiTitleA = モア ていうか謹賀新年? であります
 |EnglishTitleB = Keroro The Food Is Good, Same For Homework / We Don't Needs No Education!
 |RomajiTitleB = Keroro Osechi mo Ii kedo Shukudai mo ne de Arimasu
 |KanjiTitleB = ケロロ おせちもいいけど宿題もね であります
 |OriginalAirDate = {{Start date|2005|1|8}}
 |ShortSummary=Keroro decides to welcome in the new year with many games, most of which involve using Giroro as a test dummy.
<br>The frogs get mail from children from their home planet. When a letter comes requesting Keroro's assignments to be handed in, the platoon has to keep a constant watch on Keroro until he finishes them.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 41
 |EnglishTitleA = Keroro Invasion Strategy / [[A Low Down Dirty Shame|A Low Down Dirty Game]]!
 |RomajiTitleA = Keroro Sugoroku Kōryakusen de Arimasu
 |KanjiTitleA = ケロロ すごろく攻略戦 であります
 |EnglishTitleB = Dororo Is a Fiery Spirit / Self Improvement Is Mass Elation
 |RomajiTitleB = Dororo Mō Retsu ni Nekketsu seyo de Arimasu
 |KanjiTitleB = ドロロ もーれつに熱血せよ であります
 |OriginalAirDate = {{Start date|2005|1|15}}
 |ShortSummary=Keroro and Natsumi get into a heated debate over a very small problem. In order to solve the debate, Keroro and Natsumi play a game where they themselves are the pieces.
<br>Dororo seeks help in order to get attention from the people around him.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 42
 |EnglishTitleA = Keroro and The Red-Blooded Keroro Platoon / [[The War of the Worlds|War of the World's Cup]]!
 |RomajiTitleA = Keroro Akakichi no Keroro Shōtai
 |KanjiTitleA = ケロロ 赤き血のケロロ小隊 であります
 |EnglishTitleB = Tamama, Jealousy Shoot of Friendship / [[Bend It Like Beckham|Friend Him Like Beckham]]
 |RomajiTitleB = Tamama Yūjō no Shitto Shūto! de Arimasu
 |KanjiTitleB = タママ 友情の嫉妬シュート! であります
 |OriginalAirDate = {{Start date|2005|1|22}}
 |ShortSummary=Keroro enters the platoon into the world cup, hoping to gain control of Pekopon. Everything goes well until Keroro kicks the ball into his own goal.
<br>Tamama meets a young soccer player who isn't really good, so Tamama decides to become his teacher.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 43
 |EnglishTitleA = Giroro The Red Demon Who Cannot Cry / [[Red vs. Blue]])
 |RomajiTitleA = Giroro Nakenai Aka Oni de Arimasu
 |KanjiTitleA = ギロロ　泣けない赤鬼　であります
 |EnglishTitleB = Giroro, Flying into Setsubun / [[Springtime for Hitler|Springtime for Hitters]]
 |RomajiTitleB = Giroro Tobidase Setsubun! de Arimasu
 |KanjiTitleB = ギロロ 飛び出せ節分! であります
 |OriginalAirDate = {{Start date|2005|1|29}}
 |ShortSummary= After reading a fairy tale about colorful ogres, Keroro hatches a plan to acquire the ultimate power of the Hinata house.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 44
 |EnglishTitleA = Keroro vs. Fuyuki Heated Sports Match / Alpine Broheims
 |RomajiTitleA = Keroro tai Fuyuki Supōtsu de Kettō de Arimasu
 |KanjiTitleA = ケロロ VS 冬樹 スポーツで決闘 であります
 |EnglishTitleB = Kululu vs. Aki Exploding Invasion of Robots / [[Mr. Roboto|Domo Arigato, Aki Roboto]]!
 |RomajiTitleB = Kururu tai Aki Shinryaku Robo de Bakutō de Arimasu
 |KanjiTitleB = クルル VS 秋 侵略ロボで爆闘 であります
 |OriginalAirDate = {{Start date|2005|2|5}}
 |ShortSummary=
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 45
 |EnglishTitleA = Keroro, Sudden Love for Dango / [[St. Valentine's Day Massacre|St. Valentine's Day Mass Production]]
 |RomajiTitleA = Keroro Ai no Ikinari Dango de Arimasu
 |KanjiTitleA = ケロロ 愛のいきなりだんご であります
 |EnglishTitleB = Natsumi And Momoka, Valentine Operation Initiated / [[V for Vendetta|V for Valentinedetta!]]
 |RomajiTitleB = Natsumi ando Momoka Barentain Sakusen Hatsudō! de Arimasu
 |KanjiTitleB = 夏美&桃華 V(バレンタイン)作戦発動! であります
 |OriginalAirDate = {{Start date|2005|2|12}}
 |ShortSummary=
| LineColor =00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 46
| Title           = Keroro Have You Forgotten Me? / [[Ghost in the Shell|Ghost in the Cell]]!
| TranslitTitle   = Keroro Anata Wasurerarete Imasen ka? de Arimasu
| NativeTitle     = ケロロ あなた忘れられていませんか? であります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2005|2|19}}
| ShortSummary    = The ghost of the house has become angered at being forgotten by Natsumi and Keroro.
| LineColor       = 00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 47
 |EnglishTitleA = Natsumi, Protect the Girls Festival / [[Guys and Dolls|Frogs and Dolls]]!
 |RomajiTitleA = Natsumi Hinamatsuri o Mamore de Arimasu
 |KanjiTitleA = 夏美 ひなまつりを守れ であります
 |EnglishTitleB = Keroro Becomes Afro / [[Saturday Night Fever|Saturday Night Deceiver]]
 |RomajiTitleB = Keroro Afuro de Myaon de Arimasu
 |KanjiTitleB = ケロロ　アフロでみゃおん　であります
 |OriginalAirDate = {{Start date|2005|2|26}}
 |ShortSummary=
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 48
 |EnglishTitleA = Keroro Platoon Spring's Ooh-La-La Battle / Spring Asleepening
 |RomajiTitleA = Keroro Shōtai Haru no Urara no Daisakusen
 |KanjiTitleA = ケロロ小隊 春のうららの大作戦 であります
 |EnglishTitleB = Fuyuki No-No Hazzard Rescue Mission / [[Rainy Days and Mondays|Lazy Days and Mondays Always Get Me Down]]!
 |RomajiTitleB = Fuyuki Damedame Hazādo Kyūshutsu Sakusen
 |KanjiTitleB = 冬樹 ダメダメハザード救出作戦 であります
 |OriginalAirDate = {{Start date|2005|3|5}}
 |ShortSummary= When a case of spring fever sweeps through the Hinata house, Keroro hatches a plan to take over the world with a wave of laziness.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 49
 |EnglishTitleA = Kululu, The Best Method in Space / [[How to Succeed in Business Without Really Trying|How to Succeed in Pekopon Conquering Without Really Trying]]
 |RomajiTitleA = Kururu Uchū de Umaku yaru Hōhō de Arimasu
 |KanjiTitleA = クルル 宇宙でうまくやる方法 であります
 |EnglishTitleB = Momoka, White Day Operation / Momomka's Full-proof Love Plan Plan
 |RomajiTitleB = Momoka Howaito Dei chōjō Sakusen de Arimasu
 |KanjiTitleB = 桃華 W-(ホワイト)デイ頂上作戦 であります
 |OriginalAirDate = {{Start date|2005|3|12}}
 |ShortSummary= Kululu inspires his fellow invaders when he mysteriously starts helping out around the Hinata house. Meanwhile, Momoka will stop at nothing to make a virtual love connection with Fuyuki.
| LineColor =00FF00
}}
{{Japanese episode list multi-part|List of Sgt. Frog episodes
 |NumParts = 2
 |EpisodeNumber = 50
 |EnglishTitleA = Natsumi, Warrior of Earth with a Fever / No More Mr. Nice Frogs!
 |RomajiTitleA = Natsumi Kōnetsu no Chikyū Senshi de Arimasu
 |KanjiTitleA = 夏美 高熱の地球戦士 であります
 |EnglishTitleB = Giroro, If I Don't Do It, Then Who Will? / Okay, a Little More Mr. Nice Frogs!
 |RomajiTitleB = Giroro Ore ga Yaraneba Dare ga Yaru de Arimasu
 |KanjiTitleB = ギロロ 俺がやらねば誰がやる であります
 |OriginalAirDate = {{Start date|2005|3|19}}
 |ShortSummary= Natsumi is stricken by a deadly fever during the Keroro Platoon's latest invasion attempt. Giroro blasts off on a mission to find medicine, but first he must defeat a three-headed space monster.
| LineColor =00FF00
}}
{{Episode list/sublist
| 1               = List of Sgt. Frog episodes (season 1)
| EpisodeNumber   = 51
| Title           = Keroro Platoon Retreats! Good-bye, Pekopon / [[A Farewell to Arms]], Legs, and Other Froggy Parts!
| TranslitTitle   = Keroro Shōtai Tettai! Saraba Pekopon yo de Arimasu
| NativeTitle     = ケロロ小隊 撤退！さらばペコポンよであります
| NativeTitleLangCode = ja 
| OriginalAirDate = {{Start date|2005|3|26}}
| ShortSummary    = Sgt. Keroro receives a mysterious warning that he and his platoon must return to Keron within twenty-four hours or die.
| LineColor       = 00FF00
}}
|}</onlyinclude>

==References==
{{Reflist}}

==External links==
* {{Link language|ja}} [https://web.archive.org/web/20090311021053/http://www.tv-tokyo.co.jp/contents/keroro/episodes/episodes1/ TV Tokyo Keroro Gunsō website 1st season episodes]
* {{Link language|ja}} [http://www.sunrise-inc.co.jp/keroro/schedule/index.html Keroro Gunsō schedule] - Sunrise
{{Sgt. Frog}}

{{DEFAULTSORT:Sgt. Frog episodes (season 1), List of}}
[[Category:2004 Japanese television seasons]]
[[Category:2005 Japanese television seasons]]
[[Category:Sgt. Frog episode lists|Season 1]]

TEXT

begin
  text = parse_text(text).strip
rescue Page::NoTemplatesFound => e
  puts text
  Helper.print_message('Template not found on page')
  exit(1)
# rescue Page::UnresolvedCase => e
#   Helper.print_message(e)
#   Helper.print_message('Hit an unresolved case')
#   exit(1)
end

puts text
Clipboard.copy(text)