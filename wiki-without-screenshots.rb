###############################
WIKI (screenshots 1)
###############################

# I ran this in my VM (faster surprisingly than my PC) using irb (thus the semicolons)
# You have to be careful with the wait

#API http://www.rubydoc.info/gems/selenium-webdriver/0.0.28/Selenium%2FWebDriver%2FDriverExtensions%2FTakesScreenshot%3Ascreenshot_as
require "rubygems" ;
require "selenium-webdriver" ;
browser = Selenium::WebDriver.for:firefox ;


browser.get 'https://example.biz/BdHwVB' ;
browser.find_element(:name, "username").send_keys("user@example.com") ;
browser.find_element(:name, "password").send_keys("somereallylongdifficultpassword") ;
browser.find_element(:name, "example-submit").click ;

body = browser.find_element(:tag_name => 'body') ;

# get list of hrefs
hrefs = [] ;
links = browser.find_elements(:xpath, "//div[@id='lconn_wikis_util__NavigationTreeNode_0']//a") ;

links.each do |i| ;
  unless i.attribute("href").nil? || i.attribute("href").include?("javascript") ;
    hrefs.push i.attribute("href") ;
  end ;
end ;

# open hrefs
hrefs.each do |i| ;
  begin ;
	body = browser.find_element(:tag_name => 'body') ; 
	body.send_keys(:control, 't') ;  
	browser.get i ;
	body = browser.find_element(:tag_name => 'body') ;
	browser.manage.timeouts.implicit_wait=3 ; # wait or it can't find title -- example page loads slowly

	title = browser.title ;
    browser.save_screenshot ("#{title}.png") ;
    # browser.manage.timeouts.implicit_wait=3 ; # wait or it can't find title -- example page loads slowly
    sleep(3) ;
    body.send_keys(:control, 'w') ;
	
	print "WORKED: " + i + "\n" ;
  rescue ;
	 print "BROKEN: " + i + "\n" ;
	 puts $1, $@ ;
	 sleep(3) ;
	 body = browser.find_element(:tag_name => 'body') ;

	 retry ;
  end ;
end
