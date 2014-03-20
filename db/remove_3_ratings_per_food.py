#go down from 5 ratings per food item to just 2


def main():
  with open("final_seeds_3.yml") as f:
    with open("final_seeds_4.yml", 'w') as f2:
      content = f.readlines()
      startSkipLines = False
      num_skipped_ratings = 28
      for line in content:
        if("ratings:" in line and "num_ratings" not in line):
          startSkipLines = True

        if("pictures:" in line):
          startSkipLines = False

        if(startSkipLines == True):
          num_skipped_ratings += 1
          if(num_skipped_ratings % 30 >= 18):
            f2.write(line)

        else:
          f2.write(line)

  #ratings:
  # - 
  #   ratable_id: 1
  #   ratable_type: Food
  #   score: 2
  #   comment: You should try this for yourself...
  #   user_id: 1
  # -
  #   ratable_id: 1
  #   ratable_type: Food
  #   score: 3
  #   comment: What did they put in this?
  #   user_id: 2
  # -
  #   ratable_id: 1
  #   ratable_type: Food
  #   score: 2
  #   comment: I can't tell if I like it or not...
  #   user_id: 3
  # -
  #   ratable_id: 1
  #   ratable_type: Food
  #   score: 5
  #   comment: Do you like food? Then come here
  #   user_id: 4
  # -
  #   ratable_id: 1
  #   ratable_type: Food
  #   score: 4
  #   comment: Heaven? Or Hell? Try to know
  #   user_id: 5
  # -
  #   ratable_id: 2
  #   ratable_type: Food
  #   score: 4
  #   comment: You should try this for yourself...
  #   user_id: 6
  # -


if (__name__ == '__main__'):
  main()