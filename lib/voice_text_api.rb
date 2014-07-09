require 'uri'
require 'net/https'
require 'erb'

class VoiceTextAPI
  class BadRequest < StandardError; end
  class Unauthoeized < StandardError; end

  # speakers
  SHOW   = :show
  HARUKA = :haruka
  HIKARI = :hikari
  TAKERU = :takeru

  # emotions
  HAPPINESS = :happiness
  ANGER     = :anger
  SADNESS   = :sadness

  # emotion levels
  HIGHT     = 2
  NORMAL    = 1

  def initialize(api_key)
    @api_key = api_key
  end

  def tts(text, speaker = :show, emotion: nil, emotion_level: 1, pitch: 100, speed: 100, volume: 100)
    res = nil
    uri = URI('https://api.voicetext.jp/v1/tts')
    https = Net::HTTP.new(uri.host, 443)
    https.use_ssl = true
    https.start do |https|
      req = Net::HTTP::Post.new(uri.path)
      req.basic_auth(@api_key, '')
      req.body = body(text, speaker, emotion, emotion_level, pitch, speed, volume)
      res = https.request(req)
    end

    case res
    when Net::HTTPOK
      res.body
    when Net::HTTPBadRequest
      raise BadRequest.new(res.body)
    when Net::HTTPUnauthorized
      raise Unauthoeized.new(res.body)
    else
      raise StandardError.new(res.body)
    end
  end

private
  def body(text, speaker, emotion, emotion_level, pitch, speed, volume)
    s = "text=#{ERB::Util.u(text)};speaker=#{ERB::Util.u(speaker)}"
    s << ";emotion=#{ERB::Util.u(emotion)}" if emotion
    s << ";emotion_level=#{emotion_level.to_i}" unless emotion_level.to_i == 1
    s << ";pitch=#{pitch.to_i}" unless pitch.to_i == 100
    s << ";speed=#{speed.to_i}" unless speed.to_i == 100
    s << ";volume=#{volume.to_i}" unless volume.to_i == 100

    return s
  end
end
