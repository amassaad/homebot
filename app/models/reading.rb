class Reading < ApplicationRecord
  validates :time, :amount, :cost, presence: true
  validates :time, uniqueness: true

  def self.import
    Rails.env.production? ? book = Spreadsheet.open('/app/Downloads/hourly.xls') : book = Spreadsheet.open('public/hourly.xls')

    sheet1 = book.worksheets[0]
    date = sheet1.row(1)[0].to_s.gsub("Hourly Usage for ", '')

    sheet1.each 4 do |row|
      unless row[0].nil?
        puts row unless Rails.env.production?

        r = Reading.new(time:     date + ' ' + row[0],
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

  def self.save
    StatsD.measure('york.app.save_job') do
      begin
        if Rails.env.production?
          download_dir = '/app/Downloads'
        else
          download_dir = '/Users/work/code/hydro_bot/public'
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

        wait25 = Selenium::WebDriver::Wait.new(:timeout => 25)
        wait55 = Selenium::WebDriver::Wait.new(:timeout => 55)

        login_modal = wait25.until {
          element = @browser.find_element(:id, 'btnLRLogin')
          element if element.displayed?
        }
        puts "Test Passed: Login modal found" if login_modal.displayed?

        login_modal.click

        email_element = wait25.until {
          element = @browser.find_element(:name, 'emailid')
          element if element.displayed?
        }
        email_element.send_keys(ENV['HYDRO_EMAIL'])
        puts "Test Passed: Email element found" if email_element.displayed?

        password_element = wait25.until {
          element = @browser.find_element(:id, 'loginradius-raas-login-password')
          element if element.displayed?
        }
        password_element.send_keys(ENV['HYDRO_PASSWORD'])
        puts "Test Passed: password element found" if password_element.displayed?

        form = wait25.until {
          element = @browser.find_element(:name, "loginradius-raas-login")
          element if element.displayed?
        }
        puts "Test Passed: form found" if form.displayed?

        form.find_element(:id, 'loginradius-raas-submit-Login').click

        begin
          wait55.until { @browser.find_element(id: "foo") }
        rescue Selenium::WebDriver::Error::TimeOutError => e
        end
        # lol, security
        @browser.execute_script("SSO.login('BILLING');")


        usage_link = wait55.until {
          element = @browser.find_element(xpath: "//img[@src='https://static.hydroottawa.com//images/account/landing/Bill.svg']")
          element if element.displayed?
        }

        puts "Test Passed: billing link found"

        begin
          wait55.until { @browser.find_element(id: "foo") }
        rescue Selenium::WebDriver::Error::TimeOutError => e
        end

        @browser.get('https://secure.hydroottawa.com/Usage/Secure/TOU/DownloadMyData.aspx')

        usage_file = wait55.until {
          element = @browser.find_element(:id, 'ContentPlaceHolder1_mainContent_imgExcel')
          element if element.displayed?
        }
        puts "Test Passed: usage file found" if usage_file.displayed?
        usage_file.click

        begin
          wait55.until { @browser.find_element(id: "foo") }
        rescue Selenium::WebDriver::Error::TimeOutError => e
          if e.message == 'timed out after 55 seconds (no such element: Unable to locate element: {"method":"id","selector":"foo"}'
            next
          end
        end

        @browser.quit

      rescue Selenium::WebDriver::Error::TimeOutError => e
        if e.message == 'timed out after 25 seconds'
          @browser.quit
          retry
        end
      end
    end
    sleep(25)
  end

  private

  def amount_format(amt)
    amt.gsub('kWh', '').to_f * 1000
  end

  def cost_format(cost)
    (cost * 100).to_i
  end
end
