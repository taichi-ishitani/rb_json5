[![Gem Version](https://badge.fury.io/rb/rb_json5.svg)](https://badge.fury.io/rb/rb_json5)
![CI](https://github.com/taichi-ishitani/rb_json5/workflows/CI/badge.svg)
[![Maintainability](https://api.codeclimate.com/v1/badges/5f19b310082c03475c83/maintainability)](https://codeclimate.com/github/taichi-ishitani/rb_json5/maintainability)
[![codecov](https://codecov.io/gh/taichi-ishitani/rb_json5/branch/master/graph/badge.svg)](https://codecov.io/gh/taichi-ishitani/rb_json5)
[![Inline docs](http://inch-ci.org/github/taichi-ishitani/rb_json5.svg?branch=master)](http://inch-ci.org/github/taichi-ishitani/rb_json5)

# RbJSON5

[JSON5](https://json5.org/) parser for Ruby

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'rb_json5'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install rb_json5

## Usage

Use `RbJSON5.parse` method to parse JSON5 string.
You can convert property names into `Symbol` by setting `symbolize_names` optional argument to `true`.

```ruby
require 'rb_json5'

# https://github.com/json5/json5#short-example
json5 = <<~'JSON5'
{
   // comments
   unquoted: 'and you can quote me on that',
   singleQuotes: 'I can use "double quotes" here',
   lineBreaks: "Look, Mom! \
 No \\n's!",
   hexadecimal: 0xdecaf,
   leadingDecimalPoint: .8675309, andTrailing: 8675309.,
   positiveSign: +1,
   trailingComma: 'in objects', andIn: ['arrays',],
   "backwardsCompatible": "with JSON",
 }
JSON5

RbJSON5.parse(json5) # =>
                     # {
                     #   "unquoted"=>"and you can quote me on that",
                     #   "singleQuotes"=>"I can use \"double quotes\" here",
                     #   "lineBreaks"=>"Look, Mom! No \\n's!",
                     #   "hexadecimal"=>912559,
                     #   "leadingDecimalPoint"=>0.8675309,
                     #   "andTrailing"=>8675309.0,
                     #   "positiveSign"=>1,
                     #   "trailingComma"=>"in objects",
                     #   "andIn"=>["arrays"],
                     #   "backwardsCompatible"=>"with JSON"
                     # }
RbJSON5.parse(json5, symbolize_names: true) # =>
                                            # {
                                            #   :unquoted=>"and you can quote me on that",
                                            #   :singleQuotes=>"I can use \"double quotes\" here",
                                            #   :lineBreaks=>"Look, Mom! No \\n's!",
                                            #   :hexadecimal=>912559,
                                            #   :leadingDecimalPoint=>0.8675309,
                                            #   :andTrailing=>8675309.0,
                                            #   :positiveSign=>1,
                                            #   :trailingComma=>"in objects",
                                            #   :andIn=>["arrays"],
                                            #   :backwardsCompatible=>"with JSON"
                                            # }
```

## Contributing & Contact

Bug reports, feature requests, pull requests and questions are welcome! You can use following methods:

* [Issue tracker](https://github.com/taichi-ishitani/rb_json5/issues)
* [Pull request](https://github.com/taichi-ishitani/rb_json5/pulls)
* [Mail](mailto:taichi730@gmail.com)

## Note

Test-suite and JSON5 code snippets for RSpec examples are originaly from:

* https://github.com/json5/json5-tests
* https://github.com/json5/json5/blob/master/test/parse.js
* https://github.com/json5/json5/blob/master/test/errors.js
* https://github.com/json5/json5#short-example

## Copyright & License

Copyright &copy; 2020 Taichi Ishitani.
RbJSON5 is licensed under [MIT License](https://opensource.org/licenses/MIT), see [LICENSE](LICENSE) for futher dttails.

## Code of Conduct

Everyone interacting in the RbJson5 project's codebases, issue trackers, chat rooms and mailing lists is expected to follow the [code of conduct](https://github.com/[USERNAME]/rb_json5/blob/master/CODE_OF_CONDUCT.md).
