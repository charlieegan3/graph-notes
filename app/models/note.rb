require "google/cloud/datastore"

class Note
  include ActiveModel::Model
  include ActiveModel::Validations

  attr_accessor :id, :title, :link, :comment, :parent_id, :parent, :created_at

  validates :title, presence: true

  def parent
    return nil if self.parent_id.blank?
    Note.find(self.parent_id)
  end

  def children
    Note.query(parent_id: self.id)
  end

  def short_title(count)
    (shortened = title.split(" ").take(count).join(" ")).length < title.length ? "#{shortened}..." : title
  end

  def has_link?
    link.present?
  end

  def populate
    if title.blank? && link.present?
      page = MetaInspector.new(link)
      self.title = page.best_title
      self.comment = page.description if self.comment.blank?
    end
  end

  def stop_words
    Stopwords::STOP_WORDS + %w(what's best ask way combines easily)
  end

  def save
    populate
    if valid?
      entity = to_entity
      Note.dataset.save(entity)
      self.id = entity.key.id
      true
    else
      false
    end
  end

  def to_entity
    entity                 = Google::Cloud::Datastore::Entity.new
    entity.key             = Google::Cloud::Datastore::Key.new "Note", id
    entity["title"]        = title
    entity["link"]         = link
    entity["comment"]      = comment
    entity["parent_id"]    = parent_id
    entity["created_at"]   = created_at
    entity
  end

  def update attributes
    attributes.each do |name, value|
      send "#{name}=", value if respond_to? "#{name}="
    end
    save
  end

  def destroy
    children.map(&:destroy)
    Note.dataset.delete(Google::Cloud::Datastore::Key.new("Note", id))
  end

  def persisted?
    id.present?
  end

  def self.dataset
    @dataset ||= Google::Cloud::Datastore.new(
      project: Rails.application.config.
                     database_configuration[Rails.env]["dataset_id"]
    )
  end

  def self.query(options = {})
    query = Google::Cloud::Datastore::Query.new.kind("Note")

    options.each do |key, value|
      query = query.where(key.to_s, "=", value.to_s)
    end

    results = Note.dataset.run(query)
    results.map { |entity| Note.from_entity entity }
  end

  def self.from_entity(entity)
    object = Note.new
    object.id = entity.key.id
    entity.properties.to_hash.each do |name, value|
      object.send("#{name}=", value) if object.respond_to? "#{name}="
    end
    object
  end

  def self.find(id)
    return nil if nil == id

    query = Google::Cloud::Datastore::Key.new("Note", id.to_i)
    entities = dataset.lookup(query)

    from_entity(entities.first) if entities.any?
  end

  def self.delete_all
    all.map(&:key).each do |key|
      Note.dataset.delete(key)
    end
  end

  def self.count
    all.size
  end

  def self.all
    Note.dataset.run(Note.dataset.query("Note"))
  end

  def self.last
    Note.dataset.run(Note.dataset.query("Note").order("created_at")).last
  end
end
