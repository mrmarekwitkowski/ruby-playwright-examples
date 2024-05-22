# Ruby Playwright Examples

This repo shall give you a few pointers on how to use the unofficial Playwright Ruby client bindings with the RSpec
framework.

In order to have some comparable results I replicated the default example tests which shipped with my Playwright(TypeScript)
installation. You will find copies of them [here](typescript-examples/demo-todo-app.spec.ts) and [here](typescript-examples/example.spec.ts). 

---

## Table of Contents

- **[Prerequisites](#prerequisites)**
    - [Dependencies overview](#dependencies-overview)
- **[Ruby and TypeScript bindings compared](#ruby-and-typescript-bindings-compared)**
- **[Usage examples](#usage-examples)**
    - [Using the custom binary](#using-the-custom-binary)
    - [RSpec usage examples](#rspec-usage-examples)
    - [parallel_rspec usage examples](#parallelrspec-usage-examples)

---

### Prerequisites

To run the tests you need to install a Ruby version `>=3.0.0` and install the dependencies by
running `bundle install`. Installing a Ruby version manager like rbenv is highly recommended.
Please refer to the official docs if you run into trouble installing any of them.

- [Ruby](https://www.ruby-lang.org/en/)
    - [rbenv](https://github.com/rbenv/rbenv#installation) manage Ruby installations.
    - [ruby-build](https://github.com/rbenv/ruby-build) used by Rbenv for installing Ruby to your system
    - [rbenv-gemset](https://github.com/jf/rbenv-gemset) manage Rubygems
    - [bundler](https://bundler.io/) normally ships with your Ruby installation
- [npm](https://docs.npmjs.com/downloading-and-installing-node-js-and-npm)
- [Playwright](https://playwright.dev/docs/intro)
    - run `npm init playwright@latest` to install the Playwright binaries and example tests

### Dependencies overview

- [playwright-ruby-client](https://github.com/YusukeIwaki/playwright-ruby-client) Unofficial Ruby bindings for
  Playwright
- [RSpec](https://rspec.info/documentation/3.13/rspec-core/) provides a similar syntax to the original Playwright tests
- [parallel_tests](https://github.com/grosser/parallel_tests) run tests in parallel
- [async](https://github.com/socketry/async) run asynchronous tasks in Ruby
- [rubocop](https://github.com/rubocop/rubocop) Ruby linting tool
- [Thor](https://github.com/rails/thor/wiki) CLI build tool

---

### Ruby and TypeScript bindings compared

There are some minor and major differences to keep in mind when playing around with this repo. Bo

- Playwright(TS) is officially supported and developed by the Playwright team. The Ruby client is not official,
  therefore maybe not feature complete or prone to unexpected behaviour. 
  One example I found was e.g. that a particular `.not_to` matcher was severely slowing down the execution.
  Besides that I was able to replicate the tests 1-to-1.
- Playwright(TS) runs in parallel and on all browsers by default, Ruby does not.
- Playwright(TS) runs on headless browsers by default, I made the decision to run tests in `headed` mode by
  default
- Playwright(TS) runs tests against browsers in a sequence (e.g. first on 5 workers using Chrome, then 5 workers on
  Firefox, etc...).

  When running tests with `./bin/run tests --async`, test are actually executed on all browser nodes in
  parallel. A conscious choice of yours truly.
- The Ruby client gem does not provide a test framework out of the box, but you are free to use whatever you like and 
  not forced into a certain syntax. To keep things as close to the originals as possible I decided to use RSpec.
- When 

Beside the points above you will also find small differences like using multiple `*_spec.rb` files instead of putting all
tests in one file only, or some small abstractions like a `TodoPage` page object or `ExamplesHelper` module which you
will not see in the original TS examples. Also the need for a class to lock your Playwright instances is
exclusive to Ruby and not needed when using TS. 

When it comes to what is really important, running tests in a timely manner, you will find that the results are 
very much the same though. When one would use the Async gem as it is implemented here, depending on how you structure 
your tests, they will actually run faster than using TypeScript due to the fact that the browsers are running in parallel
and not as a sequence. 

However, this will most probably not matter that much on most CI environments where workers might be set to `1`. 

#### A few results in comparison

The results might differ on your machine, but my overall 

```shell
# run all tests with Chromium on 2 workers / Typescript
$> npx playwright test tests-examples/demo-todo-app.spec.ts --project chromium --headed -j 2
=> Running 24 tests using 2 workers
  24 passed (9.1s)

# run all tests with Chromium on 2 workers / Ruby
$> ./bin/run tests -f spec/playwright-demo-examples/ -w 2
=> Finished running tests in 9.590173 seconds!

# run all tests with Firefox on 1 worker / TypeScript
$> npx playwright test tests-examples/demo-todo-app.spec.ts --project firefox --headed -j 1
=> Running 24 tests using 1 worker
  24 passed (16.0s)
  
# run all tests with Firefox on 1 worker / Ruby
$> ./bin/run tests -f spec/playwright-demo-examples/ -b firefox
=> Finished running tests in 16.975765 seconds!

# run tests with Playwright default options. Runs tests against Chromium, Firefox and Webkit headless on 5 workers
$> npx playwright test tests-examples/demo-todo-app.spec.ts
=> Running 72 tests using 5 workers
  72 passed (12.9s)

# comparable command using Ruby. Only using 2 workers but all 3 browsers in parallel balancing things out.
$> ./bin/run tests -f spec/playwright-demo-examples/ --async -w 2 --headless
=> Finished running tests in 13.302569 seconds!
```




---

### Usage examples

There a 3 different ways to run the tests

- using  `rspec` directly. This option does not support running tests in parallel
- using  `parallel_rspec` which is a wrapper for the above command to support running tests in parallel
- using the `./bin/run` binary and the underlying Thor CLI. it supports running tests in a sequence, in parallel or
  async

As the `./bin/run` binary provides all available options at once I recommend you to go with it. Only downside to it is
that besides `--tags` all other options you can normally send to the `rspec` or `parallel_rspec` commands are ignored.

### Using the custom binary

You can add the following parameters when running tests with `./bin/run tests`

| option              | desc                                                                                                              |  default | 
|---------------------|:------------------------------------------------------------------------------------------------------------------|---------:|
| --files, -f         | spec file or directory to run                                                                                     |    spec/ | 
| --spec-config, --sc | RSpec config file to load.                                                                                        |    spec/ | 
| --tags, -t          | spec tags to run                                                                                                  |          |
| --workers, -w       | amount of parallel processes                                                                                      |        1 |
| --browser, -b       | browser to run tests against either 'chromium', 'firefox' or 'webkit' <br/>Is ignored when using `--async` option | chromium | 
| --headless          | run tests in headless browser mode                                                                                |    false |
| --async             | run tests against different browsers in parallel                                                                  |    false |
| --async-browsers    | limit async run to e.g. only `--async-browser chromium webkit` ignores the Firefox browser                        |    false |

##### usage examples

```
# runs all tests in /spec directory in Chromium (headed) 
$> ./bin/run tests
    
# runs all tests in /spec/examples directory in Chromium (headed) 
$> ./bin/run tests -f spec/examples


# run tests from specific files or lines
$> ./bin/run tests -f spec/examples/some_spec.rb
$> ./bin/run tests -f spec/examples/some_spec.rb:10:20
    
# runs all tests tagged 'todo_page: true' in Chromium (headed)
$> ./bin/run tests -t todo_page
    
# runs all tests in /spec directory in Firefox (headed)
$> ./bin/run tests -b firefox
    
# runs all tests in /spec directory in Chrome (headless)
$> ./bin/run tests --headless
    
# runs all tests in /spec directory in Firefox (headless)
$> ./bin/run tests --headless -b firefox
    
# runs all tests in /spec directory in Chrome (headed) using 2 parallel processes
$> ./bin/run tests -w 2
    
# runs all tests in /spec directory in Chrome (headed) using 2 parallel processes
$> ./bin/run tests -w 2
    
# runs all tests in /spec directory using Chromium, Firefox and Webkit (all headed) in parallel
$> ./bin/run tests --async
    
# runs all tests in /spec directory using Chromium, Firefox and Webkit (all headed) in parallel
# while each async task runs on 2 workers
$> ./bin/run tests --async -w 2
    
# runs all tests in /spec directory using Chromium and Webkit (all headed) in parallel
$> ./bin/run tests --async --async-browsers chromium webkit
    
# print help 
$> ./bin/run --help
```

### RSpec usage examples

Using the `rspec` command limits you to only being able to run tests in a sequence.

```
# runs all tests in /spec directory in Chromium (headed)
$> rspec
    
# runs all tests in /spec/examples directory in Chromium (headed)
$> rspec spec/examples
    
# runs all tests tagged 'todo_page: true' in Chromium (headed)
$> rspec -t todo_page
  
# runs all tests in /spec directory with Firefox (headed)
$> BROWSER='firefox' rspec
  
# runs all tests in /spec directory with Chromium (headless)
$> HEADLESS='1' rspec
    
# look at all availble rspec options
$> rspec --help
```

### parallel_rspec usage examples

Enables you to run tests in parallel. When the `-n` option is omitted, the number of parallel processes is tied to your
available CPU´s. E.g. running tests on a 4-Core-CPU is the equivalent to `parallel_rspec -n 4`.

```
# runs all tests in /spec directory in Chromium (headed) on CPU`s amount processes.
$> parallel_rspec

# runs all tests in /spec/examples directory in Chromium (headed) on 2 parallel processes.
$> parallel_rspec spec/examples -n 2 
  
# - runs all tests in /spec/playwright-demo-examples directory in Chromium (headed) on 2 parallel processes
# - uses the dedicated .rspec_parallel config which is required for the HTML reports to work correctly
$> parallel_rspec spec/playwright-demo-examples -n 2 -o '-O .rspec_parallel'
 
# you can add additional RSpec options in the single-quoted option string. Below example would run all tests 
# in the spec/ directory with the tag 'todo_page: true' in Chromium (headed) on 2 parallel processes
$> parallel_rspec -n 2 -o '-O .rspec_parallel --tag todo_page'
  
# headless or browser switches work as with 'rspec', e.g. Firefox (headless)
$> HEADLESS='1' BROWSER='firefox' parallel_rspec ... 
```
