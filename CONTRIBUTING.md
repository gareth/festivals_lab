# Contributing #

Thanks for reading this! Contributions are very welcome via Github pull request, but first bear in mind a couple of general guidelines that I'm starting out with:

* The gem is designed to lightly wrap the Festivals Lab API, and not be too smart about processing the input or output. The API is currently in beta and behaviour is subject to change

* Create separate pull requests for each feature, and try not to include changes that aren't relevant to the request (for example, `.gitignore`)

## Getting started ##

To start hacking at the code, it should be as simple as checking out the code and running the tests

    > git clone https://github.com/gareth/festivals_lab.git
    > cd festivals_lab
    > bundle
    > bundle exec rake
