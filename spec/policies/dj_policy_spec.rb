# frozen_string_literal: true

require 'rails_helper'

RSpec.describe DjPolicy do
  let(:user) { create :dj }
  let(:superuser) { create :dj, :superuser }

  subject { described_class }

  permissions '.scope' do
    it 'includes everyone for a superuser' do
      active = create :dj, active: true
      inactive = create :dj, active: false

      scope = DjPolicy::Scope.new(superuser, Dj).resolve

      expect(scope).to include active
      expect(scope).to include inactive
    end

    it 'only includes active users for non-superusers' do
      active = create :dj, active: true
      inactive = create :dj, active: false

      scope = DjPolicy::Scope.new(user, Dj).resolve

      expect(scope).to include active
      expect(scope).not_to include inactive
    end
  end

  permissions :index? do
    it 'does not permit non-superusers' do
      expect(described_class).not_to permit user
    end

    it 'permits superusers' do
      expect(described_class).to permit superuser
    end
  end

  permissions :create? do
    it 'does not permit non-superusers' do
      expect(described_class).not_to permit user
    end

    it 'permits superusers' do
      expect(described_class).to permit superuser
    end
  end

  permissions :update? do
    it 'does not permit non-superusers' do
      dj = create :dj
      expect(described_class).not_to permit user, dj
    end

    it 'permits DJs to update themselves' do
      dj = create :dj
      expect(described_class).to permit dj, dj
    end

    it 'permits superusers' do
      dj = create :dj
      expect(described_class).to permit superuser, dj
    end
  end
end
