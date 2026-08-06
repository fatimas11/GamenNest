// lib/core/translations.dart

const Map<String, Map<String, String>> uiText = {
  'ar': {
    'hub_title': 'مكتبة الألعاب',
    'game_taboo': 'قولها بس لا تقولها',
    'game_charades': 'بدون كلام',
    'game_undercover': 'برا السالفة',
    'game_mafia': 'المافيا',
    'game_letter_grid': 'سين جيم',
    'mafia_setup': 'إعدادات المافيا',
    'add_player': 'أضف لاعب',
    'player_name': 'اسم اللاعب',
    'mafia_count': 'عدد المافيا',
    'min_players_error': 'تحتاج إلى 5 لاعبين على الأقل!',
    'role_mafia': 'مافيا',
    'role_doctor': 'طبيب',
    'role_detective': 'الشايب',
    'role_citizen': 'مواطن',
    'pass_phone': 'مرر الهاتف إلى',
    'tap_reveal': 'تأكد أن لا أحد ينظر، ثم اضغط لمعرفة دورك',
    'hide_next': 'إخفاء والتالي',
    'start_night': 'ابدأ اللعب (الليل)',
    'night_phase': 'مرحلة الليل',
    'king_mafia': 'أيها الملك: اطلب من المافيا فتح أعينهم واختيار ضحية',
    'king_doctor': 'أيها الملك: اطلب من الطبيب فتح عينيه واختيار شخص لإنقاذه',
    'king_detective': 'أيها الملك: اطلب من الشايب فتح عينيه واختيار شخص للتحقيق عنه',
    'detective_yes': 'نعم! إنه من المافيا.',
    'detective_no': 'لا، هو مواطن صالح.',
    'confirm_choice': 'تأكيد الاختيار',
    'wake_up': 'الجميع يستيقظ!',
    'mafia_killed': 'المافيا قامت باغتيال:',
    'doctor_saved': 'ولكن الطبيب نجح في إنقاذه!',
    'day_phase': 'مرحلة النهار',
    'nobody_died': 'القرية آمنة! لم يمت أحد الليلة.',
    'player_died': 'لقد تم اغتيال:',
    'start_voting': 'ابدأ التصويت',
    'pass_to_vote': 'مرر الهاتف للتصويت السري:',
    'skip_vote': 'تخطي / لا أحد',
    'voting_results': 'نتائج التصويت',
    'eliminated': 'تم استبعاد:',
    'was_mafia': 'لقد كان من المافيا!',
    'was_citizen': 'للأسف، كان مواطناً.',
    'citizens_win': '🎉 المواطنون ينتصرون! 🎉',
    'mafia_wins': '💀 المافيا تنتصر! 💀',
    'next_night': 'العودة للنوم (الليل)',
    'back_to_menu': 'العودة للقائمة',
    'view_winner': 'رؤية الفائز!',
    'role_king': 'الملك (مدير اللعبة)',
    'quit_game': 'هل تريد الخروج من اللعبة؟',
    'quit_confirm': 'نعم، خروج',
    'quit_cancel': 'إلغاء',
    'undercover_setup': 'إعدادات برا السالفة',
    'category': 'اختر التصنيف',
    'random_imposters': 'عدد عشوائي للمحتالين',
    'imposter_count': 'عدد المحتالين',
    'cat_animals': 'حيوانات',
    'cat_food': 'طعام',
    'cat_places': 'أماكن',
    'cat_jobs': 'مهن',
    'cat_sports': 'رياضة',    
    'cat_vehicles': 'مركبات',  
    'cat_technology': 'تكنولوجيا', 
    'cat_nature': 'طبيعة', 
    'cat_body_parts': 'أعضاء الجسم', 
    'cat_colors': 'ألوان',
    'imposter_reveal': 'أنت برا السالفة!',
    'citizen_reveal': 'الكلمة السرية هي:',
    'start_discussion': 'ابدأ المناقشة',
    'imposter_guess': 'أيها المحتال، خمن الكلمة لتربح نقطة:',
    'correct_guess': 'تخمين صحيح! +1 للمحتال',
    'wrong_guess': 'تخمين خاطئ!',
    'final_scores': 'النتائج النهائية',
    'points': 'نقاط',
    'bomb_setup': 'إعدادات القنبلة',
    'bomb_desc': 'قل إجابة من التصنيف ومرر الهاتف قبل الانفجار!',
    'bomb_start': 'ابدأ التوقيت',
    'bomb_exploded': 'بُوم! انفجرت القنبلة!',
    'next_player': 'اللاعب التالي',
    'game_bomb': 'القنبلة',
    'game_scale': 'الميزان البشري',
    'scale_desc': 'رتب أصدقاءك!',
    'scale_guess': 'خمن الترتيب!',
    'scale_submit': 'تأكيد الترتيب',
    'scale_win': 'فوز! لقد عرفتم ذوق القاضي',
    'scale_lose': 'خسارة! لم يكن التخمين موفقاً',
    'is_judge': 'هو القاضي (صاحب القرار)',
    'drag_to_reorder': 'اسحب الأسماء لترتيبها',
    'next_round': 'الجولة التالية',
    'finish_game': 'إنهاء اللعبة وعرض النتائج',
    'mafia_instr_1': "شريكك هو: {partner}. اختر شخصاً لقتله. تنبيه: الشريك الثاني لديه القرار النهائي.",
    'mafia_instr_2': "شريكك هو: {partner}. اقترح زميلك قتل: {target}. القرار النهائي لك الآن!",
    'mafia_instr_solo': "أنت المافيا الوحيد. اختر ضحيتك.",
    'mafia_partner_err': "لا يمكنك اختيار شريكك!",
    'doctor_instr': "أنت الطبيب. اختر شخصاً لحمايته الليلة.",
    'detective_instr': "أنت المحقق. اختر شخصاً لكشف هويته.",
    'citizen_instr': "أنت مواطن. اختر أي شخص للتمويه.",
    'pass_phone_to': "مرر الهاتف إلى:",
    'reveal_role_btn': "أنا هنا / إظهار الدور",
    'king_hold_phone': "الآن الملك يمسك الهاتف",
    'everyone_sleep': "الجميع ينامون، أغمضوا أعينكم",
    'mafia_wake': "المافيا، استيقظوا واختاروا ضحية",
    'doctor_wake': "الطبيب، استيقظ واختر شخصاً لحمايته",
    'detective_wake': "المحقق، استيقظ واختر شخصاً لكشفه",
    'everyone_wake': "الجميع استيقظوا! لديكم دقيقة للنقاش",
    'sit_in_circle': "يرجى الجلوس في دائرة لتسهيل تمرير الهاتف",
    'repeat_target_err': "لا يمكن اختيار نفس الشخص ليلتين متتاليتين!",
    'king_announce_title': "تحديد الملك",
    'king_announce_body': " {name} هو الملك! سيقوم الملك بإدارة اللعبة الآن.",
    'rules_undercover': '''
🕵️‍♂️ **الهدف**
اجمع أكبر عدد من النقاط بكشف المخادعين (المدسوسين)، أو بالخداع إذا كنت أنت المخادع!

🎮 **طريقة اللعب**
١. يحصل كل لاعب على كلمة. "المواطنون" لديهم كلمة متشابهة، و"المخادع" لديه "؟؟؟".
٢. كل لاعب يصف كلمته بكلمة واحدة فقط في دورة.
٣. بعد النقاش، يتم التصويت على من تعتقدون أنه المخادع.

💰 **نظام النقاط الحاسم**
- **كشف مخادع:** تحصل على (+١) نقطة عن كل مخادع تصوت عليه بشكل صحيح.
- **المخادع يكشف زميله:** إذا كان هناك أكثر من مخادع وكشف أحدهم الآخر، يحصل على (+١) نقطة.
- **تخمين الكلمة:** يحصل المخادع على (+١) نقطة إذا استطاع تخمين كلمة المواطنين، و (-١) إذا فشل.
- **تصويت خاطئ:** إذا صوتت ضد مواطن بريء، يتم خصم (-١) نقطة منك.

⚠️ **ملاحظة:** إذا كان هناك مخادع واحد فقط في اللعبة، فلا يتم خصم نقطة منه إذا صوت ضد مواطن.

🏆 **الفائز**
اللاعب الذي يجمع أكبر عدد من النقاط في نهاية اللعبة هو الفائز!''',
    'rules_mafia': '''
🔫 **الهدف**
المافيا تريد السيطرة على المدينة؛ المواطنون يريدون إنقاذها!

🌙 **مرحلة الليل (سري)**
- **المافيا:** يختارون لاعباً واحداً لاستبعاده.
- **الطبيب:** يختار لاعباً لإنقاذه (إذا كان هو نفس هدف المافيا، ينجو!).
- **الشايب (التحقيق):** يختار لاعباً ليكشف هويته الحقيقية.

☀️ **مرحلة النهار (علني)**
- تستيقظ المدينة وتعرف من قُتل.
- يتناقش الجميع لمعرفة من هو المافيا.
- يتم التصويت لاستبعاد مشتبه به واحد.

🏆 **الفوز**
- يفوز المواطنون إذا قضوا على كل المافيا.
- يفوز المافيا إذا تساوى عددهم مع عدد المواطنين.''',
    'rules_scale': '''
⚖️ **الهدف**
تخمين كيف قام "القاضي" بترتيب أصدقائه بدقة.

🎭 **الأدوار**
- لاعب واحد هو **القاضي**، والباقي هم **المخمنون**.

🕹️ **خطوات اللعب**
١. يحصل القاضي على سؤال (مثلاً: رتب الأصدقاء من الأكثر مرحاً إلى الأقل).
٢. يقوم القاضي بترتيب الأسماء سراً على الهاتف.
٣. يمرر الهاتف للمجموعة، ويجب عليهم محاكاة نفس الترتيب تماماً.
٤. يقارن التطبيق بين الترتيبين!

🏆 **الفوز**
- تحصل على نقاط لكل اسم في مكانه الصحيح تماماً كما رتبه القاضي.''',
    'rules_taboo': '''
🤐 **الهدف**
اجعل فريقك يحزر الكلمة دون قول أي من الكلمات الممنوعة.

🎮 **طريقة اللعب**
١. ينقسم اللاعبون إلى فريقين.
٢. يتقدم لاعب من كل فريق: "المرشح" (من فريقك) و"المراقب" (من الفريق الخصم).
٣. يرى "المراقب" الشاشة ليتأكد أن "المرشح" لا يقول أي كلمة ممنوعة.
٤. إذا قال المرشح كلمة ممنوعة، يصرخ المراقب "خطأ!"، ويحصل الفريق الخصم على نقطة فوراً وننتقل للكلمة التالية.

🏆 **الفوز**
الفريق الذي يجمع أكبر عدد من النقاط قبل انتهاء الوقت هو الفائز!''',
    'rules_charades': '''
🎭 **الهدف**
مثل الكلمة لفريقك واجمع أكبر عدد من النقاط قبل انتهاء الوقت! الفريق الفائز هو صاحب أعلى نقاط.

🎮 **طريقة اللعب**
١. ينقسم اللاعبون إلى فريقين.
٢. في كل جولة، يرسل الفريق لاعباً واحداً (الممثل) ليمسك الهاتف ويرى الكلمة.
٣. يقوم اللاعب بتمثيل الكلمة لفريقه باستخدام الحركات فقط (ممنوع الكلام أو إصدار أصوات).
٤. الفريق هو من يحاول الحزر، ولا يرى الشاشة أبداً.

📲 **التحكم بالأزرار**
- **صح ✅:** إذا حزر فريقك الكلمة، يضغط الممثل على زر "صح" لإضافة نقطة.
- **تخطي ⏩:** إذا كانت الكلمة صعبة، يضغط الممثل على زر "تخطي" للانتقال للكلمة التالية.

🏆 **الفوز**
بعد انتهاء جميع الجولات، الفريق الذي جمع أكبر عدد من التخمينات الصحيحة هو الفائز!''',
    'rules_bomb': '''
💣 **الهدف**
لا تكن الشخص الذي يمسك الهاتف عندما تنفجر القنبلة!

🎮 **طريقة اللعب**
١. تظهر فئة معينة (مثلاً: ماركات سيارات).
٢. يجب على من يمسك الهاتف قول إجابة لم يقلها أحد من قبل ثم تمرير الهاتف بسرعة.
٣. الوقت عشوائي ومخفي، القنبلة قد تنفجر في أي لحظة!

🏆 **الفوز**
الخاسر هو من ينفجر الهاتف في يده.''',
    'title': 'إعدادات اللعبة', 'time': 'وقت الجولة', 'forbidden': 'عدد الكلمات الممنوعة', 'start': 'ابدأ اللعبة', 'sec': 'ثانية', 'score': 'النقاط', 'skip': 'تجاوز', 'correct': 'صح', 'over': 'انتهى الوقت!'
  },
  'en': {
    'hub_title': 'Game Hub',
    'game_taboo': 'Taboo',
    'game_charades': 'Charades',
    'game_undercover': 'Imposter (Undercover)',
    'game_mafia': 'Mafia',
    'game_letter_grid': 'Letter Path Grid',
    'mafia_setup': 'Mafia Setup',
    'add_player': 'Add Player',
    'player_name': 'Player Name',
    'mafia_count': 'Mafia Count',
    'min_players_error': 'You need at least 5 players!',
    'role_mafia': 'Mafia',
    'role_doctor': 'Doctor',
    'role_detective': 'Detective',
    'role_citizen': 'Citizen',
    'pass_phone': 'Pass the phone to',
    'tap_reveal': 'Make sure no one is looking, tap to reveal',
    'hide_next': 'Hide & Next Player',
    'start_night': 'Start Night Phase',
    'night_phase': 'Night Phase',
    'king_mafia': 'King: Tell the Mafia to wake up and pick a target.',
    'king_doctor': 'King: Tell the Doctor to wake up and save someone.',
    'king_detective': 'King: Tell the Detective to wake up and investigate someone.',
    'detective_yes': 'YES! They are Mafia.',
    'detective_no': 'No, they are a Citizen.',
    'confirm_choice': 'Confirm Choice',
    'wake_up': 'Everyone Wake Up!',
    'mafia_killed': 'The Mafia assassinated:',
    'doctor_saved': 'But the Doctor successfully saved them!',
    'day_phase': 'Day Phase',
    'nobody_died': 'The village is safe! Nobody died.',
    'player_died': 'Assassinated tonight:',
    'start_voting': 'Start Voting',
    'pass_to_vote': 'Pass phone for secret vote:',
    'skip_vote': 'Skip Vote',
    'voting_results': 'Voting Results',
    'eliminated': 'Eliminated:',
    'was_mafia': 'They were MAFIA!',
    'was_citizen': 'Sadly, they were a Citizen.',
    'citizens_win': '🎉 CITIZENS WIN! 🎉',
    'mafia_wins': '💀 MAFIA WINS! 💀',
    'next_night': 'Go Back to Sleep',
    'back_to_menu': 'Back to Menu',
    'view_winner': 'View Winner!',
    'role_king': 'King (Game Master)',
    'quit_game': 'Quit the game?',
    'quit_confirm': 'Yes, Quit',
    'quit_cancel': 'Cancel',
    'undercover_setup': 'Imposter Setup',
    'category': 'Choose Category',
    'random_imposters': 'Random Imposter Count',
    'imposter_count': 'Imposter Count',
    'cat_animals': 'Animals',
    'cat_food': 'Food',
    'cat_places': 'Places',
    'cat_jobs': 'Jobs',
    'cat_sports': 'Sports',
    'cat_vehicles': 'Vehicles',
    'cat_technology': 'Technology',
    'cat_nature': 'Nature',
    'cat_body_parts': 'Body Parts',
'cat_colors': 'Colors',
    'imposter_reveal': 'You are the Imposter!',
    'citizen_reveal': 'The secret word is:',
    'start_discussion': 'Start Discussion',
    'imposter_guess': 'Imposter, guess the word to earn a point:',
    'correct_guess': 'Correct! +1 for Imposter',
    'wrong_guess': 'Wrong guess!',
    'final_scores': 'Final Scores',
    'points': 'Points',
    'bomb_setup': 'The Bomb Setup',
    'bomb_desc': 'Say an answer from the category and pass the phone before it explodes!',
    'bomb_start': 'Start Ticking',
    'bomb_exploded': 'BOOM! The bomb exploded!',
    'next_player': 'Next Player',
    'game_bomb': 'The Bomb',
    'game_scale': 'Human Scale',
    'scale_desc': 'Rank your friends based on the question!',
    'scale_submit': 'Confirm Ranking',
    'scale_guess': 'Guess the Order!',
    'scale_win': 'You Win! More rights than wrongs!',
    'scale_lose': 'You Lose! Too many mistakes.',
    'king_hold_phone': "Now the King holds the phone",
    'everyone_sleep': "Everyone sleep, close your eyes",
    'mafia_wake': "Mafia, wake up and choose a victim",
    'doctor_wake': "Doctor, wake up and choose someone to protect",
    'detective_wake': "Detective, wake up and choose someone to reveal",
    'everyone_wake': "Everyone wake up! You have 1 minute to discuss",
    'sit_in_circle': "Please sit in a circle to make passing the phone easier",
    'repeat_target_err': "You cannot choose the same person twice in a row!",
    'mafia_instr_1': "Partner: {partner}. Pick someone to kill. Note: The 2nd partner has the final choice.",
    'mafia_instr_2': "Partner: {partner}. Your partner suggested: {target}. You have the final choice!",
    'mafia_instr_solo': "You are the only Mafia. Choose your victim.",
    'mafia_partner_err': "You cannot pick your partner!",
    'doctor_instr': "You are the Doctor. Choose someone to protect tonight.",
    'detective_instr': "You are the Detective. Choose someone to reveal their identity.",
    'citizen_instr': "You are a Citizen. Choose anyone to bluff.",
    'pass_phone_to': "Pass the phone to:",
    'reveal_role_btn': "I am here / Reveal Role",
    'king_announce_title': "King Assigned",
    'king_announce_body': "{name} is the King! The King will manage the game now.",
    'rules_undercover': '''
🕵️‍♂️ **THE OBJECTIVE**
Identify the Imposters to gain points. If you are the Imposter, deceive the group and guess the secret word!

🎮 **HOW TO PLAY**
1. **Secret Words:** Most players see the "Citizen Word." One or more players see the "???".
2. **Descriptions:** Everyone gives a one-word description of their word in a circle.
3. **Voting:** After discussing, everyone votes for who they think is the Imposter.

💰 **SCORING SYSTEM**
- **Identify an Imposter:** +1 Point for each correct vote.
- **Imposter vs Imposter:** +1 Point if an Imposter correctly identifies another Imposter.
- **Guess the Word:** The Imposter gets +1 Point for guessing the Citizen's word, and -1 Point if they fail.
- **Wrong Vote:** -1 Point if you vote for an innocent Citizen.

⚠️ **SPECIAL RULE:** If there is only ONE Imposter, they do NOT lose a point for voting for a Citizen.

🏆 **WINNER**
The player with the highest total score at the end wins!''',
    'rules_mafia': '''
🔫 **THE OBJECTIVE**
Mafia wants to take over the town; Citizens want to save it!

🌙 **NIGHT PHASE (Secret)**
- **Mafia:** Choose one player to eliminate.
- **Doctor:** Choose one player to save.
- **Detective:** Pick one player to investigate.

☀️ **DAY PHASE (Public)**
- The town wakes up and sees who died. 
- Everyone debates who the Mafia might be.
- The group votes to execute one suspect.

🏆 **WINNING**
- Citizens win if all Mafia are gone.
- Mafia wins if their numbers equal the number of Citizens.''',
    'rules_scale': '''
⚖️ **THE OBJECTIVE**
Guess exactly how the "Judge" ranks their friends.

🕹️ **STEP-BY-STEP**
1. The Judge secretly ranks the players based on a question.
2. The Judge passes the phone. The group must debate and try to match that list.
3. The app compares the lists!

🏆 **WINNING**
- You get points for every name in the correct slot.''',
    'rules_taboo': '''
🤐 **THE OBJECTIVE**
Get your team to guess the word without saying any "Forbidden" words.

🎮 **HOW TO PLAY**
1. Divide into two teams.
2. Each turn, send two people to the front: a "Clue-Giver" (from your team) and a "Sentry" (from the opposing team).
3. The Sentry watches the screen. If the Clue-Giver says a forbidden word, the Sentry shouts "Taboo!".
4. If a violation occurs, the opposing team gets the point, and you move to the next word.

🏆 **WINNING**
The team with the most points wins!''',
    'rules_charades': '''
🎭 **THE OBJECTIVE**
Act out the words and get your team to guess as many as possible! The team with the most points wins.

🎮 **HOW TO PLAY**
1. Divide into two teams.
2. Each round, one team sends a "performer" to hold the phone and see the word.
3. The performer acts out the words using movements only (no speaking or sounds).
4. The team must guess—they should never see the screen.

📲 **BUTTON CONTROLS**
- **Correct ✅:** If your team guesses correctly, the performer taps "Correct" (+1 point).
- **Skip ⏩:** If the word is too difficult, the performer taps "Skip" to move to the next word.

🏆 **WINNING**
The team with the highest total of correct guesses wins!''',
    'rules_bomb': '''
💣 **THE OBJECTIVE**
Don't hold the phone when the bomb explodes!

🎮 **HOW TO PLAY**
1. Say an answer for the category and pass the phone.
2. The timer is hidden and random!

🏆 **WINNING**
The person who "explodes" loses.''',
    'title': 'Game Settings', 'time': 'Round Time', 'forbidden': 'Forbidden Words', 'start': 'Start Game', 'sec': 'sec', 'score': 'Score', 'skip': 'Skip', 'correct': 'Correct', 'over': 'Time Up!'
  },
  'he': {
    'hub_title': 'ספריית משחקים',
    'game_taboo': 'תגיד את זה, אל תגיד את זה',
    'game_charades': 'פנטומימה (ללא מילים)',
    'game_undercover': 'המתחזה (מחוץ להקשר)',
    'game_mafia': 'מאפיה',
    'game_letter_grid': 'מסלול אותיות',
    'mafia_setup': 'הגדרות מאפיה',
    'add_player': 'הוסף שחקן',
    'player_name': 'שם שחקן',
    'mafia_count': 'מספר אנשי מאפיה',
    'min_players_error': 'צריך לפחות 5 שחקנים!',
    'role_mafia': 'מאפיה',
    'role_doctor': 'רופא',
    'role_detective': 'בלש',
    'role_citizen': 'אזרח',
    'pass_phone': 'העבר את הטלפון אל',
    'tap_reveal': 'וודא שאף אחד לא מסתכל, לחץ כדי לגלות',
    'hide_next': 'הסתר והבא',
    'start_night': 'התחל את שלב הלילה',
    'night_phase': 'שלב הלילה',
    'king_mafia': 'מלך: תגיד למאפיה להתעורר ולבחור קורבן.',
    'king_doctor': 'מלך: תגיד לרופא להתעורר ולהציל מישהו.',
    'king_detective': 'מלך: תגיד לבלש להתעורר ולחקור מישהו.',
    'detective_yes': 'כן! הוא מאפיה.',
    'detective_no': 'לא, הוא אזרח.',
    'confirm_choice': 'אשר בחירה',
    'wake_up': 'כולם להתעורר!',
    'mafia_killed': 'המאפיה התנקשה ב:',
    'doctor_saved': 'אבל הרופא הצליח להציל אותו!',
    'day_phase': 'שלב היום',
    'nobody_died': 'הכפר בטוח! אף אחד לא מת.',
    'player_died': 'נרצח הלילה:',
    'start_voting': 'התחל הצבעה',
    'pass_to_vote': 'העבר טלפון להצבעה חשאית:',
    'skip_vote': 'דלג על הצבעה',
    'voting_results': 'תוצאות הצבעה',
    'eliminated': 'הודח:',
    'was_mafia': 'הוא היה מאפיה!',
    'was_citizen': 'לצערנו, הוא היה אזרח.',
    'citizens_win': '🎉 האזרחים ניצחו! 🎉',
    'mafia_wins': '💀 המאפיה ניצחה! 💀',
    'next_night': 'חזור לישון',
    'back_to_menu': 'חזרה לתפריט',
    'view_winner': 'צפה במנצח!',
    'role_king': 'מלך (מנהל המשחק)',
    'quit_game': 'לצאת מהמשחק?',
    'quit_confirm': 'כן, צא',
    'quit_cancel': 'ביטול',
    'undercover_setup': 'הגדרות מתחזה',
    'category': 'בחר קטגוריה',
    'random_imposters': 'מספר מתחזים אקראי',
    'imposter_count': 'מספר מתחזים',
    'cat_animals': 'חיות',
    'cat_food': 'אוכל',
    'cat_places': 'מקומות',
    'cat_jobs': 'עבודות',
    'cat_sports': 'ספורט',
    'cat_vehicles': 'כלי רכב',
    'cat_technology': 'טכנולוגיה',
    'cat_nature': 'טבע',
    'cat_body_parts': 'חלקי גוף',
    'cat_colors': 'צבעים',
    'imposter_reveal': 'אתה המתחזה!',
    'citizen_reveal': 'המילה הסודית היא:',
    'start_discussion': 'התחל דיון',
    'imposter_guess': 'מתחזה, נחש את המילה כדי לזכות בנקודה:',
    'correct_guess': 'ניחוש נכון! +1 למתחזה',
    'wrong_guess': 'ניחוש שגוי!',
    'final_scores': 'תוצאות סופיות',
    'points': 'נקודות',
    'bomb_setup': 'הגדרות הפצצה',
    'bomb_desc': 'תגיד תשובה מהקטגוריה ותעביר את הטלפון לפני שהוא מתפוצץ!',
    'bomb_start': 'התחל לתקתק',
    'bomb_exploded': 'בום! הפצצה התפוצצה!',
    'next_player': 'השחקן הבא',
    'game_bomb': 'הפצצה',
    'game_scale': 'המיזאן האנושי',
    'scale_desc': 'דרגו את החברים!',
    'scale_guess': 'נחשו את הדירוג!',
    'scale_submit': 'אשר דירוג',
    'scale_win': 'ניצחון! קלעתם לטעם של השופט',
    'scale_lose': 'הפסד! הניחושים לא היו קרובים',
    'is_judge': 'הוא השופט (המחליט)',
    'drag_to_reorder': 'גררו את השמות כדי לסדר',
    'next_round': 'סיבוב הבא',
    'finish_game': 'סיים משחק והצג תוצאות',
    'king_hold_phone': "עכשיו המלך מחזיק את הטלפון",
    'everyone_sleep': "כולם לישון, עיצמו עיניים",
    'mafia_wake': "מאפיה, להתעורר ולבחור קורבן",
    'doctor_wake': "רופא, להתעורר ולבחור במי להגן",
    'detective_wake': "בלש, להתעורר ולבחור את מי לחשוף",
    'everyone_wake': "כולם להתעורר! יש לכם דקה אחת לדיון",
    'sit_in_circle': "אנא שבו במעגל כדי להקל על העברת הטלפון",
    'repeat_target_err': "אי אפשר לבחור באותו אדם פעמיים ברצף!",
    'mafia_instr_1': "השותף שלך: {partner}. בחר מישהו להרוג. הערה: לשותף השני יש את הבחירה הסופית.",
    'mafia_instr_2': "השותף שלך: {partner}. השותף הציע להרוג את: {target}. הבחירה הסופית בידך!",
    'mafia_instr_solo': "אתה המאפיה היחיד. בחר את הקורבן שלך.",
    'mafia_partner_err': "אי אפשר לבחור את השותף שלך!",
    'doctor_instr': "אתה הרופא. בחר מישהו להגן עליו הלילה.",
    'detective_instr': "אתה הבלש. בחר מישהו כדי לגלות את זהותו.",
    'citizen_instr': "אתה אזרח. בחר כל אחד כדי להסוות את עצמך.",
    'pass_phone_to': "העבר את הטלפון ל:",
    'reveal_role_btn': "אני כאן / הצג תפקיד",
    'king_announce_title': "מינוי המלך",
    'king_announce_body': "{name} הוא המלך! המלך ינהל את המשחק מעכשיו.",
    'rules_undercover': '''
🕵️‍♂️ **המטרה**
זהו את המתחזים כדי לצבור נקודות. אם אתם המתחזים, רימו את הקבוצה ונסו לנחש את המילה הסודית!

🎮 **איך משחקים?**
1. **מילים סודיות:** רוב השחקנים רואים את "מילת האזרח". שחקן אחד או יותר רואים את "???".
2. **תיאורים:** כל שחקן מתאר את המילה שלו במילה אחת בלבד בסבב.
3. **הצבעה:** לאחר הדיון, כולם מצביעים למי שהם חושבים שהוא המתחזה.

💰 **שיטת הניקוד**
- **זיהוי מתחזה:** +1 נקודה על כל הצבעה נכונה נגד מתחזה.
- **מתחזה נגד מתחזה:** +1 נקודה אם מתחזה מזהה נכון מתחזה אחר.
- **ניחוש המילה:** המתחזה מקבל +1 נקודה אם ניחש נכון את מילת האזרחים, ו-1- אם נכשל.
- **הצבעה שגויה:** 1- נקודה אם הצבעתם נגד אזרח חף מפשע.

⚠️ **כלל מיוחד:** אם יש רק מתחזה אחד במשחק, הוא לא מפסיד נקודה אם הצביע נגד אזרח.

🏆 **המנצח**
השחקן עם מספר הנקודות הגבוה ביותר בסיום המשחק הוא המנצח!''',
    'rules_mafia': '''
🔫 **המטרה**
המאפיה רוצה להשתלט; האזרחים רוצים להציל את העיר!

🌙 **שלב הלילה (סודי)**
- **מאפיה:** בחרו שחקן אחד לחיסול.
- **רופא:** בחרו שחקן אחד להצלה.
- **בלש:** בחרו שחקן אחד לחקירה.

☀️ **שלב היום (פומבי)**
- העיירה מתעוררת ומגלה מי נרצח.
- כולם דנים מי עשוי להיות המאפיה.
- מצביעים על חשוד אחד להדחה.

🏆 **ניצחון**
- האזרחים מנצחים אם כל המאפיה חוסלה.
- המאפיה מנצחת אם מספרם שווה למספר האזרחים.''',
    'rules_scale': '''
⚖️ **המטרה**
נחשו בדיוק איך "השופט" דירג את חבריו.

🕹️ **שלב אחרי שלב**
1. השופט מדרג סודית את השמות לפי שאלה.
2. הטלפון עובר לקבוצה, ועליהם לנחש את אותו הדירוג בדיוק.
3. האפליקציה משווה בין הדירוגים!

🏆 **ניצחון**
- מקבלים נקודות על כל שם שנמצא במיקום המדויק שהשופט בחר.''',
    'rules_taboo': '''
🤐 **המטרה**
גרמו לקבוצה לנחש את המילה מבלי להגיד מילים אסורות.

🎮 **איך משחקים?**
1. מתחלקים לשתי קבוצות.
2. בכל תור, שולחים שני נציגים: "המסביר" (מהקבוצה שלכם) ו"המשגיח" (מהקבוצה היריבה).
3. המשגיח מסתכל במסך כדי לוודא שהמסביר לא אומר מילה אסורה.
4. אם נאמרה מילה אסורה, המשגיח צועק "טאבו!", הקבוצה היריבה מקבלת נקודה ועוברים למילה הבאה.

🏆 **ניצחון**
הקבוצה עם הכי הרבה נקודות מנצחת!''',
    'rules_charades': '''
🎭 **המטרה**
שחקו את המילים וגרמו לקבוצה שלכם לנחש כמה שיותר! הקבוצה עם הכי הרבה נקודות מנצחת.

🎮 **איך משחקים?**
1. מתחלקים לשתי קבוצות.
2. בכל סיבוב, קבוצה אחת שולחת "נציג" שמחזיק את הטלפון ורואה את המילה.
3. הנציג מציג את המילה לקבוצה שלו בעזרת תנועות גוף בלבד (ללא מילים או קולות).
4. הקבוצה צריכה לנחש—חברי הקבוצה לא אמורים לראות את המסך.

📲 **שליטה בכפתורים**
- **נכון ✅:** אם הקבוצה ניחשה נכון, הנציג לוחץ על "נכון" (+1 נקודה).
- **דילוג ⏩:** אם המילה קשה מדי, הנציג לוחץ על "דילוג" כדי לעבור למילה הבאה.

🏆 **ניצחון**
הקבוצה שצברה את מספר הניחושים הנכונים הגבוה ביותר בסיום המשחק היא המנצחת!''',
    'rules_bomb': '''
💣 **המטרה**
אל תחזיקו את הטלפון כשהפצצה מתפוצצת!

🎮 **איך משחקים?**
1. אמרו תשובה לקטגוריה והעבירו את הטלפון מהר.
2. הטיימר נסתר ואקראי!

🏆 **ניצחון**
האדם שבידו הפצצה התפוצצה מפסיד.''',
    'title': 'הגדרות משחק', 'time': 'זמן סיבוב', 'forbidden': 'מילים אסורות', 'start': 'התחל משחק', 'sec': 'שניות', 'score': 'ניקוד', 'skip': 'דלג', 'correct': 'נכון', 'over': 'נגמר הזמן!'
  },
};