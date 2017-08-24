class BandwidthUsage < ApplicationRecord
  validates :on_peak_download, :on_peak_upload, :off_peak_download, :off_peak_upload, presence: true
  validates :period, uniqueness: true

   def self.save
    StatsD.measure('bandwidth_usage.save_job') do
      begin
        if Rails.env.production?
          download_dir = '/app/Downloads'
        else
          download_dir = '/Users/work/code/homebot/public'
        end

        ### Chrome settings ####
        prefs = {
          download: {
            prompt_for_download: false,
            default_directory: download_dir
          }
        }

        if Rails.env.production?
          chrome_bin = ENV.fetch('GOOGLE_CHROME_BIN', nil)
        end
        chrome_opts = chrome_bin ? { "chromeOptions" => { "binary" => chrome_bin } } : {}

        @browser = Selenium::WebDriver.for :chrome, profile: prefs, switches: %w[--incognito
                                              --ignore-certificate-errors
                                              --disable-popup-blocking
                                              --disable-translate
                                              --no-sandbox
                                              --disable-gpu
                                              --disable-default-apps
                                              --no-first-run],
                                              desired_capabilities: Selenium::WebDriver::Remote::Capabilities.chrome(chrome_opts)

        @browser.get('https://hydroottawa.com/account')

        wait55 = Selenium::WebDriver::Wait.new(:timeout => 55)

        login_modal = wait55.until {
          element = @browser.find_element(:id, 'btnLRLogin')
          element if element.displayed?
        }
        puts "Test Passed: Login modal found" if login_modal.displayed?

        login_modal.click

        email_element = wait55.until {
          element = @browser.find_element(:id, 'loginradius-raas-login-emailid')
          element if element.displayed?
        }
        email_element.send_keys(ENV['HYDRO_EMAIL'])
        puts "Test Passed: Email element found" if email_element.displayed?

        password_element = wait55.until {
          element = @browser.find_element(:id, 'loginradius-raas-login-password')
          element if element.displayed?
        }
        password_element.send_keys(ENV['HYDRO_PASSWORD'])
        puts "Test Passed: password element found" if password_element.displayed?

        form = wait55.until {
          element = @browser.find_element(:name, "loginradius-raas-login")
          element if element.displayed?
        }
        puts "Test Passed: form found" if form.displayed?

        # form.find_element(:id, 'loginradius-raas-submit-Login').click

        # begin
        #   wait55.until { @browser.find_element(id: "foo") }
        # rescue Selenium::WebDriver::Error::TimeOutError => e
        # end
        # # lol, security
        # @browser.execute_script("SSO.login('BILLING');")


        # usage_link = wait55.until {
        #   element = @browser.find_element(xpath: "//img[@src='https://static.hydroottawa.com//images/account/landing/Bill.svg']")
        #   element if element.displayed?
        # }

        # puts "Test Passed: billing link found"

        # begin
        #   wait55.until { @browser.find_element(id: "foo") }
        # rescue Selenium::WebDriver::Error::TimeOutError => e
        # end

        # @browser.get('https://secure.hydroottawa.com/Usage/Secure/TOU/DownloadMyData.aspx')

        # usage_file = wait55.until {
        #   element = @browser.find_element(:id, 'ContentPlaceHolder1_mainContent_btnExcel')
        #   element if element.displayed?
        # }
        # puts "Test Passed: usage file found" if usage_file.displayed?
        # usage_file.click

        # begin
        #   wait55.until { @browser.find_element(id: "foo") }
        # rescue Selenium::WebDriver::Error::TimeOutError => e
        #   if e.message == 'timed out after 55 seconds (no such element: Unable to locate element: {"method":"id","selector":"foo"}'
        #     next
        #   end
        # end

        @browser.quit

      rescue Selenium::WebDriver::Error::TimeOutError => e
        if e.message == 'timed out after 25 seconds'
          @browser.quit
          retry
        end
      rescue Selenium::WebDriver::Error::StaleElementReferenceError => e
        if e.message == 'stale element reference: element is not attached to the page document'
          @browser.quit
          retry
        end
      end
    end
    sleep(25)
  end
end