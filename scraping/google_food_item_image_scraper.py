#This is for scraping food items
import sys
import boto
import boto.s3
import os
import urllib
import urllib2
import json as simplejson
from bs4 import BeautifulSoup
from boto.s3.key import Key
import StringIO

#will store them in amazon S3
AWS_ACCESS_KEY_ID = "AKIAJMDX3OBKTVRXAHJA"
AWS_SECRET_ACCESS_KEY = "7YUCZBrSrXOANaXzkt17J***" #sorry, private

last_image = 9000

def main():
  boto.config.add_section('Boto') 
  boto.config.set('Boto','http_socket_timeout','3') 

  dish_names = getDishNames()
  counter = 0
  start_scraping = False
  for dish in dish_names:
      counter += 1
      #print restaurant
      if(counter == last_image):
        start_scraping = True
      if(start_scraping):
        print counter
        url_dish = urllib.quote_plus(dish)
        url = 'https://ajax.googleapis.com/ajax/services/search/images?v=1.0&q=' + url_dish + '&imgtype=photo'
        request = urllib2.Request(url, None, {'Referer': 'http://www.my-ajax-site.com' })
        response = urllib2.urlopen(request)
        # Process the JSON string.
        results = simplejson.load(response)
        if(results != None):
          if(results["responseData"] != None):
            for index, item in enumerate(results["responseData"]["results"]):
              picture_url = item["url"]
              print picture_url
              #raw_input("")
              if(upload(picture_url, counter) == "Success"):
                break
              else:
                print "failure"
          else:
            upload("http://www.sogoodblog.com/wp-content/uploads/2010/07/chips-salsa.jpg", counter)
            print "uploaded default"
        else:
          upload("http://www.sogoodblog.com/wp-content/uploads/2010/07/chips-salsa.jpg", counter)
          print "uploaded default"


def upload(url, index):
    try:
        conn = boto.connect_s3(AWS_ACCESS_KEY_ID, AWS_SECRET_ACCESS_KEY)
        bucket_name = "spork-pictures-2"
        bucket = conn.get_bucket(bucket_name)
        k = Key(bucket)
        k.key = "food_item_" + str(index) + ".jpg"    # In my situation, ids at the end are unique
        file_object = urllib2.urlopen(url)           # 'Like' a file object
        fp = StringIO.StringIO(file_object.read())   # Wrap object    
        k.set_contents_from_file(fp)
        k.set_acl('public-read')
        return "Success"
    except Exception, e:
        return e


def getDishNames():
  dish_names = []
  with open("../db/final_seeds.yml") as f:
    content = f.readlines()
    for line in content:
      if("dish_name" in line):
        start_index = line.find(":")+1
        dish_names.append(str(line[start_index:].strip().replace("\"", "")))
  print len(dish_names)
  raw_input("")
  return dish_names


if __name__ == "__main__":
  main()