# Catacombs — Story

## The World Above

The kingdom of **Vaelmoor** once stood proud on the edge of a great plain. Its crown jewel was not its walls or its markets, but what lay beneath them: the **Catacombs of the First Kings** — a sacred burial network carved into living stone, lit by eternal flame and guarded by oath-bound wardens.

For centuries, the dead rested in peace. Then the **Ash Plague** came.

It started in the lower districts. Fevers. Black veins. Voices in sleep that did not belong to the dreamer. The royal healers could not stop it. The priests could not sanctify it away. Within a season, half of Vaelmoor was empty.

In desperation, the last queen — **Serene the Pale** — ordered the catacombs sealed. Every entrance bricked shut. Every priest who had descended to pray for the dead trapped inside with them. The plague, they hoped, would starve in the dark.

It did not.

The plague sank deeper instead, into bone and memory and old magic the First Kings had buried with their crowns. What rose in its place was worse than sickness: **the Unquiet** — skeletons stirred from their niches, goblins driven mad from the sewers, golems of funeral stone that forgot whom they were meant to protect.

Vaelmoor became a ghost of itself. The survivors speak of the catacombs the way children speak of the sea — vast, hungry, and full of things that should not be alive.

---

## You

You are a **grave-delver** — one of the few who still dare the tunnels.

No one knows your name down here. The merchants at the surface call you *the Lantern*. You carry no banner and serve no lord. You descend because someone must: to recover relics worth selling, to map routes the scavengers can use, and because somewhere in the deepest halls there are answers about where the plague truly began.

You are not a hero. You are a person with a sword, a satchel, and enough stubbornness to walk into a tomb that an entire kingdom condemned.

Your only comforts are torchlight, the weight of good steel, and the **ward-stones** — ancient save points where the First Kings' magic still holds the darkness at bay long enough for you to catch your breath.

---

## The End Goal — The Rite of Closing

Deep beneath the last vault, older than Vaelmoor, older than the First Kings, lies the **Sanctum of the Threshold** — a chamber the priesthood called *the door that opens inward*.

At its center stands the **Sacrifice Altar**.

The altar is not evil. It is ** hungry for completion**. When the catacombs were first consecrated, the First Kings placed three relics upon it — one of memory, one of mercy, one of truth — and spoke an oath that bound the dead to rest. Serene's sealing broke that oath. She walled the doors but never finished the rite. The Unquiet are the cost of an interrupted prayer.

To end the plague's cycle — to still the dead, to seal the depths properly, and to walk back to the surface knowing Vaelmoor might live again — you must:

1. Descend through all three acts of the catacombs.
2. Recover the **Three Relics of the Threshold**.
3. Place them on the Sacrifice Altar and choose what you are willing to give up to finish what Serene could not.

The relics are not sitting in chests marked with arrows. They are hidden, guarded, split across floors, and sometimes carried by things that do not know what they hold. **Quests** — scraps of journals, dying delvers' notes, priestly riddles — are the thread that leads you to each one.

Without the quests, you might still stumble upon a relic by luck. With them, you will know *why* it matters.

---

## The Three Relics

| Relic | Meaning | Where it hides | Quest that reveals it |
|-------|---------|----------------|----------------------|
| **The Mnemonic Crown** | Memory — the dead must be *remembered* to rest | Act I, deep sanctum | *The Warden's Ledger* |
| **The Merciful Ash** | Mercy — the plague must be * forgiven* to end | Act II, plague pit | *The Last Confession* |
| **The Pale Seal** | Truth — the lie must be * spoken* to break | Act III, queen's vault | *Serene's Letter* |

Each relic occupies an inventory slot and cannot be dropped until placed on the altar or lost through death (respawn returns you to the last ward-stone, but **relics stay lost until re-found** — making the final descent tense).

---

## Act I — The Broken Threshold
*Theme: Holy places defiled. Learning that the dead were once protected.*

The upper catacombs still look like a temple. Mosaics, reliquaries, ward-stones. This is where new delvers learn the rules: fight, loot, save, descend.

### Levels (4)

| Level | Name | Implemented | Notes |
|-------|------|-------------|-------|
| **1** | The Entry Crypt | Yes (`level1`) | Tutorial tone — slimes, mushrooms, first loot |
| **2** | Warden's Walk | Yes (`level2`) | Skeleton patrols, first save point, floor traps |
| **3** | The Reliquary Ring | Yes (`level3`) | Goblins, golems, deeper equipment |
| **4** | Hall of the First Oath | *Planned* | Boss-adjacent sanctum; **Mnemonic Crown** hidden behind a sealed niche |

### Quests

**Side — "Spoils of the Dead"**  
A surface merchant pays for any equipment from the upper halls. Teaches looting and inventory. No relic clue.

**Side — "Light the Dark"**  
Find and pass three torch-lit junctions without dying. Rewards a healing potion bundle. Introduces navigation.

**Main — "The Warden's Ledger"**  
In Level 2, a bookshelf holds a crumbling duty roster. Reading it mentions a crown "removed from the reliquary ring for safekeeping" and hidden "where the wardens swore their first oath."  
→ Points to Level 4, Hall of the First Oath.  
→ Completing the level and examining the oath-stone niche yields **The Mnemonic Crown**.

### Act I ends when
You descend past the reliquary ring with the Mnemonic Crown (or without it — the door forward opens either way, but the altar will remain incomplete until you return).

---

## Act II — The Scavenger Warrens
*Theme: Survival and moral gray. The catacombs are a library of forbidden solutions.*

Holy geometry gives way to service tunnels, sewers, and goblin camps. Combat is dirtier. Skill books appear. The plague's touch is visible — black veins in the stone, spores in the air.

### Levels (4)

| Level | Name | Implemented | Notes |
|-------|------|-------------|-------|
| **5** | The Sewer Mouth | *Planned* | Goblin-heavy; narrow corridors |
| **6** | Plague Warren | *Planned* | Slimes, mushrooms, environmental hazards |
| **7** | The Confessor's Cell | *Planned* | Bookshelves, skill tomes, journal fragments |
| **8** | Pit of Merciful Ash | *Planned* | **The Merciful Ash** kept in a reliquary jar at the pit's bottom |

### Quests

**Side — "Goblin Ledger"**  
A goblin camp holds a stolen delver's map. Return it to a marked cache for random equipment. Flavor: even scavengers keep records.

**Side — "Disarm or Die"**  
A note near floor traps: *"Step when the spikes sleep."* Survive three trap rooms without ward-stone healing. Rewards a defense potion.

**Main — "The Last Confession"**  
In Level 7, a priest's skeleton clutches a blood-stained confession. He writes that he carried "the Ash of those we failed to save" into the warren so it would not infect the upper dead — and hid it where *"only the merciful would kneel."*  
→ Points to Level 8, Pit of Merciful Ash.  
→ Kneeling at the pit's reliquary (interact at save point-style marker) yields **The Merciful Ash**.

### Act II ends when
You enter the smooth-stone transition into the Deep Vaults — the architecture shifts; torches stop flickering.

---

## Act III — The King's Sleep
*Theme: Ancient power, royal guilt, and the price of truth.*

The lowest halls predate Vaelmoor. Golems stand eternal. Equipment here is no longer scavenged junk. The silence has weight.

### Levels (5)

| Level | Name | Implemented | Notes |
|-------|------|-------------|-------|
| **9** | Deep Vault Antechamber | *Planned* | Golem patrols, crimson-tier loot |
| **10** | The Golem Foundry | *Planned* | Heavy combat; golem tears as alchemy hint |
| **11** | Serene's Blockade | *Planned* | Royal masonry, sealed doors, journal scraps |
| **12** | The Pale Vault | *Planned* | **The Pale Seal** — Serene's signet, cracked but intact |
| **13** | Sanctum of the Threshold | *Planned* | **Sacrifice Altar** — final room |

### Quests

**Side — "Tears of Stone"**  
Collect a golem tear (defense potion item) and use it at a cracked statue in Level 10. The statue whispers a name from Act I — ties acts together.

**Side — "The Crimson Heresy"**  
Find the crimson axe's inscription (equipment description in-world). A hidden alcove in Level 11 opens — bonus accessory, not a relic.

**Main — "Serene's Letter"**  
In Level 11, behind partial royal masonry, a letter from Serene the Pale: *"I sealed the dead but could not speak the truth. My seal is in the vault where I never walked. Find it. Finish it. Forgive me."*  
→ Points to Level 12, The Pale Vault.  
→ The seal rests on an empty throne. Taking it yields **The Pale Seal**.

### Act III ends when
You place all three relics on the Sacrifice Altar in Level 13 and complete the **Rite of Closing**.

---

## The Final Level — Sanctum of the Threshold

Level 13 is short and solemn. No random combat — only the altar, ward-stones, and the weight of what you carry.

### The Sacrifice Altar

Three depressions in the stone match the three relics. When all are placed:

1. **The Mnemonic Crown** — the wardens' names echo through the chamber. The Unquiet remember they were guardians.
2. **The Merciful Ash** — the plague-smoke thins. The air becomes breathable for the first time since the sealing.
3. **The Pale Seal** — Serene's lie unravels: the plague did not start in the catacombs. It was *buried* there by the surface to hide a royal sin.

The altar then asks for **a sacrifice** — not necessarily your life (that is the hidden *Suicide* skill's domain), but something the player has accumulated:

- A portion of max health, **or**
- All learned skills except one, **or**
- Every piece of equipment currently worn

Design intent: the ending should feel *costly*, not free. The choice can branch epilogues (implementation TBD).

### Endings (draft)

| Sacrifice | Epilogue |
|-----------|----------|
| **Health** | You seal the catacombs and crawl out wounded. Vaelmoor survives weakened. You are remembered as the Lantern who limped home. |
| **Skills** | You forget most of what the depths taught you, but the dead stay quiet. You live simply on the surface. |
| **Equipment** | You walk out with nothing but clothes and the truth. Merchants call you a fool. The kingdom calls you a savior. |

All endings share one line: *The catacombs are closed. For now.*

---

## Quest Summary Table

| Act | Main Quest | Relic rewarded | Side quests |
|-----|------------|----------------|-------------|
| **I** | The Warden's Ledger | Mnemonic Crown | Spoils of the Dead, Light the Dark |
| **II** | The Last Confession | Merciful Ash | Goblin Ledger, Disarm or Die |
| **III** | Serene's Letter | Pale Seal | Tears of Stone, The Crimson Heresy |

---

## Lore — The Unquiet

| Enemy | What They Were | What They Are Now |
|-------|----------------|-------------------|
| **Slime** | Alchemical runoff from plague pits | Mindless hunger that blocks the narrow ways |
| **Mushroom** | Spores grown on buried dead | Stationary killers; the warrens' rot made flesh |
| **Skeleton** | Catacomb wardens, oath-bound in life | Patrol routes they no longer understand |
| **Skull** | Priests who burned themselves to contain the plague | Flaming remnants that attack the living |
| **Goblin** | Sewer-dwellers trapped during the sealing | Desperate scavengers who believe the depths owe them |
| **Golem** | Funeral guardians carved for the First Kings | Stone soldiers with no king left to serve |

---

## Lore — Items & Skills (world flavor)

| Item / Skill | Story |
|--------------|-------|
| **Snake blood (damage potion)** | Hunters bottled viper venom to coat blades. Delvers drink it and call it courage. |
| **Tears of a golem (defense potion)** | Condensed from shattered guardians. Bitter, mineral, strangely calming. |
| **Crimson axe** | Relic of **Thalaen**, a goddess Serene banned. The axe did not forget. Quest *The Crimson Heresy* ties to it. |
| **Golden ring / Silver ring** | Fragments of the First Kings' seven signets — not the Threshold relics, but echoes of the same magic. |
| **FireBall & Heal** | Heretical priestcraft. Destruction and mending — both needed, both dangerous. |
| **Suicide** | The deepest delvers know: some doors only open from the inside, once. The altar understands this language. |

---

## Level Map (full game)

```
ACT I — The Broken Threshold
  1  Entry Crypt          [built]
  2  Warden's Walk       [built]
  3  Reliquary Ring      [built]
  4  Hall of the First Oath

ACT II — The Scavenger Warrens
  5  Sewer Mouth
  6  Plague Warren
  7  Confessor's Cell
  8  Pit of Merciful Ash

ACT III — The King's Sleep
  9  Deep Vault Antechamber
 10  Golem Foundry
 11  Serene's Blockade
 12  Pale Vault
 13  Sanctum of the Threshold  ← Sacrifice Altar
```

**Total: 13 levels** (3 playable today, 10 to build)

---

## Implementation Notes

This document is the narrative backbone for Catacombs. When building new levels:

- Each act should introduce harder enemies and better loot tiers.
- Main quests can be delivered via **bookshelf journals**, **notes on save points**, or **NPC echoes** (future).
- Relics are unique quest items (`flag: 2` or dedicated `type: "relic"`) — not sold, not consumable.
- Level 13's altar is an interactable scene (`sacrifice_altar.tscn`) that checks `player_relics.size() == 3`.
- Current `level1`–`level3` map to Act I levels 1–3; Act I level 4 gates descent into Act II.

---

*The door at the bottom does not lead to treasure. It leads to the question Serene refused to answer — and the price of answering it yourself.*
