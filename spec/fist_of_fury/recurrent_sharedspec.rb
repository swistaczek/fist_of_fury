require 'spec_helper'
require 'fist_of_fury/subclass_tracking_sharedspec'

shared_examples_for 'a job with recurrence' do
  it_should_behave_like 'a class that tracks its subclasses'

  after :each do
    Celluloid::Actor.clear_registry
  end

  describe '::schedule' do
    it 'returns a new schedule' do
      schedule = double('schedule')
      FistOfFury::Schedule.stub(:new).and_return(schedule)
      expect(described_class.schedule).to eq schedule
    end
  end

  describe '::last_scheduled_occurrence' do
    it 'calls scheduled_occurrence with the right arguments' do
      expect(described_class).to receive(:scheduled_occurrence).with('last')
      described_class.last_scheduled_occurrence
    end
  end

  describe '::next_scheduled_occurrence' do
    it 'calls scheduled_occurrence with the right arguments' do
      expect(described_class).to receive(:scheduled_occurrence).with('next')
      described_class.next_scheduled_occurrence
    end
  end

  describe '::recurs' do
    it 'evaluate the block within the context of the schedule and sets the options' do
      block = lambda {}
      schedule = double('schedule')
      options = double('optionss')
      described_class.schedule = schedule
      expect(schedule).to receive(:instance_eval)
      expect(schedule).to receive(:options=).with(options)
      described_class.recurs(options, &block)
    end
  end

  describe '::schedule_next' do
    let(:block) { lambda {} }
    let(:time) { double('time') }
    let(:schedule) { double('schedule') }

    it 'delegates to the schedule' do
      described_class.schedule = schedule
      expect(schedule).to receive(:schedule_next).with(time)
      described_class.schedule_next(time, &block)
    end
  end
end
