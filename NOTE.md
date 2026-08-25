# Catacombs — Dev Notes

Full narrative design: [STORY.md](STORY.md)

---

## Current Status

**Playable today:** Act I levels 1–3 (Entry Crypt → Warden's Walk → Reliquary Ring)

| System | Status |
|--------|--------|
| Player movement, camera, torch lighting | Done |
| Level transitions (door / spawn markers) | Done |
| Turn-based combat (attack, guard, skills, items) | Done |
| Inventory & equipment (weapon, shield, head, body, accessory) | Done |
| Consumables in combat (heal, attack, defense, agility, luck) | Done |
| Looting (barrels, chests, bookshelves) | Done |
| Save points / respawn | Done |
| Enemies: slime, mushroom, skeleton, skull, goblin, golem | Done |
| Quest system | Not started |
| Relics | Not started |
| Sacrifice altar / endings | Not started |
| Levels 4–13 | Not started |

**End goal (from story):** Collect three relics → place them on the Sacrifice Altar in Level 13 → complete the **Rite of Closing** → choose a sacrifice → epilogue.

---

## Roadmap

### Phase 0 — Foundation *(mostly complete)*
Core loop: explore → fight → loot → save → descend.

- [x] Player, camera, lighting
- [x] Combat menu & inventory
- [x] Level loading & transitions
- [x] Loot containers & skill books
- [x] Save / respawn
- [x] Enemy variety (6 types)
- [ ] Combat polish (crit bug, attack/defense potions out of combat, Steal skill)
- [ ] HUD quest tracker placeholder

---

### Phase 1 — Act I: The Broken Threshold
*4 levels · theme: holy places defiled*

| Level | Scene | Status |
|-------|-------|--------|
| 1 — Entry Crypt | `level1.tscn` | Built |
| 2 — Warden's Walk | `level2.tscn` | Built |
| 3 — Reliquary Ring | `level3.tscn` | Built |
| 4 — Hall of the First Oath | `level4.tscn` | Planned |

**Main quest — The Warden's Ledger**
- [ ] Quest journal / log UI
- [ ] Readable journal on bookshelf in Level 2 (clue text)
- [ ] Level 4 layout + oath-stone interactable
- [ ] **Mnemonic Crown** relic item (`type: relic`, undroppable)
- [ ] Act I → Act II door (Level 4 → Level 5)

**Side quests**
- [ ] *Spoils of the Dead* — turn-in counter or simple flag reward
- [ ] *Light the Dark* — pass 3 torch junctions without dying

**Act I complete when:** Player can reach Level 5; crown obtainable via quest (optional but required for true ending).

---

### Phase 2 — Act II: The Scavenger Warrens
*4 levels · theme: survival, moral gray, plague visible in the stone*

| Level | Scene | Status |
|-------|-------|--------|
| 5 — Sewer Mouth | `level5.tscn` | Planned |
| 6 — Plague Warren | `level6.tscn` | Planned |
| 7 — Confessor's Cell | `level7.tscn` | Planned |
| 8 — Pit of Merciful Ash | `level8.tscn` | Planned |

**Main quest — The Last Confession**
- [ ] Priest skeleton / journal interactable in Level 7
- [ ] Level 8 pit + kneel interactable at reliquary
- [ ] **Merciful Ash** relic item

**Side quests**
- [ ] *Goblin Ledger* — map pickup → cache reward
- [ ] *Disarm or Die* — survive 3 trap rooms without save heal

**Act II complete when:** Player enters Deep Vault architecture (Level 9 transition).

---

### Phase 3 — Act III: The King's Sleep
*5 levels · theme: ancient power, royal guilt*

| Level | Scene | Status |
|-------|-------|--------|
| 9 — Deep Vault Antechamber | `level9.tscn` | Planned |
| 10 — Golem Foundry | `level10.tscn` | Planned |
| 11 — Serene's Blockade | `level11.tscn` | Planned |
| 12 — Pale Vault | `level12.tscn` | Planned |
| 13 — Sanctum of the Threshold | `level13.tscn` | Planned |

**Main quest — Serene's Letter**
- [ ] Letter interactable behind royal masonry (Level 11)
- [ ] Empty throne + **Pale Seal** in Level 12

**Side quests**
- [ ] *Tears of Stone* — golem tear used on cracked statue (Level 10)
- [ ] *The Crimson Heresy* — crimson axe triggers hidden alcove (Level 11)

**Act III complete when:** Player reaches Level 13 with 0–3 relics in inventory.

---

### Phase 4 — Finale: Rite of Closing
*Level 13 only · no combat*

- [ ] `sacrifice_altar.tscn` — three relic slots, interact to place
- [ ] Check `player_relics.size() == 3` before rite begins
- [ ] Sacrifice choice UI (health / skills / equipment)
- [ ] Three epilogue screens + shared closing line
- [ ] Relic loss on death until re-collected (tension on final run)

---

## Work Plan (suggested order)

Do these in sequence so each step builds on the last.

### Sprint A — Quest foundation
1. Add `quests` dict + `active_quests` / `completed_quests` to `main.gd`
2. Add journal item type (`type: journal`) — reading sets quest flags
3. Simple quest log in HUD or pause menu (title + one-line objective)
4. Wire *The Warden's Ledger* text into Level 2 bookshelf

### Sprint B — Finish Act I
5. Build `level4.tscn` (Hall of the First Oath)
6. Add relic item template + **Mnemonic Crown** to loot/quest reward
7. Connect Level 3 → Level 4 → Level 5 doors
8. Implement side quests *Spoils of the Dead* and *Light the Dark*

### Sprint C — Act II content
9. Build levels 5–8 (reuse tileset, escalate enemy density)
10. *The Last Confession* journal + **Merciful Ash** kneel interactable
11. Side quests *Goblin Ledger* and *Disarm or Die*

### Sprint D — Act III content
12. Build levels 9–12 (golem-heavy, royal masonry decor)
13. *Serene's Letter* + **Pale Seal** on throne
14. Side quests *Tears of Stone* and *The Crimson Heresy*

### Sprint E — Finale
15. Build `level13.tscn` (Sanctum — altar, ward-stone, no enemies)
16. Sacrifice altar logic + ending branches
17. Playtest full 13-level run with all three relics

---

## Level Map

```
ACT I — The Broken Threshold          [ 3/4 built ]
  1  Entry Crypt           level1.tscn   ✓
  2  Warden's Walk         level2.tscn   ✓
  3  Reliquary Ring        level3.tscn   ✓
  4  Hall of the First Oath             → Mnemonic Crown

ACT II — The Scavenger Warrens        [ 0/4 built ]
  5  Sewer Mouth
  6  Plague Warren
  7  Confessor's Cell                   → quest clue
  8  Pit of Merciful Ash                → Merciful Ash

ACT III — The King's Sleep            [ 0/5 built ]
  9  Deep Vault Antechamber
 10  Golem Foundry
 11  Serene's Blockade                  → quest clue
 12  Pale Vault                         → Pale Seal
 13  Sanctum of the Threshold           → Sacrifice Altar ★ END
```

---

## Relic Checklist

| Relic | Quest | Level | Implemented |
|-------|-------|-------|-------------|
| Mnemonic Crown | The Warden's Ledger | 4 | No |
| Merciful Ash | The Last Confession | 8 | No |
| Pale Seal | Serene's Letter | 12 | No |

---

## Changelog

### 22.08
- Expanded enemy roster (slime, mushroom, skull)
- Added equipment & consumables (steel mace, tower shield, luck potion, etc.)
- Story & end goal written in STORY.md
- Roadmap added to this file

### 05.05
- Added a save point

### 04.05
- Added a looting system
  - Barrels store potions (healing, damage, defense, agility, luck)
  - Chests store equipment (weapon, shield, head, body, accessory)
  - Two-handed weapons block shield use
  - Bookshelves store skill books; reading unlocks combat skills

### 28.04
- Added new enemies (goblin, golem)
- Modified combat: skills (talk, run, steal, escape plan)
- Added items inventory
- Implemented healing mechanics

![Screenshot](GIF/28.04.png)

### 27.04
- Added a combat scene

![Screenshot](GIF/27.04.png)

### 26.04
- Added simple inventory

![Screenshot](GIF/26.04.png)

### 22.04
- Fixed floor traps "fast killing"
- Added enemy "skeleton" with patrolling, chasing, and combat trigger

### 24.03
- Added floor traps — animation and damage when spikes extend

### 21.03
- Added basic health bar UI and `take_damage`
- Moved Camera2D to Main scene (persists across level loads)
- Fixed player diagonal slide (single-axis movement)
- Modified collision in level3

### 19.03
- Fixed torch sound, added fade effect
- Responsive main menu and pause menu
- Game background music

# Catacombs v0.1.1 — 17.03

### Player & Movement
- 4-directional movement and idle animations

### Camera & Lighting
- Camera follow system
- PointLight on player
- Torch: animation, light, sound

### Systems
- Level transition logic

### DEMO
![Demo](GIF/17.03-demo.gif)
