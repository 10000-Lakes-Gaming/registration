require 'rails_helper'

describe GameMaster do
  fixtures :all

  context '#assigned(user)' do
    it 'User has specific assignment' do
      user = users(:admin)
      gm = game_masters(:gm_admin_two)

      expect(gm.assigned(user)).to be true
    end
  end
end
