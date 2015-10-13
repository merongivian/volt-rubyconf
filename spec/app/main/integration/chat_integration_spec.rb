require 'spec_helper'

describe 'chat', type: :feature do
  let!(:juan) do
    { name: 'juan', password: 'password', email: 'juan@site.com' }
      .tap do |u|
        store.users << u
      end
  end

  before do
    store._chats.create(name: 'cool chat')
    store._chats.create(name: 'awesome chat')

    log_in(juan[:email], juan[:password])
  end

  describe 'users messages' do
    it "shows messages from juan" do
      messages = ['hola', 'como estas?']

      visit '/chat'

      messages.each do |message|
        find('.form-control').set(message + "\n")
      end

      expect(page).to have_content "juan : #{messages[0]}"
      expect(page).to have_content "juan : #{messages[1]}"
    end
  end

  describe 'message validations' do
    it 'shows an error message for an empty message' do
      visit '/chat'

      find('.form-control').set('' + "\n")
      expect(page).to have_content 'body: must be at least 2 characters'
    end
  end

  describe 'chats messages' do
    before do
      visit '/chat?index=0'
      find('.form-control').set('bien' + "\n")

      visit '/chat?index=1'
      find('.form-control').set('parse' + "\n")
    end

    it 'shows only messages from cool chat' do
      visit '/'

      all('.chat-link')[0].find('a').click

      expect(page).to have_content 'bien'
      expect(page).to_not have_content 'parse'
    end

    it 'shows only messages from awesome chat' do
      visit '/'

      all('.chat-link')[1].find('a').click

      expect(page).to have_content 'parse'
      expect(page).to_not have_content 'bien'
    end
  end
end
