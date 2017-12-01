require 'rails_helper'

FactoryBot.factories.map(&:name).each do |factory_name|
  describe "The #{factory_name} factory" do
    it 'is valid' do
      factory = build(factory_name)
      
      expect(factory)
    end
  end
end
