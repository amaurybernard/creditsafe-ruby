# creditsafe-ruby

*Build status: [![Circle CI](https://circleci.com/gh/gocardless/creditsafe-ruby.svg?style=svg&circle-token=3f6e9b24fcc6a57abac110c59395b36032f156a5)](https://circleci.com/gh/gocardless/creditsafe-ruby)*

A ruby library for interacting with the
[Creditsafe](http://www.creditsafeuk.com/) API.

Currently, it only partially implements the API to support finding companies by
registration number (and name in Germany), and retrieving company online reports.

# Installation

Install the gem from RubyGems.org by adding the following to your `Gemfile`:

```ruby
gem 'creditsafe', '~> 0.4.0'
```

Just run `bundle install` to install the gem and its dependencies.

# Usage

Initialise the client with your `username` and `password`.

```ruby
client = Creditsafe::Client.new(username: "foo", password: "bar")

```

### Company Search

To perform a search for a company, you need to provide a valid search criteria, including
the country code and a company registration number or company name:

```ruby
client.companies({ countries: "GB", regNo: "07495895" })
=> {
    name: "GOCARDLESS LTD",
    type: "Ltd",
    status: "Active",
    registration_number: "07495895",
    address: {
        simple_value: "338-346, GOSWELL, LONDON",
        postal_code: "EC1V7LQ"
    },
    available_report_types: { available_report_type: "Full" },
    available_languages: { available_language: "EN" },
    @date_of_latest_accounts: "2014-01-31T00:00:00Z",
    @online_reports: "true",
    @monitoring: "false",
    @country: "GB",
    @id: "GB003/0/07495895"
   }
```


Originaly form GoCardless ♥ open source. If you do too, come [join us](https://gocardless.com/jobs#software-engineer).
Rewrite by [AH3](https://www.ah3.fr)
