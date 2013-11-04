require 'test_helper'

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
