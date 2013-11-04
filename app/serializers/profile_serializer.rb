class ProfileSerializer < ActiveModel::Serializer
  attributes :title
  has_many :posts, embed: :ids, embed_in_root: true
end
