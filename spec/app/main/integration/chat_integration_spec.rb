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

      messages.each do |message|
        expect(page).to have_content (/#{juan[:name]}(.*?)#{message}/)
      end
    end

    it 'allows only logged in user to see messages' do
      find('.dropdown-toggle').click
      click_link 'Logout'

      visit '/chat'

      expect(page).to have_content 'Please Login'
    end
  end

  describe 'message validations' do
    it 'shows an error message for an empty message' do
      visit '/chat'

      find('.form-control').set('' + "\n")
      expect(page).to have_content 'must be at least 2 characters'
    end
  end

  describe 'chats messages' do
    let(:cool_message)    { 'bien' }
    let(:awesome_message) { 'parse' }

    before do
      visit '/chat?index=0'
      find('.form-control').set(cool_message + "\n")

      visit '/chat?index=1'
      find('.form-control').set(awesome_message + "\n")
    end

    it 'shows only messages from cool chat' do
      visit '/'

      all('a')[-2].click

      expect(page).to have_content cool_message
      expect(page).to_not have_content awesome_message
    end

    it 'shows only messages from awesome chat' do
      visit '/'

      all('a')[-1].click

      expect(page).to have_content awesome_message
      expect(page).to_not have_content cool_message
    end
  end
e
