#This is used to update the final_seeds.yml file
#We need to change half of the "1" ratings to 5
#and add Users 1-1000

#**Should not need to be run anymore**

import random

first_names = ["Mike", "David", "Kevin", "Chris", "Brian", "Melissa", "Sarah", "Rebecca", "Victoria", "Elizabeth"]
last_names = ["Smith", "Johnson", "Williams", "Jones", "Wilson", "Moore", "Martin", "Brown", "White", "Clark"]
middle_initials = ["A.", "B.", "C.", "D.", "E.", "F.", "G.", "H.", "I.", "J."]



def getFirstNames():
  names = []  
  for first_name in first_names:
    for middle_initial in middle_initials:
        names.append(first_name + " " + middle_initial)
  return names

def main():
  with open("final_seeds.yml") as f:
    with open("final_seeds_2.yml", 'w') as f2:
      content = f.readlines()
      user_id_counter = 1
      for line in content:
        if("user_id:" in line):
          new_line = "    user_id: " + str(user_id_counter % 1001) + "\n"
          f2.write(new_line)
          user_id_counter += 1
        elif("users:" in line):
           f2.write(line)
           counter = 10001
           for first_name in getFirstNames():
             for last_name in last_names:
                f2.write("  -\n")
                f2.write("    first_name: '" + first_name + "'\n")
                f2.write("    last_name: '" + last_name + "'\n")
                f2.write("    fb_id: " + str(counter) + "\n")
                f2.write("    rating_score: 3\n")
                counter += 1
        elif("score: 1" in line):
        # #delete if it has 3 or 4
        # #if it has a 1, convert to 3 or 4 with p=1/3 each
        # #if it has a 2, convert to 5 with p=1/2

        #   if(random.random() < .5):
        #     f2.write(line)
        #   else:
        #     f2.write("    score: 5\n")
        else:
          f2.write(line)




if (__name__ == '__main__'):
  main()