class Note < ApplicationRecord
  belongs_to :parent, class_name: "Note", required: false
  has_many :children, class_name: "Note", foreign_key: "parent_id", dependent: :destroy
  acts_as_taggable

  before_save :populate

  def self.roots
    where(parent: nil)
  end

  def has_link?
    link.present?
  end

  def populate
    if title.blank? && link.present?
      page = MetaInspector.new(link)
      self.title = page.best_title
      self.comment = page.description if self.comment.blank?
      if self.tags.empty?
        meta_tags = page.meta_tag.dig("name", "keywords").to_s.split(",").map(&:strip).reject { |t| t.scan(/[0-9]/).size > 2 }
        title_tags = (self.title.scan(/[a-z]\S*[a-z]/i).map(&:downcase) - stop_words).join(",")
        self.tag_list = [meta_tags, title_tags].join(",")
      end
    end
  end

  def stop_words
    Stopwords::STOP_WORDS + %w(what's best ask way combines easily)
  end
end
