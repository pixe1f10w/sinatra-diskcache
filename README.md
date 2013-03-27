# Sinatra-DiskCache [![Gem Version](https://badge.fury.io/rb/sinatra-diskcache.png)](http://badge.fury.io/rb/sinatra-diskcache)

Allows to cache heavy-load query results on the disk.

## Depends on

Nope. It doesn't have any dependencies.

## Install

    gem install sinatra-diskcache

## Usage

Oh, it's pretty easy and straightforward. Look, I'll show you.

```ruby
require 'sinatra'
require 'sinatra/diskcache'

# ... something clever here ...

get '/something' do
    result = diskcache 'somefile' do |file| # this block will be invoked only in case of absence of 'somefile'
        f = File.open file, 'w'

        # heavy load here
        sleep 5

        f.write 'something to be cached'
        f.close
    end

    send_file result # or transfer it anyhow else
end
```

Basically, that's all. For more detailed example you can look [here](https://github.com/pixe1f10w/scalls/).

## Avalilable options

* *diskcache_enabled*

Serves for activation/deactivasion of module. Defaults to 'true'.

* *diskcache_logging*

Activates/deactivates logging, mostly for debug. Defaults to 'true' in development environments.

* *diskcache_expiry_enabled*

Enabled cache file expiration. Period of expiration should be set by *diskcache_expiry_period* (see below). Defaults to 'true'.

* *diskcache_expiry_period*

See above. Value in seconds. Defaults to 3600 (1 hour).

* *diskcache_empty_cleanup*

Enables empty cache file deletion. Default to 'true'.

* *diskcache_path*

Declares the directory where cache files will be stored. Defaults to './diskcache'.

* *diskcache_full_paths*

Enables usage of absolute paths to cached files. Full file path will be passed to processing block and returned by 'diskcache' method. In the example above both 'result' and 'file' variables will have value of '/full/path/to/cached/file'.

Defaults to 'true'.

## License

Copyright © Ilia Zhirov - 2012.

Licensed under terms of [MIT license](http://www.opensource.org/licenses/mit-license.php).

Feel free to fork it, fix any bugs, add features and send me a pull requests. Bug reports are also welcome.
