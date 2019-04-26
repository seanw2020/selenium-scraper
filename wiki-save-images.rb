#################################
WIKI (saves individual images -- but inaccessible -- grr - you'd need Beautifulsoup next)
#################################
# Note, Selenium doesn't give you a way to get html of a given element directly, just browser.page_source
#API http://www.rubydoc.info/gems/selenium-webdriver/0.0.28/Selenium%2FWebDriver%2FDriverExtensions%2FTakesScreenshot%3Ascreenshot_as
require "rubygems" ;
require "selenium-webdriver" ;
require "openSSL"

browser = Selenium::WebDriver.for:firefox ;
browser.get 'https://w3-connections.example.com/wikis/home?lang=en-us#!/wiki/Wd8924e220024_41d5_81c1_2bfb20dca931/page/Get%20Started' ;
browser.find_element(:name, "username").send_keys("user@example.com") ;
browser.find_element(:name, "password").send_keys("somereallylongdifficultpassword") ;
browser.find_element(:name, "example-submit").click ;

body = browser.find_element(:tag_name, 'body') ;

# expand the closed items
loop do ;
  a = browser.find_elements(:xpath, "//img[@class='dijitTreeExpando dijitTreeExpandoClosed']") ;
  a.each do |i| ; i.click ; end ;

  break if a.count===0 ;
end 

# get list of hrefs
links = browser.find_elements(:xpath, "//div[@id='lconn_wikis_util__NavigationTreeNode_0']//a") ;

# first link is bogus, shift removes it
links.shift ;

j = 0 ;
# open hrefs
links.each do |i| ;
  begin ;
    j=j+1 ;

    href = i.attribute("href")

    body = browser.find_element(:tag_name, 'body') ; 
    body.send_keys(:control, 't') ;  
    browser.get href ;
    body = browser.find_element(:tag_name, 'body') ;
    sleep(1)

    title = browser.title ;
    # save html -- sanitize with gsub
      File.open(Dir.pwd+"/pages/#{j}. " + title.gsub(/[^0-9A-Za-z.\-]/, '_')+".html", 'w') { |file| ; file.write(browser.page_source) } ;
  
    # save images
    tabs = [] ;
    imgs = browser.find_elements(:xpath, "//div[@id='wikiContentDiv']//img") ;
    imgs.each do |k| ; unless k.attribute("src").include?("blank") ||  k.attribute("src").include?("photo.do") ; tabs.push k.attribute("src") ; end ; end ;
    
    tabs.each do |k| ;
      begin ;
         print "entered begin\n"
         body = browser.find_element(:tag_name, 'body') ;
         body.send_keys(:control, 't') ; 
         browser.get k ;
         sleep(3)
         body = browser.find_element(:tag_name, 'body') ;
         body.send_keys(:control, 'w') ; 
         print "SUCCESS: " + k +"\n\n" ;
      rescue ;
         print "Enter failed\n"
         body = browser.find_element(:tag_name, 'body') ;
         body.send_keys(:control, 'w') ; 
         print "FAILED: " + k + "\n\n"
         next ;
      end ;
    end ; # when copying and pasting, copy up to here, then copy below section -- TODO


    sleep(1) ;
    body = browser.find_element(:tag_name, 'body') ;
    body.send_keys(:control, 'w') ;
    sleep (1) ;

    print "WORKED: " + href + "\n" ;    
    rescue ;
       print "Broken here" ;
       body.send_keys(:control, 'w') ;
       sleep(2)
       print "BROKEN: " + href + "\n" ;
 
       puts $1, $@ ;
       sleep(1) ;
       body = browser.find_element(:tag_name, 'body') ;

       retry ;
    end ;
end

