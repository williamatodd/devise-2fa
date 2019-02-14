# Devise::TwoFactor

Devise TwoFactor implements two-factor authentication for Devise, using an rfc6238 compatible Time-Based One-Time Password Algorithm.
* Uses [rotp](https://github.com/mdp/rotp) for the generation and verification of codes.
* Uses [RQRCode](https://github.com/whomwah/rqrcode) to generate QR Code PNGs.
* Uses [SymmetricEncryption](https://github.com/rocketjob/symmetric-encryption) to encrypt secrets and recovery codes.

It currently has the following features:

* Url based provisioning of token devices, compatible with multiple applications.
* Browsers can be designated as 'trusted' for a limited time.
* Two-factor authentication can be **optional** at user discretion or **mandatory** (users must enroll OTP after signing-in next time, before they can navigate the site).
* Optionally, users can obtain a list of HOTP recovery tokens to be used for emergency log-in in case the token device is lost or unavailable.

Compatible token devices are:

* [1Password](https://1password.com/)
* [Google Authenticator](https://code.google.com/p/google-authenticator/)
* [FreeOTP](https://fedorahosted.org/freeotp/)

## Installation

Setup the symmetric-encryption gem by following the steps on the (configuration page)[http://rocketjob.github.io/symmetric-encryption/configuration.html]

Add this line to your application's Gemfile:

    gem 'devise'
    gem 'devise-2fa'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install devise-2fa


### Devise Installation

To setup Devise, you need to do the following (but refer to https://github.com/plataformatec/devise for more information)

Install Devise:

    rails g devise:install

Setup the User or Admin model

    rails g devise MODEL

Configure your app for authorization, edit your Controller and add this before_action:

    before_action :authenticate_user!

Make sure your "root" route is configured in config/routes.rb

### Automatic Installation

Run the following generator to add the necessary configuration options to Devise's config file:

    rails g devise_two_factor:install

After you've created your Devise user models (which is usually done with a "rails g devise MODEL"), set up your Devise TwoFactor additions:

    rails g devise_two_factor MODEL

Don't forget to migrate:

    rake db:migrate

### Custom Views

If you want to customize your views (which you likely will want to), you can use the generator:

    rails g devise_two_factor:views

### I18n

The install generator also installs an english copy of a Devise TwoFactor i18n file. This can be modified (or used to create other language versions) and is located at: _config/locales/devise.two_factor.en.yml_


## Usage

With this extension enabled, the following is expected behavior:

* Users may go to _/MODEL/token_ and enable their OTP state, they might be asked to provide their password again (and OTP token, if it's enabled)
* Once enabled they're shown an alphanumeric code (for manual provisioning) and a QR code, for automatic provisioning of their authentication device (for instance, Google Authenticator)
* If config.otp_mandatory or model_instance.otp_mandatory, users will be required to enable, and provision, next time they successfully sign-in.
* Although there's an adjustable drift window, it is important that both the server and the token device (phone) have their clocks set (eg: using NTP).


### Configuration Options

The install generator adds some options to the end of your Devise config file (config/initializers/devise.rb)

* `config.otp_mandatory` - OTP is mandatory, users are going to be asked to enroll the next time they sign in, before they can successfully complete the session establishment.
* `config.otp_authentication_timeout` - how long the user has to authenticate with their token. (defaults to `3.minutes`)
* `config.otp_drift_window` - a window which provides allowance for drift between a user's token device clock (and therefore their OTP tokens) and the authentication server's clock. Expressed in minutes centered at the current time. (default: `3`)
* `config.otp_credentials_refresh` - Users that have logged in longer than this time ago, are going to be asked their password (and an OTP challenge, if enabled) before they can see or change their otp informations. (defaults to `15.minutes`)
* `config.otp_recovery_tokens` - Whether the users are given a list of one-time recovery tokens, for emergency access (default: `10`, set to `false` to disable)
* `config.otp_trust_persistence` - The user is allowed to set his browser as "trusted", no more OTP challenges will be asked for that browser, for a limited time. (default: `1.month`, set to false to disable setting the browser as trusted)
* `config.otp_issuer` - The name of the token issuer, to be added to the provisioning url. Display will vary based on token application. (defaults to the Rails application class)

### Testing

Set up the dummy application with `cd spec/dummy/ && bin/setup` and run tests with `bin/rspec`.

## Contributing

1. Fork it
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create new Pull Request

## Thanks

This extension is a hodgepodge of
[devise-otp](https://github.com/wmlele/devise-otp) which was forked from [devise_google_authenticator](https://github.com/AsteriskLabs/devise_google_authenticator), in conjunction with outstanding pull requests from both libraries.  The changes contained within are a bit too aggressive for existing users, therefore this extension will forge it's own path.

## License

MIT Licensed

Copyright © 2015-2016 William A. Todd
