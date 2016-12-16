class Note < ApplicationRecord
  belongs_to :parent, class_name: "Note", required: false
  has_many :children, class_name: "Note", foreign_key: "parent_id", dependent: :destroy
  acts_as_taggable

  before_save :populate

  def self.roots
    where(parent: nil)
  end

  def short_title(count)
    (shortened = title.split(" ").take(count).join(" ")).length < title.length ? "#{shortened}..." : title
  end

  def has_link?
    link.present?
  end

  def populate
    return promote_link_to_title if should_promote_link_to_title?

    if title.blank? && link.present?
      page = MetaInspector.new(link)
      self.title = page.best_title
      self.comment = page.description if self.comment.blank?
      set_tags(page) if self.tags.empty?
    end

  rescue
    safe_default
  end

  def should_promote_link_to_title?
    title.blank? && !link.start_with?("http")
  end

  def promote_link_to_title
    self.title = self.link
    self.link = nil
  end

  def safe_default
    self.link = '' if link.blank?
    self.title = link || '' if title.blank?
  end

  def set_tags(page)
    meta_tags = page.meta_tag.dig("name", "keywords").to_s.split(",").map(&:strip).reject { |t| t.scan(/[0-9]/).size > 2 }
    title_tags = (self.title.scan(/[a-z]\S*[a-z]/i).map(&:downcase) - stop_words).join(",")
    self.tag_list = [meta_tags, title_tags].join(",")
  end

  def stop_words
    Stopwords::STOP_WORDS + %w(what's best ask way combines easily)
  end
end
