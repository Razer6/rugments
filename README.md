# Rugments

[![Gem Version](https://badge.fury.io/rb/rugments.svg)](http://badge.fury.io/rb/rugments)
[![Build Status](https://travis-ci.org/rumpelsepp/rugments.svg)](https://travis-ci.org/rumpelsepp/rugments)
[![Coverage Status](https://coveralls.io/repos/rumpelsepp/rugments/badge.svg?branch=master)](https://coveralls.io/r/rumpelsepp/rugments?branch=master)
[![Code Climate](https://codeclimate.com/github/rumpelsepp/rugments/badges/gpa.svg)](https://codeclimate.com/github/rumpelsepp/rugments)
[![Inline docs](http://inch-ci.org/github/rumpelsepp/rugments.svg?branch=master)](http://inch-ci.org/github/rumpelsepp/rugments)

Rugments is a syntax highlighter written in Ruby. It has been forked from
[Rouge][] in order to make it work with Gitlab. After some work I decided to
maintain Rugments as my own fork to improve the overall code quality. It can
highlight over 60 languages, and output e.g. HTML or ANSI 256-color text. Its
HTML output is compatible with stylesheets designed for [pygments][]. You
can read the full documentation on [rubydoc.info][].

[Rouge]: https://github.com/jneen/rouge
[pygments]: http://pygments.org/
[rubydoc.info]: http://www.rubydoc.info/github/rumpelsepp/rugments/master/frames


## Warning

Rugments will gain a complete new API which aims to be very close to pygments.
Currently there are no official stable releases yet. Rugments 1.0.0.beta3 just
includes some code style violation fixes and a new [HTML formatter][]. It can
be considered as stable as there are no major changes. If you need documentation
for Rugments 1.0.0.beta3 you still can have a look at Rouge and for the HTML
formatter in the code. Everything else will be updated soon, but it is a lot of
work.

[HTML formatter]: https://github.com/rumpelsepp/rugments/blob/master/lib/rugments/formatters/html.rb


## Usage

``` ruby
require 'rugments'

source = File.read('/etc/bashrc')
formatter = Rugments::Formatters::HTML.new(
  linenos: 'table',
  lineanchors: true,
  anchorlinenos: true
)
lexer = Rugments::Lexer.find_by_name('bash')
puts formatter.render(lexer.lex(source))
```


## You can even use it with Redcarpet

``` ruby
require 'redcarpet'
require 'rugments'
require 'rugments/plugins/redcarpet'

class HTML < Redcarpet::Render::HTML
  include Rouge::Plugins::Redcarpet
end
```

## TODO

If you have `:fenced_code_blocks` enabled, you can specify languages, and even
options with CGI syntax, like `php?start_inline=1`, or `erb?parent=javascript`.
