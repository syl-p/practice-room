class Comment < ApplicationRecord
  include ActionView::RecordIdentifier
  belongs_to :user
  belongs_to :commentable, polymorphic: true
  belongs_to :parent, optional: true, class_name: "Comment"
  has_many :comments, foreign_key: :parent_id, dependent: :destroy
  validates :body, presence: true

  after_create_commit do
    # broadcast_append_to [commentable, :comments], target: "#{dom_id(parent || commentable)}_comments"
  end

  after_destroy_commit do
    # broadcast_remove_to self
  end

  def content_linkify
    formatted_text = linkify_mentions(body)
    linkify_urls(formatted_text).html_safe
  end

  private
  def linkify_mentions(text)
    text.gsub(/@(\w+)/) do |mention|
      username = mention[1..-1]  # Remove the "@" symbol
      user = User.find_by(username: username)
      if user
        generate_link mention, Rails.application.routes.url_helpers.user_path(user), data: {turbo: false}
      else
        mention
      end
    end
  end

  def linkify_urls(text)
    ActionView::Base.send(:include, Rails.application.routes.url_helpers)
    URI.extract(text, ['http', 'https']).uniq.each do |url|
      linked_url = generate_link(url, url, target: '_blank', rel: 'nofollow', data: {turbo: false})
      text.gsub!(url, linked_url)
    end
    text
  end

  def generate_link(text, url, options = {})
    ActionView::Base.send(:include, Rails.application.routes.url_helpers)
    ActionController::Base.helpers.link_to(text, url, options)
  end
end
