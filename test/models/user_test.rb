require 'test_helper'

module ActiveModel
  class Serializer
    def embedded_in_root_associations
      associations = self.class._associations
      included_associations = filter(associations.keys)
      associations.each_with_object({}) do |(name, association), hash|
        if included_associations.include? name
          if association.embed_in_root?
            associated_data = Array(send(association.name))
            hash[association.root_key] = serialize(association, associated_data)
          end
        end
        hash.merge!(association.embedded_in_root_associations)
      end
    end
  end
end

class UserTest < ActiveSupport::TestCase
  test 'its serialization includes the objects from a deeply nested association' do
    profile = Profile.create(title: 'test profile')
    post = Post.create(title: 'test post', content: 'test content', profile: profile)
    user = User.create(name: 'test user', profile: profile)

    assert_equal({
      'user' => {
        name: 'test user',
        profile: {
          title: 'test profile',
          'post_ids' => [post.id]
        }
      },
      'posts' => [
        {
          id: post.id,
          title: 'test post',
          content: 'test content'
        }
      ]
    }, UserSerializer.new(user).as_json)
  end
end
