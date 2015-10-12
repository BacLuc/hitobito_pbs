# encoding: utf-8

#  Copyright (c) 2012-2014, Pfadibewegung Schweiz. This file is part of
#  hitobito_pbs and licensed under the Affero General Public License version 3
#  or later. See the COPYING file at the top-level directory or at
#  https://github.com/hitobito/hitobito_pbs.

require 'spec_helper'

describe EventsPbsHelper do

  context '#expected_participants_value_present?' do

    subject { events(:schekka_camp) }

    it 'returns true if at least one value present' do
      subject.update_attributes(expected_participants_pio_f: 3)
      expect(expected_participants_value_present?(subject)).to be true
    end

    it 'returns false if no value present' do
      expect(expected_participants_value_present?(subject)).to be false
    end

  end

  context '#camp_list_permitting_kantonalverbaende' do

    subject { camp_list_permitting_kantonalverbaende }

    context 'as kantonsleitung' do
      let(:current_user) do
        person = Fabricate(Group::Kantonalverband::Kantonsleitung.name, group: groups(:zh)).person
        Fabricate(Group::Kantonalverband::VerantwortungKrisenteam.name, group: groups(:be), person: person)
        Fabricate(Group::Kantonalverband::VerantwortungKrisenteam.name, group: groups(:zh), person: person)
        person
      end

      it { is_expected.to eq(groups(:be, :zh)) }
    end

    context 'as bundesleitung' do
      let(:current_user) { people(:bulei) }

      it { is_expected.to eq([]) }
    end
  end

  context '#camp_list_permitted_cantons' do

    subject { camp_list_permitted_cantons }

    context 'as kantonsleitung' do
      let(:current_user) do
        person = Fabricate(Group::Kantonalverband::Kantonsleitung.name, group: groups(:zh)).person
        Fabricate(Group::Kantonalverband::VerantwortungKrisenteam.name, group: groups(:be), person: person)
        Fabricate(Group::Kantonalverband::VerantwortungKrisenteam.name, group: groups(:zh), person: person)
        person
      end

      before do
        groups(:be).update!(cantons: %w(be fr ag))
        groups(:zh).update!(cantons: %w(zh ag))
      end

      it do
        is_expected.to eq([['ag', 'Aargau'],
                           ['be', 'Bern'],
                           ['fr', 'Freiburg'],
                           ['zh', 'Zürich']])
      end
    end

    context 'as bundesleitung' do
      let(:current_user) { people(:bulei) }

      it { is_expected.to eq([]) }
    end
  end
end
