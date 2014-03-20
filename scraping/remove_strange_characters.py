#getting rid of strange characters...
#There was an annoying bug converting strings-unicode-utf8...
#Eventually fixed using sublime --> File --> Reopen with Encoding 
#(Instead of programmatically)

def main():
  with open("../db/new_seeds_file_2.yml") as f:
    content = f.readlines()
    for line in content:
      if("description" in line):
        start_index = line.find("\"")
        end_index = line.rfind("\"")
        description = line[start_index+1:end_index]
        if("Our smooth and creamy" in line):
          print description
          #test_str = str(description)
          #print test_str
          utf_8 = description.decode('utf-8', 'ignore')

          print utf_8
          raw_input("")




if __name__ == "__main__":
  main()
