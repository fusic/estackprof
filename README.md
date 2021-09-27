# Estackprof

Estackprof is a wrapper to make it easier to use [Stackprof](https://github.com/tmm1/stackprof) in your rack application.

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'estackprof'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install estackprof

## Usage

### Profiling

Add the following code to your rack application to enable the rack middleware.
`Estackprof::Middleware` supports the same options as `StackProf::Middleware`.

```ruby
require 'estackprof'

use Estackprof::Middleware

# ...your rack application
```

### Reporting

Use the CLI to report.

```sh
# Report the top 3 frames
$ estackprof top -l 3
==================================
  Mode: cpu(1000)
  Samples: 516 (0.00% miss rate)
  GC: 77 (14.92%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
       434  (84.1%)         434  (84.1%)     Object#bubble_sort(example/app.rb:9)
        45   (8.7%)          45   (8.7%)     (sweeping)
        31   (6.0%)          31   (6.0%)     (marking)

# Report the top 3 cumlative frames
$ estackprof top -l 3 -c
==================================
  Mode: cpu(1000)
  Samples: 516 (0.00% miss rate)
  GC: 77 (14.92%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
       439  (85.1%)           0   (0.0%)     Rack::MethodOverride#call(vendor/bundle/ruby/3.0.0/gems/rack-2.2.3/lib/rack/method_override.rb:15)
       439  (85.1%)           0   (0.0%)     Sinatra::ExtendedRack#call(vendor/bundle/ruby/3.0.0/gems/sinatra-2.1.0/lib/sinatra/base.rb:215)
       439  (85.1%)           0   (0.0%)     Sinatra::Wrapper#call(vendor/bundle/ruby/3.0.0/gems/sinatra-2.1.0/lib/sinatra/base.rb:1990)

# Report the top frames filtered by patten(file name).
$ estackprof top -p app.rb
==================================
  Mode: cpu(1000)
  Samples: 516 (0.00% miss rate)
  GC: 77 (14.92%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
       434  (84.1%)         434  (84.1%)     Object#bubble_sort(example/app.rb:9)
       438  (84.9%)           0   (0.0%)     block in <main>(example/app.rb:23)

# Report the top frames filtered by patten(method name).
$ estackprof top -p bubble
==================================
  Mode: cpu(1000)
  Samples: 516 (0.00% miss rate)
  GC: 77 (14.92%)
==================================
     TOTAL    (pct)     SAMPLES    (pct)     FRAME
       434  (84.1%)         434  (84.1%)     Object#bubble_sort(example/app.rb:9)

# Report the list in the specified file.
$ estackprof list -f app.rb
                                  |     1  | # frozen_string_literal: true
                                  |     2  | 
                                  |     3  | require 'sinatra'
                                  |     4  | require 'json'
                                  |     5  | require 'estackprof'
                                  |     6  | 
                                  |     7  | use Estackprof::Middleware
                                  |     8  | 
                                  |     9  | def bubble_sort(array)
                                  |    10  |   ary = array.dup
                                  |    11  |   pos_max = ary.size - 1
                                  |    12  | 
  434   (84.1%)                   |    13  |   (0...pos_max).each do |n|
  433   (83.9%)                   |    14  |     (0...(pos_max - n)).each do |ix|
                                  |    15  |       iy = ix + 1
  139   (26.9%) /   139  (26.9%)  |    16  |       ary[ix], ary[iy] = ary[iy], ary[ix] if ary[ix] > ary[iy]
  294   (57.0%) /   294  (57.0%)  |    17  |     end
    1    (0.2%) /     1   (0.2%)  |    18  |   end
                                  |    19  | 
                                  |    20  |   ary
                                  |    21  | end
                                  |    22  | 
                                  |    23  | get '/' do
                                  |    24  |   array = Array.new(1000) { rand(10_000) }
  438   (84.9%)                   |    25  |   bubble_sort(array).to_s
                                  |    26  | end

# Report the list in the specified method.
$ estackprof list -m bubble
Object#bubble_sort (/estackprof/example/app.rb:9)
  samples:   434 self (84.1%)  /    434 total (84.1%)
  callers:
     867  (  199.8%)  Range#each
     434  (  100.0%)  block in <main>
  callees (0 total):
     867  (    Inf%)  Range#each
  code:
                                  |     9  | def bubble_sort(array)
                                  |    10  |   ary = array.dup
                                  |    11  |   pos_max = ary.size - 1
                                  |    12  | 
  434   (84.1%)                   |    13  |   (0...pos_max).each do |n|
  433   (83.9%)                   |    14  |     (0...(pos_max - n)).each do |ix|
                                  |    15  |       iy = ix + 1
  139   (26.9%) /   139  (26.9%)  |    16  |       ary[ix], ary[iy] = ary[iy], ary[ix] if ary[ix] > ary[iy]
  294   (57.0%) /   294  (57.0%)  |    17  |     end
    1    (0.2%) /     1   (0.2%)  |    18  |   end
                                  |    19  |

# Display the flamegraph
$ estackprof flamegraph
#=> Open flamegraph in your browser.
```

## Development

After checking out the repo, run `bin/setup` to install dependencies. Then, run `rake spec` to run the tests. You can also run `bin/console` for an interactive prompt that will allow you to experiment.

To install this gem onto your local machine, run `bundle exec rake install`. To release a new version, update the version number in `version.rb`, and then run `bundle exec rake release`, which will create a git tag for the version, push git commits and the created tag, and push the `.gem` file to [rubygems.org](https://rubygems.org).

## Contributing

Bug reports and pull requests are welcome on GitHub at https://github.com/fusic/estackprof.
