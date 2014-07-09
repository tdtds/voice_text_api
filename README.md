# VoiceTextApi

using VoiceText API via ruby. See https://cloud.voicetext.jp/webapi

## Installation

Add this line to your application's Gemfile:

    gem 'voice_text_api'

And then execute:

    $ bundle

Or install it yourself as:

    $ gem install voice_text_api

## Usage

```
require 'voice_text_api'

vt = VoiceTextAPI.new('your api key')

# say "good morning" by Show voice
vt.tts('おはようございます', :show)

# say "hello" happy by Haruka voice
vt.tts('おはよう!', :haruka, emotion: :happiness)

# say "hello" more happy by Haruka voice
vt.tts('おはよう!', :haruka, emotion: :happiness, emotion_level: 2)
```

## Contributing

1. Fork it ( https://github.com/tdtds/voice_text_api/fork )
2. Create your feature branch (`git checkout -b my-new-feature`)
3. Commit your changes (`git commit -am 'Add some feature'`)
4. Push to the branch (`git push origin my-new-feature`)
5. Create a new Pull Request
