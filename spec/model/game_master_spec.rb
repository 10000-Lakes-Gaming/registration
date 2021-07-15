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
  context 'Validation' do
    it 'If online table, then warn if no vtt_type' do
      table = tables(:other_one)
      gm_reg = user_events(:admin_other_event)

      gm = table.game_masters.new(user_event: gm_reg, table: table)
      gm.save
      expect(gm.warnings[:vtt_type]).to_not be_empty
    end

    it 'If online table, then warn if no vtt_name' do
      table = tables(:other_one)
      gm_reg = user_events(:admin_other_event)

      gm = table.game_masters.new(user_event: gm_reg, table: table)
      gm.save
      expect(gm.warnings[:vtt_name]).to_not be_empty
    end

    it 'If online table, then warn if no vtt_url' do
      table = tables(:other_one)
      gm_reg = user_events(:admin_other_event)

      gm = table.game_masters.new(user_event: gm_reg, table: table)
      gm.save
      expect(gm.warnings[:vtt_url]).to_not be_empty
    end

    it 'If table is not online, then there can be no vtt_type' do
      table = tables(:one)
      gm_reg = user_events(:admin_my_event)

      gm = table.game_masters.new(user_event: gm_reg, table: table)
      gm.vtt_type = 'Roll20'
      gm.save
      expect(gm.errors[:vtt_type]).to_not be_empty
    end

    it 'If table is not online, then there can be no vtt_name' do
      table = tables(:one)
      gm_reg = user_events(:admin_my_event)

      gm = table.game_masters.new(user_event: gm_reg, table: table)
      gm.vtt_name = 'My Roll20'
      gm.save
      expect(gm.errors[:vtt_name]).to_not be_empty
    end

    it 'If table is not online, then there can be no vtt_url' do
      table = tables(:one)
      gm_reg = user_events(:admin_my_event)

      gm = table.game_masters.new(user_event: gm_reg, table: table)
      gm.vtt_url = 'roll20.net'
      gm.save
      expect(gm.errors[:vtt_url]).to_not be_empty
    end
  end
end
