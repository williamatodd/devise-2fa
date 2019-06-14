class DeviseTwoFactorAddLastSuccessfulOtpAtToUsers < ActiveRecord::Migration[5.0]
  def self.up
    change_table :users do |t|
      t.datetime :last_successful_otp_at
    end
  end

  def self.down
    change_table :users do |t|
      t.remove :last_successful_otp_at
    end
  end
end

