[![Build Status](https://travis-ci.org/SPBTV/with_uid.svg)](https://travis-ci.org/SPBTV/with_uid)

# WithUid

Generate customizable uid for your ActiveRecord models

## Installation

Add this line to your application's Gemfile:

```ruby
gem 'with_uid'
```

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install with_uid

## Usage

Add `uid` column to your model:

    $ rails generate migration AddUidToUser uid:string -s

Include WithUid module:

```ruby
class User < ActiveRecord::Base
  include WithUid

  generate_uid
end
```

This will generate RFC 4122 compatible uid. You may specify
block to generate `uid` according your own rule. This block
would be executed in `User` instance context.

```ruby
class User < ActiveRecord::Base
  include WithUid

  generate_uid do
    full_name.parameterize
  end
end
```

If you want to generate uid based on some `ActiveRecord` attribute
there is a helper for that:

```ruby
class Post < ActiveRecord::Base
  include WithUid

  humanize_uid_with(:title)
end
```

If humanized attribute is not uniq it will add some random suffix
at the end.

You can customize suffix as well:

```ruby
class Post < ActiveRecord::Base
  include WithUid

  humanize_uid_with(:title, suffix: ->(post) { post.author.uid } )
end
```

It's also possible to add prefix to each uid:

```ruby
class Post < ActiveRecord::Base
  include WithUid

  generate_uid(prefix: 'post_')
end
```

Both `prefix` and `suffix` may be a `String` or a `Proc`.


## Contributing

1. Fork it ( https://github.com/SPBTV/with_uid/fork )
2. Create your feature branch (`git checkout -b feature/my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin feature/my-new-feature`)
5. Create a new Pull Request

##License

Copyright 2014 SPB TV AG

Licensed under the Apache License, Version 2.0 (the ["License"](LICENSE)); you may not use this file except in compliance with the License.

You may obtain a copy of the License at [http://www.apache.org/licenses/LICENSE-2.0](http://www.apache.org/licenses/LICENSE-2.0)

Unless required by applicable law or agreed to in writing, software distributed under the License is distributed on an "AS IS" BASIS, WITHOUT WARRANTIES OR CONDITIONS OF ANY KIND, either express or implied.

See the License for the specific language governing permissions and limitations under the License.
