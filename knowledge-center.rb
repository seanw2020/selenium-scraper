###########################
Knowledge Center (saves images)
###########################
# In the ruby bin folder, create a "pages" folder and a pictures folder inside it
# copy and paste this (thus semicolons, which aren't needed in a ruby script)
# see the copy and paste caveat in comments below
# When done, use Notepad++ to remove the script tags: (\r\n)*<script.*?/script>(\r\n)*
#API http://www.rubydoc.info/gems/selenium-webdriver/0.0.28/Selenium%2FWebDriver%2FDriverExtensions%2FTakesScreenshot%3Ascreenshot_as

require "rubygems" ;
require "selenium-webdriver" ;
require "open-uri"
browser = Selenium::WebDriver.for:firefox ;


browser.get 'http://vanguard.svl.example.com:9235/help/index.jsp' ;
browser.find_element(:name, "username").send_keys("user@example.com") ;
browser.find_element(:name, "password").send_keys("somereallylongdifficultpassword") ;
browser.find_element(:name, "example-submit").click ;

# start with this page
#body = browser.find_element(:tag_name => 'body') ;
#sleep(3)

# start with TOC
browser.switch_to.default_content ;
browser.switch_to.frame('HelpFrame') ;
browser.switch_to.frame('NavFrame') ;
browser.switch_to.frame('ViewsFrame') ;
browser.switch_to.frame(browser.find_element(:xpath, "//iframe[@name='toc']")) ; #iframe
browser.switch_to.frame('tocViewFrame') ;

#click on expander -- run repeatedly to expand them all
loop do ;
  a = browser.find_elements(:xpath, "//img[@alt='Expand topics']") ;
  a.each do |i| ; i.click ; end ;

  break if a.count===0 ;
end 

#get elements
elements = browser.find_elements(:xpath, "//a") ;

j = 0 ;
elements.each do |i| ;
  begin ;
  j=j+1 ;
  i.click ;

  # move to content area
  browser.switch_to.default_content ;
  browser.switch_to.frame('HelpFrame') ;
  browser.switch_to.frame('ContentFrame') ;
  browser.switch_to.frame('ContentViewFrame') ;
  
  sleep(1) ;
  
    # save html -- sanitize with gsub
  File.open(Dir.pwd+"/pages/#{j}. " + browser.find_element(:class, "topictitle1").text.gsub(/[^0-9A-Za-z.\-]/, '_')+".html", 'w') { |file| ; file.write(browser.page_source) } ;
  
    # save images
  imgs = browser.find_elements(:xpath, "//img") ;
  imgs.each do |i| ;
    unless i.attribute("src").include?("ver362") ;
      print "\n\n************ GOT IMAGE *************: \n"+i.attribute("src")+"\n************* \n\n" ; 
      bn=File.basename i.attribute("src") ;
      File.open(Dir.pwd+"/pages/pictures/"+ bn,'wb') do |f| f.write open(i.attribute("src")).read ; end ;
    end ; 
  end ; # when copying and pasting, copy up to here, then copy below section -- TODO

  #back to toc before ending
  browser.switch_to.default_content ;
  browser.switch_to.frame('HelpFrame') ;
  browser.switch_to.frame('NavFrame') ;
  browser.switch_to.frame('ViewsFrame') ;
  browser.switch_to.frame(browser.find_element(:xpath, "//iframe[@name='toc']")) ; #iframe
  browser.switch_to.frame('tocViewFrame') ;
  
  print "WORKED: " + i.attribute("href") + "\n" ;    
  
  rescue ;
    #back to toc before ending
    browser.switch_to.default_content ;
    browser.switch_to.frame('HelpFrame') ;
    browser.switch_to.frame('NavFrame') ;
    browser.switch_to.frame('ViewsFrame') ;
    browser.switch_to.frame(browser.find_element(:xpath, "//iframe[@name='toc']")) ; #iframe
    browser.switch_to.frame('tocViewFrame')
  
    print "BROKEN: " + i.attribute("href") + "\n" ;
    puts $1, $@ ;

    next ;
  end ;
 
end
