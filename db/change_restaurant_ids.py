#We had an off by 1 error for restaurant Ids
#This file would be useful if the seed file needed updating for new restaurants

def main():
  with open("final_seeds_5.yml") as f:
    with open("final_seeds_6.yml", 'w') as f2:
      content = f.readlines()
      for line in content:
        if("restaurant_id:" in line):
          restaurant_id = int(line[(line.find(":") + 1):]) - 1
          f2.write("    restaurant_id: " + str(restaurant_id) + "\n")
        else:
          f2.write(line)




if (__name__ == '__main__'):
  main()