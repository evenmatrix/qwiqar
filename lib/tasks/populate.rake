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
    PaymentProcessor.create({:name=>"interswitch",:gateway_interface=>"WebPay"})
    PaymentProcessor.create({:name=>"wallet",:gateway_interface=>"Wallet"})
  end

  task :credit_first_user=> :environment do
    u=User.find 1
    u.wallet.balance=100000
    u.wallet.save
  end

  task :debit_first_user=> :environment do
    u=User.find 1
    u.wallet.balance=0
    u.wallet.save
  end
end