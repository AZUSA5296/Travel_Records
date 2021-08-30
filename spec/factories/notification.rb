FactoryBot.define do
  factory :notification do
    post_id { '1' }
    visiter_id { '2' }
    visited_id { '1' }
    kind { 'favorite' }

    factory :notification2 do
      comment_id { '1' }
      kind { 'comment' }
    end

    factory :notification3 do
      kind { 'follow' }
    end
  end
end
