require 'test_helper'

class Resolvers::EventsSearchTest < ActiveSupport::TestCase
  def find(args)
    Resolvers::EventsSearch.call(nil, args, nil)
  end

  test 'skip option' do
    event = create :event, title: 'old'
    create :event, title: 'new'

    assert_equal find(skip: 1), [event]
  end

  test 'first option' do
    create :event, title: 'old'
    event = create :event, title: 'new'

    assert_equal find(first: 1), [event]
  end

  test 'filter option' do
    event1 = create :event, title: 'test1', url: 'http://test1.com'
    event2 = create :event, title: 'test2', url: 'http://test2.com'
    event3 = create :event, title: 'test3', url: 'http://test3.com'
    create :event, title: 'test4', url: 'http://test4.com'

    finder = {
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
    puts finder.to_json
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

    assert_equal result.map(&:title).sort, [event1, event2, event3].map(&:title).sort
  end

  test 'order by createdAt_ASC' do
    new = create :event, created_at: 1.week.ago
    old = create :event, created_at: 1.month.ago

    assert_equal find(orderBy: 'createdAt_ASC'), [old, new]
  end

  test 'order by createdAt_DESC' do
    new = create :event, created_at: 1.week.ago
    old = create :event, created_at: 1.month.ago

    assert_equal find(orderBy: 'createdAt_DESC'), [new, old]
  end
end
