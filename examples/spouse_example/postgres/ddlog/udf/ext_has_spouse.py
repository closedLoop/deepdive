#! /usr/bin/env python

import csv
import os
import sys
from collections import defaultdict

APP_HOME = os.environ['APP_HOME']

# Load the spouse dictionary for distant supervision
spouses = defaultdict(lambda: None)
with open (APP_HOME + "/input/spouses.csv") as csvfile:
  reader = csv.reader(csvfile)
  for line in reader:
    spouses[line[0].strip().lower()] = line[1].strip().lower()

# Load relations of people that are not spouse
non_spouses = set()
lines = open(APP_HOME + '/input/non-spouses.tsv').readlines()
for line in lines:
  name1, name2, relation = line.strip().split('\t')
  non_spouses.add((name1, name2))  # Add a non-spouse relation pair

# For each input tuple
for row in sys.stdin:
  parts = row.strip().split('\t')
  if len(parts) != 5:
    print >>sys.stderr, 'Failed to parse row:', row
    continue

  sentence_id, p1_id, p1_text, p2_id, p2_text = parts

  p1_text = p1_text.strip()
  p2_text = p2_text.strip()
  p1_text_lower = p1_text.lower()
  p2_text_lower = p2_text.lower()

  # See if the combination of people is in our supervision dictionary
  # If so, set is_correct to true or false
  is_true = '\N'
  if spouses[p1_text_lower] == p2_text_lower:
    is_true = '1'
  if spouses[p2_text_lower] == p1_text_lower:
    is_true = '1'
  elif (p1_text == p2_text) or (p1_text in p2_text) or (p2_text in p1_text):
    is_true = '0'
  elif (p1_text_lower, p2_text_lower) in non_spouses:
    is_true = '0'
  elif (p2_text_lower, p1_text_lower) in non_spouses:
    is_true = '0'

  print '\t'.join([
    p1_id, p2_id, sentence_id,
    "%s-%s" %(p1_text, p2_text),
    "%s-%s" %(p1_id, p2_id),
    is_true
    ])
  # Output lines should conform to:
  #   has_spouse_candidates(
  #     person1_id  text,
  #     person2_id  text,
  #     sentence_id text,
  #     description text,
  #     relation_id text,
  #     is_true boolean).

