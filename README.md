# selenium-scraper
This is a sample of Ruby code I wrote to scrape thousands of web pages. I wrote this because the pages, writting in Dojo, were loaded dynamically using javascript, so regular scrapers, like scrapy.org, wouldn't work.

After scraping, I use the create-pdfs.rb to output the results, remove unnecessary html elements, and generally "clean up" the html pre-flight before creating PDFs--all of which I then index and search using solr.
