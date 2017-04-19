namespace :readings do

  desc "upload to s3 - run locally, or wherever firefox/chrome is sold"

  task upload: :environment do
    file = File.open("public/hourly.xls")
    uploader = HydroUploader.new
    puts "Uploading . . . "
    uploader.store!(file)
    puts "Deleting the file now . . . "
    File.delete(file)
  end

  desc "download from s3 - saves to the application root"

  task download: :environment do
    require 'open-uri'
    download = open('https://s3-us-west-2.amazonaws.com/hydro-bot/hydro_uploads/hourly.xls')
    Rails.env.production? ? IO.copy_stream(download, '/app/hourly.xls') : IO.copy_stream(download, '/Users/work/code/hydro_bot/hourly.xls')
  end

  desc "Import readings to the db from an excel file of hourly readings located in the applicaiton root"

  task import_from_file: :environment do
    if Rails.env.production?
      book = Spreadsheet.open '/app/hourly.xls'
    else
      book = Spreadsheet.open 'public/hourly-default.xls'
    end
    sheet1 = book.worksheets[0]
    sheet1.each 4 do |row|
      unless row[0].nil?
        puts row unless Rails.env.production?

        r = Reading.new(time:     row[0],
                        ratetype: row[1].to_s,
                        amount:   amount_format(row[2]),
                        cost:     cost_format(row[3]))
        begin
          r.save!
        rescue ActiveRecord::RecordInvalid => e
          if e.message == 'Validation failed: Time has already been taken'
            next
          end
        end

      end
    end
  end

  desc "save locally"

  task save_file: :environment do
    begin
      #### Chrome settings ####
      # prefs = {
      #   download: {
      #     prompt_for_download: false,
      #     default_directory: "/Users/work/code/hydro_bot/public"
      #   }
      # }
      #

      profile = Selenium::WebDriver::Firefox::Profile.new
      profile['browser.download.dir'] = "/Users/work/code/hydro_bot/public" 
      profile['browser.download.folderList'] = 2
      profile['browser.helperApps.neverAsk.saveToDisk'] = "application/vnd.ms-excel"
      profile['pdfjs.disabled'] = true

      @browser = Selenium::WebDriver.for :firefox, profile: profile

      # @browser = Selenium::WebDriver.for :chrome, prefs: prefs
      @browser.get('https://hydroottawa.com/account')

      wait = Selenium::WebDriver::Wait.new(:timeout => 5)
      wait25 = Selenium::WebDriver::Wait.new(:timeout => 25)

      login_modal = wait.until {
        element = @browser.find_element(:id, 'btnLRLogin')
        element if element.displayed?
      }
      puts "Test Passed: Login modal found" if login_modal.displayed?

      login_modal.click

      email_element = wait.until {
        element = @browser.find_element(:name, 'emailid')
        element if element.displayed?
      }
      email_element.send_keys(ENV['HYDRO_EMAIL'])
      puts "Test Passed: Email element found" if email_element.displayed?

      password_element = wait.until {
        element = @browser.find_element(:name, 'password')
        element if element.displayed?
      }
      password_element.send_keys(ENV['HYDRO_PASSWORD'])
      puts "Test Passed: password element found" if password_element.displayed?

      form = wait.until {
        element = @browser.find_element(:name, "loginradius-raas-login")
        element if element.displayed?
      }
      puts "Test Passed: form found" if form.displayed?

      form.find_element(:id, 'loginradius-raas-submit-Login').click

      # #Start fix
      begin
        wait25.until { @browser.find_element(id: "foo") }
      rescue Selenium::WebDriver::Error::TimeOutError => e
      end
      @browser.execute_script("SSO.login('BILLING');")


      usage_link = wait25.until {
        element = @browser.find_element(xpath: "//img[@src='https://static.hydroottawa.com//images/account/landing/Bill.svg']")
        element if element.displayed?
      }

      # @browser.find_element(xpath: "//img[@src='https://static.hydroottawa.com//images/account/landing/Bill.svg']").click
      puts "Test Passed: billing link found" 

      begin
        wait25.until { @browser.find_element(id: "foo") }
      rescue Selenium::WebDriver::Error::TimeOutError => e
      end
      
      #possibly programatically click
      @browser.get('https://secure.hydroottawa.com/Usage/Secure/TOU/DownloadMyData.aspx')

      usage_file = wait25.until {
        element = @browser.find_element(:id, 'ContentPlaceHolder1_mainContent_imgExcel')
        element if element.displayed?
      }
      puts "Test Passed: usage file found" if usage_file.displayed?
      usage_file.click

      begin
        wait25.until { @browser.find_element(id: "foo") }
      rescue Selenium::WebDriver::Error::TimeOutError => e
        if e.message == 'timed out after 25 seconds (no such element: Unable to locate element: {"method":"id","selector":"foo"}'
          next
        end
      end

      @browser.quit

    rescue Selenium::WebDriver::Error::TimeOutError => e
      if e.message == 'timed out after 5 seconds'
        @browser.quit
        retry
      end
    end
  end

  def amount_format(amt)
    amt.gsub('kWh', '').to_f * 1000
  end

  def cost_format(cost)
    (cost * 100).to_i
  end
end
