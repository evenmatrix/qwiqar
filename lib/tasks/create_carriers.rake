namespace :db do
  desc "Erase and fill carriers"
  task :populate_carriers => :environment do
    Carrier.delete_all
    Carrier.create({:name=>"etisalat",:country_code=>"NG"})
    Carrier.create({:name=>"mtn",:country_code=>"NG"})
    Carrier.create({:name=>"glo",:country_code=>"NG"})
    Carrier.create({:name=>"airtel",:country_code=>"NG"})
  end

  task :delete_contacts => :environment do
    Contact.delete_all
  end
end