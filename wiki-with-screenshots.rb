################################
WIKI (screenshot version 2)
################################
#API http://www.rubydoc.info/gems/selenium-webdriver/0.0.28/Selenium%2FWebDriver%2FDriverExtensions%2FTakesScreenshot%3Ascreenshot_as
require "rubygems" ;
require "selenium-webdriver" ;
# NOTE "open-uri" WONT work because it doesn't run through Selenium, and you'd need to authenticate
#require "open-uri"
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
    browser.save_screenshot ("#{j}. #{title}.png")

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

