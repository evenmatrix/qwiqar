namespace :db do
  desc "Erase and fill carriers"
  task :populate=> :environment do
    Carrier.delete_all
    Carrier.create({:name=>"etisalat",:country_code=>"NG"})
    Carrier.create({:name=>"mtn",:country_code=>"NG"})
    Carrier.create({:name=>"glo",:country_code=>"NG"})
    Carrier.create({:name=>"airtel",:country_code=>"NG"})

    Vault.delete_all
    Vault.create({:name=>"TopUpGenie",:balance=>10000000})

    PaymentProcessor.delete_all
    PaymentProcessor.create({:name=>"Interswitch",:gateway_interface=>"WebPay"})
  end


end