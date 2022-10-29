class Line::V1::LineBotController < ApplicationController
  include Commons
  include ActionController::RequestForgeryProtection
  protect_from_forgery except: [:callback]

  def callback
    body = request.body.read
    signature = request.env['HTTP_X_LINE_SIGNATURE']
    unless client.validate_signature(body, signature)
      return head :bad_request
    end
    events = client.parse_events_from(body)
    events.each do |event|
      case event
      when Line::Bot::Event::Message
        case event.type
        when Line::Bot::Event::MessageType::Text
          message = search_and_create_message_text(event.message['text'])
          client.reply_message(event['replyToken'], message)
        when Line::Bot::Event::MessageType::Location
          message = search_and_create_message(event.message['latitude'], event.message['longitude'])
          client.reply_message(event['replyToken'], message)
        end
      end
    end
    head :ok
  end

  private
    def client
      @client ||= Line::Bot::Client.new { |config|
        config.channel_secret = ENV["LINE_CHANNEL_SECRET"]
        config.channel_token = ENV["LINE_CHANNEL_TOKEN"]
      }
    end

    def search_and_create_message_text(keyword)
      query = {
        'key' => ENV['HOTPEPPER_APPID'],
        'keyword' => keyword,
        'format' => 'json'
      }
      response = get_restaurants(query)
      if response.include?('error')
        text = 
        {
          type: 'text',
          text: "この検索条件に該当する飲食店が見つかりませんでした。\n条件を変えて再検索してください。"
        }
      else
        {
          type: 'flex',
          altText: '飲食店検索の結果です。',
          contents: set_carousel_text(response['shop'])
        }
      end
    end

    def set_carousel_text(shops)
      bubbles = []
      shops.each do |shop|
        bubbles.push set_bubble_text(shop)
      end
      {
        type: 'carousel',
        contents: bubbles
      }
    end

    def set_bubble_text(shop)
      {
        type: 'bubble',
        hero: set_hero(shop),
        body: set_body(shop),
        footer: set_footer_text(shop)
      }
    end

    def search_and_create_message(latitude, longitude)
      query = {
        'key' => ENV['HOTPEPPER_APPID'],
        'lat' => latitude,
        'lng' => longitude,
        'format' => 'json'
      }
      response = get_restaurants(query)
      if response.include?('error')
        text = 
        {
          type: 'text',
          text: "この検索条件に該当する飲食店が見つかりませんでした。\n条件を変えて再検索してください。"
        }
      else
        {
          type: 'flex',
          altText: '飲食店検索の結果です。',
          contents: set_carousel(response['shop'], "#{latitude},#{longitude}")
        }
      end
    end

    def set_carousel(shops, latlng)
      bubbles = []
      shops.each do |shop|
        bubbles.push set_bubble(shop, latlng)
      end
      {
        type: 'carousel',
        contents: bubbles
      }
    end

    def set_bubble(shop, latlng)
      {
        type: 'bubble',
        hero: set_hero(shop),
        body: set_body(shop),
        footer: set_footer(shop, latlng)
      }
    end

    def set_hero(shop)
      {
        type: 'image',
        url: shop['photo']['pc']['l'],
        size: 'full',
        aspectRatio: '20:13',
        aspectMode: 'cover',
        action: {
          type: 'uri',
          uri:  shop['urls']['pc']
        }
      }
    end

    def set_body(shop)
      {
        type: 'box',
        layout: 'vertical',
        contents: [
          {
            type: 'text',
            text: shop['name'],
            wrap: true,
            weight: 'bold',
            size: 'md'
          },
          {
            type: 'box',
            layout: 'vertical',
            margin: 'lg',
            spacing: 'sm',
            contents: [
              {
                type: 'box',
                layout: 'baseline',
                spacing: 'sm',
                contents: [
                  {
                    type: 'text',
                    text: '住所',
                    color: '#aaaaaa',
                    size: 'sm',
                    flex: 1
                  },
                  {
                    type: 'text',
                    text: shop['address'],
                    wrap: true,
                    color: '#666666',
                    size: 'sm',
                    flex: 5
                  }
                ]
              },
              {
                type: 'box',
                layout: 'baseline',
                spacing: 'sm',
                contents: [
                  {
                    type: 'text',
                    text: '料金',
                    color: '#aaaaaa',
                    size: 'sm',
                    flex: 1
                  },
                  {
                    type: 'text',
                    text: shop['budget']['name'],
                    wrap: true,
                    color: '#666666',
                    size: 'sm',
                    flex: 5
                  }
                ]
              }
            ]
          }
        ]
      }
    end

    def set_footer_text(shop)
      {
        type: 'box',
        layout: 'vertical',
        spacing: 'sm',
        contents: [
          {
            type: 'button',
            style: 'link',
            height: 'sm',
            action: {
              type: 'uri',
              label: 'ホットペッパーで開く',
              uri:  shop['urls']['pc']
            }
          },
          {
            type: 'button',
            style: 'link',
            height: 'sm',
            action: {
              type: 'uri',
              label: '地図で見る',
              uri: "https://www.google.com/maps?q=#{shop['lat'].to_s},#{shop['lng'].to_s}"
            }
          },
          {
            type: 'spacer',
            size: 'sm'
          }
        ],
        flex: 0
      }
    end

    def set_footer(shop, latlng)
      {
        type: 'box',
        layout: 'vertical',
        spacing: 'sm',
        contents: [
          {
            type: 'button',
            style: 'link',
            height: 'sm',
            action: {
              type: 'uri',
              label: 'ホットペッパーで開く',
              uri:  shop['urls']['pc']
            }
          },
          {
            type: 'button',
            style: 'link',
            height: 'sm',
            action: {
              type: 'uri',
              label: '地図で経路を見る',
              uri: "https://www.google.com/maps/dir/?api=1&origin=#{latlng}&destination=#{shop['lat'].to_s},#{shop['lng'].to_s}"
            }
          },
          {
            type: 'spacer',
            size: 'sm'
          }
        ],
        flex: 0
      }
    end
end
