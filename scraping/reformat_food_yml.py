#reformat food_yml.txt
#just edits to the yml file

def main():
  with open("food_yml.txt") as f:
    with open("food_yml_edited.txt", 'w') as f2:
      content = f.readlines()
      for line in content:
        if 'dish_name' in line or 'description' in line:
          quote_start = line.find("\"") + 1
          quote_end = line.rfind("\"")
          string = line[quote_start:quote_end]
          string = string.replace("\"", "\'")
          line = line[:quote_start] + string + line[quote_end:]
        f2.write(line)


if (__name__ == '__main__'):
  main()