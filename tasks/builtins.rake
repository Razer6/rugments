require 'pp'

# Download php docs and yield the content of reference files.
def download_and_read_docs
  return enum_for :download_and_read_docs unless block_given?

  tmpdir = '/tmp/rugments'
  php_manual_url = 'http://us3.php.net/distributions/manual/php_manual_en.tar.gz'

  sh "rm -rf #{tmpdir}" if Dir.exist?(tmpdir)
  sh "mkdir -p #{tmpdir}"
  Dir.chdir(tmpdir) do
    sh "curl -L #{php_manual_url} | tar -xz"

    Dir.chdir('./php-chunked-xhtml') do
      Dir.glob('./ref.*').sort.each { |x| yield File.read(x) }
    end
  end
end

# Extract php functions from HTML manual.
def php_builtins
  out = {}

  download_and_read_docs do |file|
    title = Regexp.last_match[1] if file =~ /<title>(.*?) Functions<\/title>/

    next unless title

    functions = file.scan(/<a href="function\..*?\.html">(.*?)<\/a>/)

    # The functions array looks like this:
    #
    # [["is_soap_fault"],
    #  ["is_soap_fault"],
    #  ["use_soap_error_handler"],
    #  ["is_soap_fault"]]
    #
    # Let's convert it to sth. like this:
    #
    # ["is_soap_fault"],
    #  "is_soap_fault",
    #  "use_soap_error_handler",
    #  "is_soap_fault"]
    #
    functions.map!(&:first)

    out[title.to_sym] = functions.uniq
  end

  out
end

namespace :builtins do
  desc 'Generate PHP builtins'
  task :php do
    project_root = File.expand_path(File.join(File.dirname(__FILE__), '..'))
    builtins_path = 'lib/rugments/lexers/php/builtins.rb'

    File.open(File.join(project_root, builtins_path), 'w') do |f|
      f.puts '# Automatically generated by "rake builtins:php".'
      f.puts '# This file should be mixed into the php lexer.'
      f.puts
      f.puts 'module Rugments'
      f.puts '  module Lexers'
      f.puts '    module PHPBuiltins'
      f.puts '      def self.builtins'
      f.print '        @builtins ||= '
      PP.pp php_builtins, f
      f.puts '        end'
      f.puts '      end'
      f.puts '    end'
      f.puts '  end'
      f.puts 'end'
    end
  end
end
