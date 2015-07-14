# README

## Introduction

Welcome to PlanPilot, an application developed for [Zero Divide](http://www.zerodivide.org/) by [Digital Strategies](https://www.dstrategies.org)

## Architecture

These sections roughly describe the technologies used in the
development of this application for others who might continue working
on it. While list is extensive, it is comprehensive enough to give a
sense of how the app works. Thanks and enjoy!

## Languages

The app is built primarily with Ruby on Rails, along with some HTML5 and Coffee. It is worth mentioning that we used HAML instead of ERB.

## Testing

The app can benefit from a lot of testing! Currently, Rspec and Capybara are used to test that only authorized users can access their profiles. 

## Security

We’re currently using Devise for authentication. The app also utilizes Dotenv to allow keys to be initialized locally and avoid having them in the codebase.

## APIs

Data comes from these primary sources:

* Healthcare.gov (primarily used for health plan data for the states that are not on the federal exchange, and for glossary terms, but can also be used for blogs/articles)
* Robert Wood Johnson Foundation (used for health plan data not available via the Healthcare.gov data set.)
* GoodRx (used for getting drug prices via their Fair Price endpoints).
* Pokitdok (used to get procedures and pricing).

It’s also worth mentioning that other large datafiles from various
sources are used to seed data like geographical data, Medicaid
information, and the Healthcare.gov HIX datasets.

## Business Logic

Most of the action happens in the pages_controller, in 2 main functions:

* `pages#show`: This method builds the current user’s info and session, which is hidden in a div.
* `build_current_info`: builds the current page and its content in a hash as key value pairs to determine what is shown.

Other supporting methods include the API calls, the Premium Cap Module, and the method `extract_data` which takes in 2 strings (a number and a name) and generates a Hash with the keys `payload` for non-premium data and `keys` for premiums-related data.

Finally, `calc_premium(keys, cons_info)` is used to calculate the premium of plans based on the above with extract_data.

## Contributors

1. [Digital Strategies](https://github.com/DigitalStrategiesCo/)
2. [Nick Caskey](https://github.com/ncaskey04)

## Contributing

We'd love to get your help developing this project! Please contact us via [Twitter](https://twitter.com/zerodivideorg).

## Copyright

Copyright (c) 2006-2015 Zero Divide Inc. See [LICENSE](https://github.com/sferik/twitter/blob/master/LICENSE.md) for details.

# ZeroDivide
