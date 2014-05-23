require 'websocket_messaging/notifier'

WebsocketMessaging::Notifier.bus_connector = -> { Redis.new }