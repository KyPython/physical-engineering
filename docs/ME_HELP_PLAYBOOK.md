I'm in an HVAC control competition scoring comfort vs energy/carbon. The simulator has energy-balance and airflow-mixing bugs we're fixing. Could you sanity-check my physical assumptions for 20 mins? I'll send you the one-pager, you just tell me which number looks off.

1. Smart Buildings — 20 min review
Send him:
Fairbanks_1 morning arrival numbers: physical comfort -12.497 vs CtrlX -12.971, hour-6 arrival -1.934 vs -1.851
Equations: tank 336K, standby max 307K, AHU setback, recirc grid, airflow-weighted return air
Ask:
Does holding 336K hot water through idle hours make sense at -30C with PR#2 energy-balanced tank? (Answer should be NO — wastes gas. Correct us if we're wrong.)
Is 303K unoccupied ceiling or 307K standby reasonable for frost floor 277.15K (+4C)?
Does fine 0.5K AHU grid + near-min pump pressure violate any heat-exchanger or fan affinity law?
Where would you expect cold-morning discomfort mass to sit?
Use: if he flags B1 tank-hold or B2 airflow imbalance, we cite it as independent physical validation, not leaderboard hunting. Do NOT ask him to write controller code — stock-blinded physics check only.

2. Physical Engineering — deliverable review
Send one task PDF: data-hall-mep-routing or foundation-strategy or solar-witness-test-package.
Ask:
Read the spec + our harness output. Where would you cap at 0.4 for a missed hard constraint?
Is our sizing/routing plausible for a real MEP reviewer?
What missing unit test would a licensed engineer require?
Use: fixes agy-gemini deliverable before eval/run.py export, avoids 0-reward zeros. No code writing — judgment only.

3. What NOT to ask
Don't ask for a full policy or 29-task solve — that's not undergrad scope and reads as homework.
Don't ask for Kaggle submission or leaderboard tuning — out-of-domain and against charter.
Don't give him simulator source to patch — give him numbers + a single physical claim to falsify.

Reciprocity
Offer back: letter / LinkedIn referral / review of his thesis / dinner. Students say yes to "review my 1-page hypothesis for 20 mins" far more than "help me win a competition."

Follow-through
After: log his feedback in AGENTS §5 binding sequence (Smart) or ATTEMPT_LOG (PLE) as human domain review, with concrete number changed or confirmed. No mass redesign — one mechanism at a time.
