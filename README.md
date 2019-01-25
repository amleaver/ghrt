# GHRT (GitHub Review Tool)

A simple Gem for for extracting your comments made against a PR and using this as a form of checklist
to identify your original comments and whether they have been addressed.

Not my finest piece of work, but a quick conversion of a Ruby script to a Gem so that it could be shared with
other developers.

## Installation

### From RubyGems.org

```gem install ghrt```

### From Source

Clone this repository and run `bundle exec rake install`.

## Usage

* Ensure `GITHUB_USERNAME` is set with your GitHub username
* Ensure `GITHUB_TOKEN` is set with your GitHub token
* Run with `ghrt -p <pr_number> --repo <org/repo> > comments.html` 
  * e.g. `ghrt -p 1234 --repo amleaver/ghrt > comments.html`
  * Full list of argument can be returned with `ghrt -h`

## Development

* Run `bin/setup` to install dependencies
* Run `rake spec` to run the tests (not implemented yet) 
* Run `bin/console` for an interactive prompt that will allow you to experiment

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/amleaver/ghrt.

## License

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).
