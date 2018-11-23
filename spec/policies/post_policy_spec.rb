# frozen_string_literal: true

require 'rails_helper'

RSpec.describe PostPolicy do
  let(:user) { create :dj }
  let(:editor) { create :dj, :editor }
  let(:superuser) { create :dj, :superuser }

  subject { described_class }

  permissions :create? do
    it 'does not permit normal users' do
      expect(described_class).not_to permit user
    end

    it 'permits editors' do
      expect(described_class).to permit editor
    end

    it 'permits superusers' do
      expect(described_class).to permit superuser
    end
  end

  permissions :update? do
    it 'does not permit normal users' do
      expect(described_class).not_to permit user
    end

    it 'permits editors' do
      expect(described_class).to permit editor
    end

    it 'permits superusers' do
      expect(described_class).to permit superuser
    end
  end

  permissions :destroy? do
    it 'does not permit normal users' do
      expect(described_class).not_to permit user
    end

    it 'permits editors' do
      expect(described_class).to permit editor
    end

    it 'permits superusers' do
      expect(described_class).to permit superuser
    end
  end
end
