#go down from 5 ratings per food item to just 2
#with 5 ratings per item, the seeding was taking so long

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


if (__name__ == '__main__'):
  main()