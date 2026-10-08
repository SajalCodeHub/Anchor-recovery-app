-- Starter content for the panic button. Edit freely; the team can add more.
-- The 'crisis' rows are US resources; revisit if the app targets other regions.

insert into public.motivational_messages (category, body) values
  ('motivation', 'This urge is a wave. It rises, peaks, and passes, usually within 15 to 30 minutes. You only have to get through the next few minutes.'),
  ('motivation', 'Every day you have already gotten through is real. This moment does not erase them.'),
  ('motivation', 'You do not have to win forever. Just get through the next hour.'),
  ('grounding', 'Name 5 things you can see, 4 you can touch, 3 you can hear, 2 you can smell, and 1 you can taste.'),
  ('grounding', 'Breathe in for 4 counts, hold for 4, out for 6. Repeat five times.'),
  ('grounding', 'Change your setting: stand up, drink some water, and step outside or into another room.'),
  ('crisis', 'If you are in the US and in crisis or thinking about harming yourself, call or text 988 (Suicide & Crisis Lifeline) right now.'),
  ('crisis', 'For substance use support in the US, the SAMHSA National Helpline is free and open 24/7: 1-800-662-4357.')
on conflict do nothing;
