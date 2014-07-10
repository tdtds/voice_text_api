require 'uri'
require 'net/https'
require 'erb'

class VoiceTextAPI
  class BadRequest < StandardError; end
  class Unauthoeized < StandardError; end

  ENDPOINT = URI('https://api.voicetext.jp/v1/tts')
  SPEAKERS = %w(show haruka hikari takeru)
  EMOTIONS = %w(happiness anger sadness)

  # emotion levels
  HIGHT     = 2
  NORMAL    = 1

  def initialize(api_key)
    @api_key = api_key
  end

  def tts(text, speaker = :show, emotion: nil, emotion_level: NORMAL, pitch: 100, speed: 100, volume: 100)
    validate_parameters(speaker, emotion, emotion_level, pitch, speed, volume)

    res = nil
    https = Net::HTTP.new(ENDPOINT.host, 443)
    https.use_ssl = true
    https.start do |https|
      req = create_request(https, text, speaker, emotion, emotion_level, pitch, speed, volume)
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
  def validate_parameters(speaker, emotion, emotion_level, pitch, speed, volume)
    raise ArgumentError.new("wrong speaker: #{speaker}" ) unless SPEAKERS.index(speaker.to_s)
    if speaker != :show && emotion != nil
      raise ArgumentError.new("wrong emotion: #{emotion}" ) unless EMOTIONS.index(emotion.to_s)
    end
    raise ArgumentError.new("wrong emotion_level: #{emotion_level}" ) unless (1..2).include?(emotion_level)
    raise ArgumentError.new("wrong pitch: #{pitch}" ) unless (50..200).include?(pitch)
    raise ArgumentError.new("wrong speed: #{speed}" ) unless (50..200).include?(speed)
    raise ArgumentError.new("wrong volume: #{volume}" ) unless (50..200).include?(volume)
  end

  def create_request(session, text, speaker, emotion, emotion_level, pitch, speed, volume)
    req = Net::HTTP::Post.new(ENDPOINT.path)
    req.basic_auth(@api_key, '')
    s = "text=#{ERB::Util.u(text.encode('UTF-8'))};speaker=#{ERB::Util.u(speaker)}"
    s << ";emotion=#{ERB::Util.u(emotion)}" if emotion
    s << ";emotion_level=#{emotion_level.to_i}" unless emotion_level.to_i == 1
    s << ";pitch=#{pitch.to_i}" unless pitch.to_i == 100
    s << ";speed=#{speed.to_i}" unless speed.to_i == 100
    s << ";volume=#{volume.to_i}" unless volume.to_i == 100
    req.body = s

    return req
  end
end
