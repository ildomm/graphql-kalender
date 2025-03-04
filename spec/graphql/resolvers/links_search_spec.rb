require 'rails_helper'

RSpec.describe Resolvers::LinksSearch do
  let(:resolver) { described_class.new(object: nil, context: {}) }

  def find(args)
    resolver.resolve(**args)
  end

  describe 'pagination' do
    it 'supports skip option' do
      link = create(:link, description: 'old')
      create(:link, description: 'new')

      expect(find(skip: 1)).to eq([link])
    end

    it 'supports first option' do
      create(:link, description: 'old')
      link = create(:link, description: 'new')

      expect(find(first: 1)).to eq([link])
    end
  end

  describe 'filtering' do
    it 'supports complex filter options' do
      link1 = create(:link, description: 'test1', url: 'http://test1.com')
      link2 = create(:link, description: 'test2', url: 'http://test2.com')
      link3 = create(:link, description: 'test3', url: 'http://test3.com')
      create(:link, description: 'test4', url: 'http://test4.com')

      result = find(
        filter: {
          description_contains: 'test1',
          OR: [{
            url_contains: 'test2',
            OR: [{
              url_contains: 'test3'
            }]
          }, {
            description_contains: 'test2'
          }]
        }
      )

      expect(result.map(&:description).sort).to eq([link1, link2, link3].map(&:description).sort)
    end
  end

  describe 'ordering' do
    let!(:new_link) { create(:link, created_at: 1.week.ago) }
    let!(:old_link) { create(:link, created_at: 1.month.ago) }

    it 'orders by createdAt_ASC' do
      expect(find(orderBy: 'createdAt_ASC')).to eq([old_link, new_link])
    end

    it 'orders by createdAt_DESC' do
      expect(find(orderBy: 'createdAt_DESC')).to eq([new_link, old_link])
    end
  end
end
