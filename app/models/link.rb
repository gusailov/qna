class Link < ApplicationRecord
  belongs_to :linkable, polymorphic: true

  validates :name, :url, presence: true
  validates :url, format: { with: URI::DEFAULT_PARSER.make_regexp, message: 'This is not link' }

  def gist?
    url.match(/gist.github.com/) ? true : false
  end

  def gist_id
    url.split("/").last if self.gist?
  end
end
