# Shared Settings (Ruby)

Shared Settings is a simple library for managing runtime settings in Ruby with optional support for encryption and Elixir.

Heavily inspired by [Fun with Flags][fwf] and [Flipper][flipper].

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'shared-settings'
# Optional
gem 'shared-settings-ui'
```

And then execute:

    $ bundle install

Or install it yourself as:

    $ gem install shared-settings
    $ gem install shared-settings-ui
    
This Gem depends on Redis for the default adapter so ensure that the Redis gem is also installed and configured.

Once installed, the Gem must be configured.  This would normally exist as a file within `config/initializers` if you're using Rails.

```ruby
@client = Redis.new
@adapter = SharedSettings::Persistence::Redis.new(@client)

SharedSettings.configure do |config|
  config.default { SharedSettings.new(@adapter) }
  # Optional. Can be generaed with `SharedSettings::Utilities::Encryption.generate_aes_key`
  # Store this somewhere secure out of VCS
  config.encryption_key = '...'
end
```

The optional UI works with any Rack-based webserver. Assuming you're using Rails, set up your `routes.rb` like so:

```ruby
mount SharedSettings::UI.app, at: '/shared-settings'
```

This doesn't provide any form of protection - anyone could visit this URL.  To add something like basic auth, you can pass a block like so:

```ruby
shared_settings_app = SharedSettings::UI.app do |builder|
  builder.use Rack::Auth::Basic do |username, password|
    # Perform validation
  end
end

mount shared_settings_app, at: '/shared-settings'
```

Elixir support is provided by the [shared-settings-ex][ss-ex] library.

## Why "shared" settings?

The intention for this library is to also create an [accompanying Elixir Library][ss-ex] which uses the same storage adapter, format, and UI found here.

This means that a Rails app could change a runtime setting in an Elixir app and vice-versa.  They would also share a single UI dashboard if configured, allowing a one-stop location to manage parallel apps or to help migration efforts. Of course, this library could be used with Elixir or Ruby individually.

The API/storage conventions are designed to be simple enough that additional libraries in other languages (eg: Go) could be created to allow further interop between applications as long as there was a shared data source.

## Encryption

Encryption is implemented as AES256.  If you choose to provide an encryption key, specified setting values within your storage adapter will be encrypted.  Nothing else about the setting, including its name, will be encrypted.  Once an encrypted setting is requested via `get` it's automatically decrypted so the plaintext value is returned.

```ruby
SharedSettings.put(:client_id, 'supersecret', encrypt: true)
SharedSettings.get(:client_id) # => 'supersecret'
```

## Usage

The API is quite simple.  For most cases, you have `put`, `get`, `delete`, and `exists?`.  

There is also `all` which returns all raw settings, but this is primarily to support UI.

### Supported Types

At a high level, the currently supported types are `string`, `boolean`, `number`, and `range`. `number` includes negative numbers as well as floats. `range`s are inclusive.

All types are serialized as strings to be held within the storage adapter.

### Put

`put` takes a name as well as a value with a supported type. It returns the name of the setting.

```ruby
SharedSettings.put(:signups_enabled, true)
SharedSettings.put(:referral_bonus, 52, encrypt: true)
```

`put` will overwrite old settings if the provided name already exists.  This means there's no method for updating - replacement is the way to go:

```ruby
SharedSettings.put(:confusing_setting, true)
SharedSettings.put(:confusing_setting, 2..7)
```

### Get

`get` takes the name of a setting and returns the value.  A `SettingNotFoundError` is returned if the setting doesn't exist.

```ruby
ranks = SharedSettings.get(:permitted_ranks)
```

### Delete

`delete` takes the name of a setting and removes it from storage.  It's safe to call delete on settings that may not exist.

```ruby
SharedSettings.delete(:contrived_example)
SharedSettings.delete(:not_real)
```

### Exists?

`exists?` takes the name of a setting and returns a boolean reflecting its existence.

```ruby
SharedSettings.exists?(:signups_enabled)
```

### All

`all` returns all stored settings in their raw form.  This is mainly used by the accompanying UI library but it could also be used to ensure all needed flags exist at boot time.

```ruby
SharedSettings.all
```

## License

MIT License

Copyright 2021

Permission is hereby granted, free of charge, to any person obtaining a copy of this software and associated documentation files (the "Software"), to deal in the Software without restriction, including without limitation the rights to use, copy, modify, merge, publish, distribute, sublicense, and/or sell copies of the Software, and to permit persons to whom the Software is furnished to do so, subject to the following conditions:

The above copyright notice and this permission notice shall be included in all copies or substantial portions of the Software.

THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY, FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE SOFTWARE.

[fwf]: https://github.com/tompave/fun_with_flags
[flipper]: https://github.com/jnunemaker/flipper
[ss-ex]: https://github.com/kieraneglin/shared-settings-ex
