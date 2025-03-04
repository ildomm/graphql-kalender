require 'rails_helper'

RSpec.describe Resolvers::EventsSearch do
  let(:resolver) { described_class.new(object: nil, context: {}) }

  def find(args)
    resolver.resolve(**args)
  end

  describe 'pagination' do
    it 'supports skip option' do
      event = create(:event, title: 'old')
      create(:event, title: 'new')

      expect(find(skip: 1)).to eq([event])
    end

    it 'supports first option' do
      create(:event, title: 'old')
      event = create(:event, title: 'new')

      expect(find(first: 1)).to eq([event])
    end
  end

  describe 'filtering' do
    it 'supports complex filter options' do
      event1 = create(:event, title: 'test1', url: 'http://test1.com')
      event2 = create(:event, title: 'test2', url: 'http://test2.com')
      event3 = create(:event, title: 'test3', url: 'http://test3.com')
      create(:event, title: 'test4', url: 'http://test4.com')

      result = find(
        filter: {
          title_contains: 'test1',
          OR: [{
            url_contains: 'test2',
            OR: [{
              url_contains: 'test3'
            }]
          }, {
            title_contains: 'test2'
          }]
        }
      )

      expect(result.map(&:title).sort).to eq([event1, event2, event3].map(&:title).sort)
    end
  end

  describe 'ordering' do
    let!(:new_event) { create(:event, created_at: 1.week.ago) }
    let!(:old_event) { create(:event, created_at: 1.month.ago) }

    it 'orders by createdAt_ASC' do
      expect(find(orderBy: 'createdAt_ASC')).to eq([old_event, new_event])
    end

    it 'orders by createdAt_DESC' do
      expect(find(orderBy: 'createdAt_DESC')).to eq([new_event, old_event])
    end
  end
end
