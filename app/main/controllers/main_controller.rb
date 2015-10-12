# By default Volt generates this controller for your Main component
module Main
  class MainController < Volt::ModelController
    before_action :require_login, only: :chat

    def index
      # Add code for when the index view is loaded
    end

    def about
      # Add code for when the about view is loaded
    end

    def chat
      reset_message
    end

    private

    def send_message
      current_chat.messages.create(body: page._message_body)
        .then { reset_message }
        .fail do |errors|
          errors.each { |k, v| flash._errors << "#{k}: #{v}" }
        end
    end

    def reset_message
      page._message_body = ''
    end

    def current_chat
      current_index = (params._index || 0).to_i
      store.chats[current_index]
    end

    # The main template contains a #template binding that shows another
    # template.  This is the path to that template.  It may change based
    # on the params._component, params._controller, and params._action values.
    def main_path
      "#{params._component || 'main'}/#{params._controller || 'main'}/#{params._action || 'index'}"
    end

    # Determine if the current nav component is the active one by looking
    # at the first part of the url against the href attribute.
    def active_tab?
      url.path.split('/')[1] == attrs.href.split('/')[1]
    end
  end
end
