local spellbook = {}
local category = "Attack"

local function category(cat)
	table.insert(spellbook, { name=cat })
end

local function spell(name)
	return function(gestures)
		return function(description)
			description = description:gsub("%s+", " "):gsub('$pp', '\n\n'):trim()
			table.insert(spellbook[#spellbook], { name=name, desc=description, gest=gestures })
		end
	end
end

	category "Defence"

spell 'Shield' 'P' [[
$pp This spell protects the subject from all attacks from monsters (that is, creatures created by a summoning spell), from 'missile' spells, and from stabs by wizards. The shield lasts for that turn only, but one shield will cover all such attacks made against the subject that turn.$pp
]]

spell 'Remove enchantment' 'P-D-W-P' [[
$pp If the subject of this spell is currently being affected by any of the spells in the  "enchantments" section, or if spells from that section are cast at him at the same time as the remove enchantment, then all such spells terminate immediately (although their effect for that turn might already have passed.) For example, the victim of a 'blindness' spell would not be able to see what his opponent's gestures were on the turn that his sight is restored by a 'remove enchantment'. Note that the 'remove enchantment' affects  all enchantments whether the caster wants them to all go or not. A second effect of the spell is to destroy any monster upon which it is cast, although the monster can attack in that turn.$pp
]]

spell 'Magic mirror' '(c-(w' [[
$pp Any spell cast at the subject of this spell is reflected back at the caster of that spell for that turn only. This includes spells  like 'missile' and 'lightning bolt' but does not include attacks by monsters already in existence, or stabs from wizards. Note that certain spells are cast by wizards usually upon themselves (e.g. spells from this section and the "Summons" section); the mirror has no effect on these spells. It is countered totally, with no effect whatsoever, if the subject is the simultaneous subject of either  a 'counter-spell' or 'dispel magic'. It has no effect on spells which affect more than one person, such as 'fire storm'. Two mirrors cast at someone simultaneously combine to form a single mirror.  If a spell is reflected from a mirror back at a wizard who .I also has a mirror, the spell bounces back and forth until it falls apart.$pp
]]

spell 'Counter-spell' 'W-P-P or W-W-S' [[
 .I or$pp Any other spell cast upon the subject in the same turn has no effect whatever. In the case of blanket-type spells, which affect more than one person, the subject of the 'counter-spell' alone is protected. For example, a 'fire storm' spell would not affect a wizard if that wizard was simultaneously the subject of a 'counter-spell', but everyone else would be affected as usual (unless they had their own protection.) The 'counter-spell' will cancel all the spells cast at the subject for that turn, including 'remove enchantment' and 'magic mirror', but  not 'dispel magic' or 'finger of death'. It will combine with another spell of its own type for the same effect as if it were alone.  The 'counter-spell' will also act as a 'shield' on its subject,  in addition to its other properties. The spell has two alternative gesture sequences, either of which may be used at any time.$pp
]]

spell 'Dispel magic' '(c-D-P-W' [[
$pp This spell acts as a combination of 'counter-spell' and 'remove enchantment', but its effects are universal rather than limited to the subject of the spell. It will stop any spell cast in the same turn from working (apart from another 'dispel magic' spell which combines with it for the same result), and will remove all enchantments from all beings before they have effect. In addition, all monsters are destroyed, although they can attack that turn. 'Counter-spells'  and 'magic mirrors' have no effect. Like the 'counter-spell', it  also acts as a 'shield' for its subject. 'Dispel magic' will not dispel  stabs or surrenders, since they are not spells (although  the 'shield' effect may block a stab.)$pp
]]

spell 'Raise dead' 'D-W-W-F-W-(c' [[
$pp The subject of this spell is usually a recently dead  human or monster corpse (it will not work on elementals, which dissipate when destroyed.) When the spell is cast, life is instilled back into the corpse and any damage which it has sustained is cured until the owner is back to his usual state of health.  A 'remove enchantment' effect is also manifest so any 'diseases' or 'poisons' will be neutralized (plus any other enchantments).  The subject will be able to act as normal immediately, so that next  turn he can gesture, fight, etc. If the subject is a monster, it will be under the control of the wizard who raised it, and it will be able to attack that turn. .br If the spell is cast on a live individual, the effect is that of a 'cure wounds' recovering 5 points of damage, or as many as have been sustained if less than 5. In this case, 'diseases', 'poisons', and other enchantments are .I not removed.  .br This is the only spell which affects corpses properly; therefore, it cannot be stopped by a 'counter-spell', since 'counter-spell' can only be cast on living beings. A 'dispel magic' spell will stop it, since that affects all spells no matter what their subject.  Once alive the subject is treated as normal.$pp
]]

spell 'Cure light wounds' 'D-F-W' [[
$pp If the subject has received damage then he is cured by 1 point as if that point had not been inflicted. (Recall that all spells are resolved simultanously; if a wizard is suffers his 15th point of damage at the same time as he is affected by 'cure light wounds', he will remain alive with 14 points of damage at the end of the turn.) The effect is not removed by a 'dispel magic' or 'remove enchantment'.$pp
]]

spell 'Cure heavy wounds' 'D-F-P-W' [[
$pp This spell is the same as 'cure light wounds' for its effect, but 2 points of damage are cured instead of 1, or only 1 if only 1 had been sustained. A side effect is that the spell will also cure a  disease. (Note that 'raise dead' on a live individual won't).$pp$pp
]]

	category "Summon"

spell 'Summon Goblin' 'S-F-W' [[
$pp This spell creates a goblin under the control of the wizard upon whom the spell is cast. The goblin can attack immediately and its victim can be any any wizard or other monster the controller desires. The goblin does 1 point of damage to its victim per turn and is destroyed after 1 point of damage is inflicted upon it.$pp
]]

spell 'Summon Ogre' 'P-S-F-W' [[
$pp This spell is the same as 'summon goblin', but the ogre created inflicts and is destroyed by 2 points of damage rather than 1.$pp
]]

spell 'Summon Troll' 'F-P-S-F-W' [[
$pp This spell is the same as 'summon goblin', but the troll created inflicts and is destroyed by 3 points of damage rather than 1.$pp
]]

spell 'Summon Giant' 'W-F-P-S-F-W' [[
$pp This spell is the same as 'summon goblin', but the giant created inflicts and is destroyed by 4 points of damage rather than 1.$pp
]]

spell 'Summon Elemental' '(c-S-W-W-S' [[
$pp This spell creates either a fire elemental or an ice elemental, at the discretion of the wizard upon whom the spell is cast (after he has seen all the gestures made that turn.)$pp Elementals must be cast at someone and cannot be "shot off" harmlessly at some inanimate object. The elemental will, for that turn and until destroyed, attack everyone (including its owner, and other monsters), causing 3 points of damage per turn. Only wizards and monsters who are resistant to the elemental's element (heat or cold), or who have a 'shield' or a spell with a 'shield' effect, are safe. The elemental takes 3 points of damage to be killed but may be destroyed by spells of the opposite type (e.g. 'fire storm', 'resist cold' or 'fireball' will kill an ice elemental), and will also neutralize the cancelling spell. Elementals will not attack on the turn they are destroyed by such a spell. An elemental will also be engulfed and destroyed by a storm of its own type but, in such an event, the storm is not neutralized although the elemental still does not attack in that turn. Two elementals of the opposite type will also destroy each other before attacking, and two of the same type will join together to form a single elemental of normal strength. If there are two opposite storms and an elemental, or two opposite elementals and one or two storms, all storms and elementals cancel each other out.$pp$pp
]]

	category "Attack"

spell 'Missile' 'S-D' [[
$pp This spell creates a material object of hard substance which is hurled towards the subject of the spell and causes him 1 point of damage. The spell is thwarted by a 'shield' in addition to the  usual 'counter-spell', 'dispel magic' and 'magic mirror' (the latter  causing it to hit whoever cast it instead).$pp
]]

spell 'Finger of Death' 'P-W-P-F-S-S-S-D' [[
$pp Kills the subject stone dead. This spell is so powerful that it is unaffected by a 'counter-spell', although a 'dispel magic' spell cast upon the final gesture will stop it. The usual way to prevent being harmed by this spell is to disrupt it during casting -- using an 'anti-spell', for example.$pp
]]

spell 'Lightning Bolt' 'D-F-F-D-D or W-D-D-(c' [[
 .I or$pp The subject of this spell is hit by a bolt of lightning and sustains 5 points of damage. Resistance to heat or cold is irrelevant. There are two gesture combinations for the spell, but the shorter one may be used only once per battle by any wizard. The longer one may be used without restriction. A 'shield' spell offers no defence.$pp
]]

spell 'Cause Light Wounds' 'W-F-P' [[
$pp The subject of this spell is inflicted with 2 points of damage. Resistance to heat or cold offers no defence. A simultaneous 'cure light wounds' does not cancel the spell; it only heals one of the points of damage. A 'shield' has no effect.$pp
]]

spell 'Cause Heavy Wounds' 'W-P-F-D' [[
$pp This has the same effect as 'cause light wounds' but inflicts 3 points of damage instead of 2.$pp
]]

spell 'Fireball' 'F-S-S-D-D' [[
$pp The subject of this spell is hit by a ball of fire, and sustains 5 points of damage unless he is resistant to fire. If at the same time an 'ice storm' prevails, the subject of the 'fireball' is instead not harmed by either spell, although the storm will affect others as normal. If directed at an ice elemental, the fireball will destroy it before it can attack.$pp
]]

spell 'Fire storm' 'S-W-W-(c' [[
$pp Everything not resistant to heat sustains 5 points of damage that turn. The spell cancels wholly, causing no damage, with either an 'ice storm' or an ice elemental. It will destroy but not be destroyed by a fire elemental. Two 'fire storms' act as one.$pp
]]

spell 'Ice storm' 'W-S-S-(c' [[
$pp Everything not resistant to cold sustains 5 points of damage that turn. The spell cancels wholly, causing no damage, with either a 'fire storm' or a fire elemental; it will cancel locally with a 'fireball', sparing the subject of the 'fireball' but nobody else. It will destroy but not be destroyed by an ice elemental. Two 'ice storms' act as one.$pp$pp
]]

	category "Enchantment"

spell 'Amnesia' 'D-P-P' [[
$pp If the subject of this spell is a wizard, next turn he must repeat identically the gestures he made in the current turn,  including "nothing" and "stab" gestures. If the subject is a monster it will attack whoever it attacked this turn. If the subject is simultaneously the subject of any  of 'confusion', 'charm person', 'charm monster', 'paralysis' or 'fear' then none of the spells work.$pp
]]

spell 'Confusion' 'D-S-F' [[
$pp If the subject of this spell is a wizard, next turn one of his gestures will be changed randomly. Either his left or his right hand (50% chance of either) will perform a half-clap, palm, digit, fingers, snap, or wave  (chosen at random). (Recall that a one-handed clap is useless unless  the other hand also attempts to clap.) If the subject of the spell is a monster, it attacks at random that turn. If the subject is also the subject of any  of 'amnesia', 'charm person', 'charm monster', 'paralysis' or 'fear', none of the spells work.$pp
]]

spell 'Charm Person' 'P-S-D-F' [[
$pp Except for cancellation with other enchantments, this spell only affects wizards. When the spell is cast, the caster tells the subject which of his hands will be controlled; in the following turn, the caster chooses the gesture he wants the subject's chosen hand to perform. This could be a stab or nothing.  If the 'charm person' spell reflects from a 'magic mirror' back at its caster, the subject of the mirror assumes the role of caster and controls down his opponent's gesture. If the subject is also the subject of any  of 'amnesia', 'confusion', 'charm monster', 'paralysis' or 'fear', none of the spells work.$pp
]]

spell 'Charm Monster' 'P-S-D-D' [[
$pp Except for cancellation with other enchantments, this spell only affects monsters (but not elementals). Control of the monster is transferred to the caster of the spell (or retained by him) as of this turn; i.e., the monster will attack whosoever its new controller dictates from that turn onwards including that turn. Further charms are, of course, possible, transferring as before. If the subject of the charm is also the subject of any of: 'amnesia', 'confusion', 'charm person', 'fear' or 'paralysis', none of the spells work.$pp
]]

spell 'Paralysis' 'F-F-F' [[
$pp If the subject of the spell is a wizard, then on the turn the spell is cast, after gestures have been revealed, the caster selects one of the wizard's hands; on the next turn that hand is paralyzed into the position it is in this turn. If the wizard already had a paralyzed hand, it must be the same hand which is paralyzed again. Most gestures remain the same (including "stab" and "nothing"), but if the hand being paralyzed is performing a C, S, or W it is instead paralyzed into F, D, or P respectively. A favourite ploy is to continually paralyze a hand (F-F-F-F-F-F etc.) into a non-P gesture and then set a monster on the subject so that he has to use his other hand to protect himself, but then has no defence against other magical attacks. If the subject of the spell is a monster, it simply does not attack in the turn following the one in which the spell was cast. Elementals are unaffected. If the subject of the spell is also the subject of any of 'amnesia', 'confusion', 'charm person', 'charm monster' or 'fear', none of the spells work.$pp
]]

spell 'Fear' 'S-W-D' [[
$pp In the turn following the casting of this spell, the subject cannot perform a C, D, F or S gesture with either hand. (He can stab, however.) This obviously has no effect on monsters.  If the subject is also the subject  of 'amnesia', 'confusion', 'charm person', 'charm monster'  or 'paralysis', then none of the spells work.$pp
]]

spell 'Anti-spell' 'S-P-F' [[
$pp On the turn following the casting of this spell, the subject cannot include any gestures made on or before this turn in a spell sequence and must restart a new spell from the beginning of that spell sequence. (This is marked by a special 'disruption' icon interrupting the subject's gesture history.) The spell does not affect spells which are cast on the same turn; nor does it affect monsters.$pp
]]

spell 'Protection from Evil' 'W-W-P' [[
$pp For this turn and the following three turns, the subject of this spell is protected as if using a 'shield' spell, thus leaving both hands free. Concurrent 'shield' spells offer no further protection, and  compound 'protection from evil' spells merely overlap  offering no extra cover.$pp
]]

spell 'Resist Heat' 'W-W-F-P' [[
$pp The subject of this spell becomes permanently resistant to all forms of heat attack ('fireball', 'fire storm' and fire elementals). Only 'dispel  magic' or 'remove enchantment' will terminate this resistance once started (although a 'counter-spell' will prevent it from working if cast at the subject at the same time as this spell). A 'resist heat' cast directly on a fire elemental will destroy it before it can attack that turn, but there is no effect on ice elementals.$pp
]]

spell 'Resist Cold' 'S-S-F-P' [[
$pp The effects of this spell are identical to 'resist heat' but resistance is to cold ('ice storm' and ice elementals). It destroys ice elementals if they are the subject of the spell, but doesn't affect fire elementals.$pp
]]

spell 'Disease' 'D-S-F-F-F-(c' [[
$pp The subject of this spell immediately contracts a deadly (non-contagious) disease which will kill him at the end of 6 turns counting from the one upon which the spell is cast. The malady is cured by 'remove enchantment', 'cure heavy wounds' or 'dispel magic' in the meantime.$pp
]]

spell 'Poison' 'D-W-W-F-W-D' [[
$pp This is similar to the 'disease' spell, except that 'cure heavy wounds' does not stop its effects.$pp
]]

spell 'Blindness' 'D-W-F-F-(d' [[
$pp For the next three turns (not including the one in which the spell was cast), the subject is unable to see. If he is a wizard, he cannot tell what his opponent's gestures are, although he will sense what spells are cast. If he tries to cast spells (or stab) at other beings, he will miss. Blinded  monsters are instantly destroyed and cannot attack in that turn.$pp
]]

spell 'Invisibility' 'P-P-(w-(s' [[
$pp This spell is similar to 'blindness'; the subject of the spell becomes invisible to his opponent and his monsters. His gestures cannot be seen, although his spells can. No other being can attack or cast spells at him, with the exception of elementals. Any monster made invisible is destroyed due to the unstable nature of such magically created creatures.$pp
]]

spell 'Haste' 'P-W-P-W-W-(c' [[
$pp For the next three turns, the subject is speeded up; wizards can make an extra set of gestures, and monsters can make an extra attack. For wizards, the effects of both sets of gestures are taken simultaneously at the end of the turn.  Thus a single 'counter-spell' from his adversary could cancel two spells cast by the hastened wizard on two half-turns if the phasing is right. Non-hastened wizards and monsters can see everything the hastened individual is doing.  Hastened monsters can change target in the extra turns if desired.$pp
]]

spell 'Time stop' 'S-P-P-(c' [[
$pp The subject of this spell immediately takes an extra turn, on which no-one can see or know about unless they are harmed. All non-affected beings have no resistance to any form of attack, e.g. a wizard halfway through the duration of a 'protection from evil' spell can be harmed by a monster which has had its time stopped. Time-stopped monsters attack whoever their controller instructs, and time-stopped elementals affect everyone, resistance to heat or cold being immaterial in that turn.$pp
]]

spell 'Delayed effect' 'D-W-S-S-S-P' [[
$pp This spell must be cast upon a wizard. The next spell the subject completes, provided it is in one of the next three turns, is "banked" until needed -- i.e. it fails to work until its caster desires. (If you have a spell banked, you will be asked each turn if you want to release it.) Note that spells banked are those cast  .I by  the subject, not those cast  .I at  him. If he casts more than one spell at the same time, he chooses which is to be banked. Remember that P is a 'shield' spell, and surrender is not a spell. A wizard may only have one spell banked at any one time.$pp
]]

spell 'Permanency' 'S-P-F-P-S-D-W' [[
$pp This spell must be upon a wizard. The next spell he completes, provided it is in the next three turns, and which falls into the category of "Enchantments" will have its effect made permanent.  (Exeptions: 'anti-spell', 'disease', 'poison', 'time-stop', 'delayed effect', and 'permanency' cannot be made permanent. Note that 'resist heat' and 'resist cold' are inherently permanent enchantments.)  This means that the effect of the extended spell on the first turn of its duration is repeated eternally. For example,  a 'confusion' spell will produce the same gesture on the same hand  rather than changing randomly each turn; a 'charm person' will  mean repetition of the chosen gesture, etc. If the subject of the 'permanency' casts more than one spell at the same time eligible for permanency, he chooses which has its duration extended. Note that the person who has his spell made permanent does not necessarily have to make himself the subject of the spell. If both a 'permanency' and 'delayed effect' are eligible for  the same spell to be banked or extended, a choice must be made;  whichever is not chosen will affect the next eligible spell instead.$pp$pp
]]

	category "Non-spells"

spell 'Surrender' '(p' [[
$pp This is not a spell; consequently, it cannot be cast at anyone, nor can it be dispelled, counter-spelled, reflected off a mirror, or banked. A wizard who makes two simultaneous P gestures,  irrespective of whether they terminate spells or not, surrenders and the contest is over. The surrendering wizard is deemed to have lost unless his gestures complete spells which kill his opponent. Two simultaneous surrenders count as a draw. It is a necessary skill for wizards to work their spells so that they never accidentally perform two P gestures simultaneously.  Wizards can be killed as they surrender (if hit with appropriate spells or attacks) but the "referees" will cure any diseases, poisons, etc. immediately after the surrender for them.$pp
]]

spell 'Stab' 'stab' [[
$pp This is not a spell, but an attack which can be directed at any individual
       monster  or wizard. Unless protected in that turn by a 'shield'
       spell or another spell with the same effect, the target stabbed suffers
       1 point of damage. The wizard only has one knife, so can only stab with
       one hand in any turn, although which hand doesn't matter. The stab can-
       not be reflected, counter-spelled, dispelled, or banked.
]]

return spellbook

