require 'rails_helper'

RSpec.describe User, type: :model do
  describe '#validations' do
    it 'should have valid factory' do
      user = FactoryBot.build(:user)
      expect(user).to be_valid
    end

    it 'should validate presence of attributes' do
      user = FactoryBot.build(:user, login: nil, provider: nil)
      expect(user).not_to be_valid
      expect(user.errors.messages[:login]).to include("can't be blank")
      expect(user.errors.messages[:provider]).to include("can't be blank")
    end

    it 'should check uniqueness of login' do
      user = FactoryBot.create(:user)
      other_user = FactoryBot.build(:user, login: user.login)
      expect(other_user).not_to be_valid

      other_user.login = 'new-login'
      expect(other_user).to be_valid
    end
  end
end
